import 'package:ansi_styles/extension.dart';
import 'package:collection/collection.dart';
import 'package:dart_test_adapter/dart_test_adapter.dart';
import 'package:duration/duration.dart';
import 'package:path/path.dart';
import 'package:riverpod/riverpod.dart';

import 'dart_test.dart';
import 'dart_test_utils.dart';
import 'groups.dart';
import 'io.dart';
import 'provider_utils.dart';
import 'suites.dart';
import 'tests.dart';
import 'vt100.dart';

final $suitePath = Provider.autoDispose
    .family<AsyncValue<String?>, Packaged<SuiteKey>>((ref, suiteKey) {
  return merge((unwrap) {
    final suite = unwrap(ref.watch($suite(suiteKey)));
    final workingDir = ref.watch($workingDirectory);

    String? relativeSuitePath;
    if (suite.path != null) {
      // Converting relative suite paths to absolute, such that later calls to
      // [relative] correctly understand what the suite path is based on.
      final absoluteSuitePath =
          join(workingDir.path, suiteKey.packagePath, suite.path);

      relativeSuitePath = relative(absoluteSuitePath, from: workingDir.path);
    }

    return relativeSuitePath;
  });
}, dependencies: [
  $suite,
  $workingDirectory,
]);

final $testPath = Provider.autoDispose
    .family<AsyncValue<String?>, Packaged<TestKey>>((ref, testKey) {
  return merge((unwrap) {
    final suitePath = unwrap(ref.watch($suitePath(testKey.suiteKey)));
    final test = unwrap(ref.watch($test(testKey)));

    return [
      suitePath,
      if (test.line != null && test.column != null)
        '${test.rootLine ?? test.line}:${test.rootColumn ?? test.column}'
    ].join(':');
  });
}, dependencies: [
  $suite,
  $workingDirectory,
]);

final $suiteOutputLabel = Provider.autoDispose
    .family<AsyncValue<String>, Packaged<SuiteKey>>((ref, suiteKey) {
  return merge((unwrap) {
    final relativeSuitePath = unwrap(ref.watch($suitePath(suiteKey)));

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
  $scaffoldGroup,
  $suiteStatus,
  $isEarlyAbort,
  $suitePath,
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
  final interval = Stream.periodic(const Duration(milliseconds: 200), (_) {
    offset++;
    if (offset > 7) offset = 0;
    ref.state = charForOffset(offset);
  });

  ref.onDispose(interval.listen((_) {}).cancel);

  return charForOffset(offset);
});

final $testMessages = Provider.autoDispose
    .family<List<String>, Packaged<TestKey>>((ref, testKey) {
  final events = ref
      .watch($events)
      .events
      .where((e) => e.packagePath == testKey.packagePath)
      .map((e) => e.value);

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
  // if (!ref.watch($isDone)) return null;

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
            suiteStatus: ref.watch($suiteStatus(testKey.suiteKey)),
            testStatus: ref.watch($testStatus(testKey)),
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
  $groupDepth,
  $testsForGroup,
  $testError,
  $testStatus,
  $testLabel,
  $testMessages,
  $childrenGroupsForGroup,
]);

String? _renderTest({
  required TestStatus testStatus,
  required SuiteStatus suiteStatus,
  required List<String> messages,
  required String? error,
  required String? label,
  required int depth,
}) {
  if (suiteStatus == SuiteStatus.fail && !testStatus.failing) return null;
  if (messages.isEmpty && error == null && label == null) return null;

  final paddedError = error?.multilinePadLeft(depth * 2 + 4);

  return [
    if (label != null) label.multilinePadLeft(depth * 2 + 2),
    // TODO preserve message vs error order (messages can show after an error)
    if (testStatus.pending || (testStatus.failing))
      ...messages, // messages are voluntarily not indented
    if (paddedError != null)
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
                suiteStatus: ref.watch($suiteStatus(suiteKey)),
                testStatus: ref.watch($testStatus(testKey)),
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
  $suiteOutputLabel,
  $rootTestsForSuite,
], name: 'suiteOutput');

final $timeTick = StreamProvider.autoDispose<void>((ref) {
  return Stream.periodic(const Duration(milliseconds: 100));
});

final $timeElapsed = Provider.autoDispose<String>((ref) {
  // Keep refreshing the timer only if tests are still pending.
  if (ref.watch($exitCode).isLoading) {
    // Refresh timer every second
    ref.watch($timeTick);
  }

  final startTime = ref.watch($startTime);
  final elapsedTime = DateTime.now().difference(startTime);

  final timeDescription = prettyDuration(elapsedTime);

  return timeDescription;
}, dependencies: [$timeTick, $startTime, $exitCode]);

final $summary = Provider.autoDispose<String?>((ref) {
  final nonEmptySuites = ref.watch($suites).where(
        (suite) => ref
            .watch($testsForSuite(suite.key))
            .values
            .where((e) => !e.isHidden)
            .isNotEmpty,
      );

  final failingSuitesCount = nonEmptySuites
      .where((e) => ref.watch($suiteStatus(e.key)) == SuiteStatus.fail)
      .length;
  final passingSuitesCount = nonEmptySuites
      .where((e) => ref.watch($suiteStatus(e.key)) == SuiteStatus.pass)
      .length;

  final tests =
      ref.watch($allTests).where((test) => !test.value.isHidden).toList();
  final failingTestsCount =
      tests.where((e) => ref.watch($testStatus(e.key)).failing).length;
  final passingTestsCount =
      tests.where((e) => ref.watch($testStatus(e.key)).passing).length;
  final skippedTestsCount =
      tests.where((e) => ref.watch($testStatus(e.key)).skipped).length;

  final suitesDescription = [
    if (failingSuitesCount > 0) '$failingSuitesCount failed'.bold.red,
    if (passingSuitesCount > 0) '$passingSuitesCount passed'.bold.green,
    '${nonEmptySuites.length} total',
  ].join(', ');

  final testsDescription = [
    if (failingTestsCount > 0) '$failingTestsCount failed'.bold.red,
    if (passingTestsCount > 0) '$passingTestsCount passed'.bold.green,
    if (skippedTestsCount > 0) '$skippedTestsCount skipped'.bold.yellow,
    '${tests.length} total',
  ].join(', ');

  final timeElapsed = ref.watch($timeElapsed);

  return '''

${'Test Suites:'.bold} $suitesDescription
${'Tests:'.bold}       $testsDescription
${'Time:'.bold}        $timeElapsed''';
}, dependencies: [
  $suites,
  $allTests,
  $testsForSuite,
  $testStatus,
  $suiteStatus,
  $timeElapsed,
]);

final $showWatchUsage = StateProvider.autoDispose<bool>((ref) {
  // collapse watch usage when the tests are restarted
  ref.watch($events.notifier);

  return false;
}, dependencies: [$events]);

final $isEditingTestNameFilter = StateProvider.autoDispose<bool>((ref) {
  // collapse watch usage when the tests are restarted
  ref.watch($events.notifier);

  return false;
}, dependencies: [$events]);

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

final $errorsInOrder = Provider.autoDispose<String>((ref) {
  final failingTests = ref.watch($allFailedTests);

  return failingTests
      .map(
        (test) => _renderTest(
          testStatus: ref.watch($testStatus(test.key)),
          suiteStatus: ref.watch($suiteStatus(test.suiteKey)),
          messages: ref.watch($testMessages(test.key)),
          error: ref.watch($testError(test.key)),
          depth: 0,
          label: '${'● ${test.value.name}'.bold.red} '
              '${ref.watch($testPath(test.key)).value}',
        ),
      )
      .whereNotNull()
      // Add \n before evert error
      .expand((e) => ['', e])
      .join('\n');
}, dependencies: [
  $allFailedTests,
  $testStatus,
  $suiteStatus,
  $testMessages,
  $testError,
  $testPath,
]);

final $output = Provider.autoDispose<AsyncValue<String>>((ref) {
  return merge((unwrap) {
    if (ref.watch($isEditingTestNameFilter)) {
      return ref.watch($editingTestNameOutput);
    }

    final isDone = ref.watch($isDone);

    final suitesOutput = ref
        // TODO Don't render empty suites (suites with no user-defined test)
        .watch($completedSuiteKeysInCompletionOrder)
        .where(
          (suiteKey) => ref
              .watch($testsForSuite(suiteKey))
              .values
              .where((e) => !e.isHidden)
              .isNotEmpty,
        )
        .where((suiteKey) =>
            ref.watch($suiteStatus(suiteKey)) != SuiteStatus.pending)
        .map((suiteKey) => unwrap(ref.watch($suiteOutput(suiteKey))));

    final loadingSuites = ref
        .watch($suites)
        .where((suite) =>
            ref.watch($suiteStatus(suite.key)) == SuiteStatus.pending)
        .toList();
    final loadingSuitesOutput = loadingSuites
        .take(3)
        .map((suite) => unwrap(ref.watch($suiteOutput(suite.key))))
        .sortedBy((element) => element);

    final result = [
      ...suitesOutput,

      // In CI mode, show summary only after all tests are done
      // Because of the lack of https://github.com/dart-lang/test/issues/1652
      // we have to rely on "isDone" for edge-cases where suites have no tests
      if (isDone || !ref.watch($isCIMode)) ...[
        // TODO(rrousselGit) on signal, test that STOP are rendered before error summary
        ...loadingSuitesOutput,
        // Only show error report on final frame
        if (isDone && ref.watch($errorsInOrder).isNotEmpty)
          ref.watch($errorsInOrder),
        if (loadingSuites.length > 3) 'And ${loadingSuites.length - 3} more.',
        ref.watch($summary)
      ],

      if (ref.watch($events).isInterrupted || ref.watch($isEarlyAbort))
        'Test run was interrupted.'.red,
      if (isDone && ref.watch($isWatchMode) && !ref.watch($isEarlyAbort))
        if (ref.watch($showWatchUsage))
          '''

${'Watch Usage:'.bold}
 › Press f to run only failed tests.
 › Press t to filter by a test name regex pattern.
 › Press q to quit watch mode.
 › Press Enter to trigger a test run.
'''
        else
          '\n${'Watch Usage:'.bold} Press w to show more.',
    ].join('\n');

    if (result.isNotEmpty) return VT100.hideCursor + result;
    return '';
  });
}, dependencies: [
  $errorsInOrder,
  $editingTestNameOutput,
  $isEditingTestNameFilter,
  $events,
  $isEarlyAbort,
  $showWatchUsage,
  $completedSuiteKeysInCompletionOrder,
  $isDone,
  $testsForSuite,
  $suites,
  $suiteOutput,
  $suiteStatus,
  $summary,
  $isCIMode,
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
