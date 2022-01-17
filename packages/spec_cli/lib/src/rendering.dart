import 'package:collection/collection.dart';
import 'package:dart_test_adapter/dart_test_adapter.dart';
import 'package:duration/duration.dart';
import 'package:path/path.dart';
import 'package:riverpod/riverpod.dart';

import 'ansi.dart';
import 'dart_test.dart';
import 'dart_test_utils.dart';
import 'groups.dart';
import 'io.dart';
import 'provider_utils.dart';
import 'suites.dart';
import 'tests.dart';
import 'vt100.dart';

final $suiteOutputLabel = Provider.autoDispose
    .family<AsyncValue<String>, Packaged<SuiteKey>>((ref, suiteKey) {
  return merge((unwrap) {
    final suite = unwrap(ref.watch($suite(suiteKey)));
    final workingDir = ref.watch($workingDirectory);

    String? relativeSuitePath;
    if (suite.path != null) {
      // Converting relative suite paths to absolute, such that later calls to
      // [relative] correctly understand what the suite path is based on.
      final absoluteSuitePath = isRelative(suite.path!)
          // TODO should be based on the package path not the workspace path
          ? join(workingDir.path, suite.path)
          : suite.path!;

      relativeSuitePath = relative(absoluteSuitePath, from: workingDir.path);
    }

    String statusLabel;
    switch (ref.watch($suiteStatus(suiteKey))) {
      case SuiteStatus.fail:
        statusLabel = ' FAIL '.white.bgRed.bold;
        break;
      case SuiteStatus.pass:
        statusLabel = ' PASS '.black.bgGreen.bold;
        break;
      case SuiteStatus.pending:
        statusLabel = ref.watch($isEarlyAbort)
            ? ' STOP '.white.bgGrey.bold
            : ' RUNS '.black.bgYellow.bold;
        break;
    }

    return [
      statusLabel,
      if (relativeSuitePath != null) relativeSuitePath,
    ].join(' ');
  });
}, dependencies: [
  $suite,
  $scaffoldGroup,
  $suiteStatus,
  $isEarlyAbort,
  $workingDirectory,
]);

final $spinner = Provider.autoDispose<String>((ref) {
  String charForOffset(int offset) {
    switch (offset) {
      case 0:
        return '|';
      case 1:
        return r'\';
      case 2:
        return '–';
      case 3:
        return '/';
      case 4:
        return '|';
      case 5:
        return r'\';
      case 6:
        return '–';
      case 7:
        return '/';
      default:
        throw FallThroughError();
    }
  }

  var offset = 0;
  final inverval = Stream.periodic(const Duration(milliseconds: 200), (_) {
    offset++;
    if (offset > 7) offset = 0;
    ref.state = charForOffset(offset);
  });

  ref.onDispose(inverval.listen((_) {}).cancel);

  return charForOffset(offset);
});

final $testMessages = Provider.autoDispose
    .family<List<String>, Packaged<TestKey>>((ref, testKey) {
  final events = ref.watch($events(testKey.packagePath)).events;

  return events
      .whereType<TestEventMessage>()
      // TODO can we have the groupID/suiteID too?
      .where((e) => e.testID == testKey.value.testID)
      .map((e) => e.message)
      .toList();
}, dependencies: [$events]);

final $testLabel =
    Provider.autoDispose.family<String?, Packaged<TestKey>>((ref, testKey) {
  return merge<String?>((unwrap) {
    final test = unwrap(ref.watch($test(testKey)));
    final name = unwrap(ref.watch($testName(testKey)));
    final status = ref.watch($testStatus(testKey));

    if (test.url != null) {
      // Tests with a null URL are non-user-defined tests (such as setup/teardown).
      // They can fail, but we don't want to show their name.
      return status.when(
        pass: () => '${'✓'.green} $name',
        fail: (err, stack) => '${'✕'.red} $name',
        pending: () {
          final pendingLogo =
              ref.watch($isEarlyAbort) ? '○'.yellow : ref.watch($spinner);

          return '$pendingLogo $name';
        },
        // TODO show skipReason
        skip: (skipReason) => '${'○'.yellow} $name',
      );
    }

    return null;
  }).whenOrNull<String?>(data: (data) => data);
}, dependencies: [$test, $testStatus, $spinner, $testName, $isEarlyAbort]);

final $testError =
    Provider.autoDispose.family<String?, Packaged<TestKey>>((ref, testKey) {
  if (!ref.watch($isDone(testKey.packagePath))) return null;

  final status = ref.watch($testStatus(testKey));

  return status.whenOrNull<String?>(
    fail: (err, stack) {
      return '''
$err
${stack.trim()}''';
    },
  );
}, dependencies: [$test, $testStatus, $spinner, $testName, $isDone]);

final AutoDisposeProviderFamily<AsyncValue<String?>, Packaged<GroupKey>>
    $groupOutput = Provider.autoDispose
        .family<AsyncValue<String?>, Packaged<GroupKey>>((ref, groupKey) {
  return merge((unwrap) {
    final groupDepth = unwrap(ref.watch($groupDepth(groupKey)));
    final label = unwrap(ref.watch($groupName(groupKey)));
    final tests = unwrap(ref.watch($testsForGroup(groupKey)));
    final childrenGroups = ref.watch($childrenGroupsForGroup(groupKey));

    final testContent = tests
        .sortedByStatus(ref, groupKey.packagePath)
        .map((test) {
          final testKey = Packaged(groupKey.packagePath, test.key);
          return _renderTest(
            status: ref.watch($testStatus(testKey)),
            hasExitCode: ref.watch($isDone(groupKey.packagePath)),
            messages: ref.watch($testMessages(testKey)),
            error: ref.watch($testError(testKey)),
            label: ref.watch($testLabel(testKey)),
            depth: groupDepth + 1,
          );
        })
        .whereNotNull()
        .join('\n');

    final childrenGroupsContent = childrenGroups
        .map(
          (group) => ref
              .watch($groupOutput(Packaged(groupKey.packagePath, group.key)))
              .asData
              ?.value,
        )
        .whereNotNull()
        .join('\n');

    if (testContent.isEmpty && childrenGroups.isEmpty) return null;

    return [
      label.multilinePadLeft(groupDepth * 2 + 2),
      if (testContent.isNotEmpty) testContent,
      if (childrenGroupsContent.isNotEmpty) childrenGroupsContent,
    ].join('\n');
  });
}, dependencies: [
  $groupName,
  $isDone,
  $groupDepth,
  $testsForGroup,
  $testError,
  $testStatus,
  $testLabel,
  $testMessages,
  $childrenGroupsForGroup,
]);

String? _renderTest({
  required bool hasExitCode,
  required TestStatus status,
  required List<String> messages,
  required String? error,
  required String? label,
  required int depth,
}) {
  if (hasExitCode && !status.failing) return null;
  if (messages.isEmpty && error == null && label == null) return null;

  final paddedError = error?.multilinePadLeft(depth * 2 + 4);

  return [
    if (label != null) label.multilinePadLeft(depth * 2 + 2),
    if (status.pending || (status.failing && hasExitCode))
      ...messages, // messages are voluntarily not indented
    if (paddedError != null && hasExitCode)
      if (messages.isNotEmpty) '\n$paddedError' else paddedError,
  ].join('\n');
}

final $suiteOutput = Provider.autoDispose
    .family<AsyncValue<String>, Packaged<SuiteKey>>((ref, suiteKey) {
  return merge((unwrap) {
    bool showContent;
    switch (ref.watch($suiteStatus(suiteKey))) {
      case SuiteStatus.fail:
        showContent = true;
        break;
      case SuiteStatus.pass:
      case SuiteStatus.pending:
        showContent = false;
        break;
    }

    final rootTestsOutput = showContent
        ? ref
            .watch($rootTestsForSuite(suiteKey))
            .sortedByStatus(ref, suiteKey.packagePath)
            .map((test) {
              final testKey = Packaged(suiteKey.packagePath, test.key);
              return _renderTest(
                status: ref.watch($testStatus(testKey)),
                hasExitCode: ref.watch($isDone(suiteKey.packagePath)),
                messages: ref.watch($testMessages(testKey)),
                error: ref.watch($testError(testKey)),
                label: ref.watch($testLabel(testKey)),
                depth: 0,
              );
            })
            .whereNotNull()
            .join('\n')
        : null;

    final rootGroupsOutput = showContent
        ? ref
            .watch($rootGroupsForSuite(suiteKey))
            .map(
              (group) => ref
                  .watch(
                      $groupOutput(Packaged(suiteKey.packagePath, group.key)))
                  .asData
                  ?.value,
            )
            .whereNotNull()
            .join('\n')
        : null;

    final res = [
      unwrap(ref.watch($suiteOutputLabel(suiteKey))),
      if (rootTestsOutput != null && rootTestsOutput.isNotEmpty)
        rootTestsOutput,
      if (rootGroupsOutput != null && rootGroupsOutput.isNotEmpty)
        rootGroupsOutput,
    ].join('\n');
    return res;
  });
}, dependencies: [
  $suiteStatus,
  $testStatus,
  $rootGroupsForSuite,
  $groupOutput,
  $testLabel,
  $isDone,
  $suiteOutputLabel,
  $rootTestsForSuite,
], name: 'suiteOutput');

final $summary = Provider.autoDispose<String?>((ref) {
  // Don't show the summary until the very last render
  final hasExitCode = ref.watch($isDone);
  if (!hasExitCode) return null;

  final suites = ref.watch($suites);
  final failingSuitesCount = suites
      .where((e) => ref.watch($suiteStatus(e.key)) == SuiteStatus.fail)
      .length;
  final passingSuitesCount = suites
      .where((e) => ref.watch($suiteStatus(e.key)) == SuiteStatus.pass)
      .length;

  final tests = ref.watch($allTests).where((test) => !test.isHidden).toList();
  final failingTestsCount =
      tests.where((e) => ref.watch($testStatus(e.key)).failing).length;
  final passingTestsCount =
      tests.where((e) => ref.watch($testStatus(e.key)).passing).length;
  final skippedTestsCount =
      tests.where((e) => ref.watch($testStatus(e.key)).skipped).length;

  final suitesDescription = [
    if (failingSuitesCount > 0) '$failingSuitesCount failed'.bold.red,
    if (passingSuitesCount > 0) '$passingSuitesCount passed'.bold.green,
    '${suites.length} total',
  ].join(', ');

  final testsDescription = [
    if (failingTestsCount > 0) '$failingTestsCount failed'.bold.red,
    if (passingTestsCount > 0) '$passingTestsCount passed'.bold.green,
    if (skippedTestsCount > 0) '$skippedTestsCount skipped'.bold.yellow,
    '${tests.length} total',
  ].join(', ');

  final startTime = ref.watch($startTime);
  final elapsedTime = DateTime.now().difference(startTime);

  final timeDescription = prettyDuration(elapsedTime);

  return '''
${'Test Suites:'.bold} $suitesDescription
${'Tests:'.bold}       $testsDescription
${'Time:'.bold}        $timeDescription''';
}, dependencies: [
  $isDone,
  $suites,
  $allTests,
  $testStatus,
  $suiteStatus,
  $startTime,
]);

final $showWatchUsage = StateProvider<bool>((ref) {
  // collapse watch usage when the tests are restarted
  ref.watch($events.notifier);

  return false;
}, dependencies: [$events.notifier]);

final $isEditingTestNameFilter = StateProvider<bool>((ref) {
  // collapse watch usage when the tests are restarted
  ref.watch($events.notifier);

  return false;
}, dependencies: [$events.notifier]);

final $editingTestNameTextField = StateProvider.autoDispose((ref) => '');

final $editingTestNameOutput = Provider.autoDispose<String>(
  (ref) {
    return '''
Pattern Mode Usage
 › Press Esc to exit pattern mode.
 › Press Enter to filter by a tests regex pattern.

 pattern › ${ref.watch($editingTestNameTextField)}${VT100.showCursor}''';
  },
  dependencies: [$editingTestNameTextField],
);

final $output = Provider.autoDispose<AsyncValue<String>>((ref) {
  return merge((unwrap) {
    if (ref.watch($isEditingTestNameFilter)) {
      return ref.watch($editingTestNameOutput);
    }

    final isDone = ref.watch($isDone);
    final suites =
        ref.watch($suites).sorted((a, b) => a.testPath!.compareTo(b.testPath!));

    final passingSuites = suites
        .where(
            (suite) => ref.watch($suiteStatus(suite.key)) == SuiteStatus.pass)
        .map((suite) => unwrap(ref.watch($suiteOutput(suite.key))))
        .join('\n');
    final failingSuites = suites
        .where(
            (suite) => ref.watch($suiteStatus(suite.key)) == SuiteStatus.fail)
        .map((suite) => unwrap(ref.watch($suiteOutput(suite.key))))
        .join('\n');
    final loadingSuites = suites
        .where((suite) =>
            ref.watch($suiteStatus(suite.key)) == SuiteStatus.pending)
        .map((suite) => unwrap(ref.watch($suiteOutput(suite.key))))
        .join('\n');

    final summary = ref.watch($summary);

    // During the summary, only show passing suites if there are not failures
    final shouldShowPassingSuites = !isDone || failingSuites.isEmpty;

    final result = [
      if (shouldShowPassingSuites && passingSuites.isNotEmpty) passingSuites,
      if (!isDone && loadingSuites.isNotEmpty) loadingSuites,
      if (failingSuites.isNotEmpty) failingSuites,
      if (summary != null) summary,
      if (ref.watch($events).isInterrupted) 'Test run was interrupted.'.red,
      if (summary != null &&
          ref.watch($isWatchMode) &&
          !ref.watch($isEarlyAbort))
        if (ref.watch($showWatchUsage))
          '''
${'Watch Usage:'.bold}
 › Press a to run all tests.
 › Press f to run only failed tests.
 › Press t to filter by a test name regex pattern.
 › Press q to quit watch mode.
 › Press Enter to trigger a test run.
'''
        else
          '${'Watch Usage:'.bold} Press w to show more.',
    ].join('\n\n');

    if (result.isNotEmpty) return VT100.hideCursor + result;
    return '';
  });
}, dependencies: [
  $editingTestNameOutput,
  $isEditingTestNameFilter,
  $events,
  $isEarlyAbort,
  $showWatchUsage,
  $suites,
  $isDone,
  $suiteOutput,
  $suiteStatus,
  $summary,
  $isWatchMode,
], name: 'output');

extension StringExt on String {
  String multilinePadLeft(int tab) {
    return this.split('\n').map((e) {
      // Don't add padding on empty lines
      if (e.isEmpty) return e;
      return ' ' * tab + e;
    }).join('\n');
  }
}

extension StreamExt<T> on Stream<T> {
  /// Emits the combination of all the previously emitted events and the new event.
  ///
  /// Meaning that by pushing `A` then `B` then `C`, this will emit in order:
  /// - `[A]`
  /// - `[A, B]`
  /// - `[A, B, C]`
  Stream<List<T>> combined() async* {
    final events = <T>[];
    await for (final event in this) {
      events.add(event);
      yield [...events];
    }
  }
}

class FailedTestException implements Exception {
  FailedTestException(this.testError);
  final TestEventTestError testError;
}
