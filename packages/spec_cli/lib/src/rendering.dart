import 'package:dart_test_adapter/dart_test_adapter.dart';
import 'package:riverpod/riverpod.dart';
import 'package:collection/collection.dart';
import 'package:duration/duration.dart';
import 'package:spec_cli/src/io.dart';

import 'dart_test.dart';
import 'dart_test_utils.dart';
import 'groups.dart';
import 'provider_utils.dart';
import 'suites.dart';
import 'ansi.dart';
import 'tests.dart';

final $suiteOutputLabel =
    Provider.family<AsyncValue<String>, SuiteKey>((ref, suiteKey) {
  return merge((unwrap) {
    final suite = unwrap(ref.watch($suite(suiteKey)));
    final suiteStatus = ref.watch($suiteStatus(suiteKey));

    return [
      suiteStatus.map(
        data: (_) => ' PASS '.black.bgGreen.bold,
        error: (_) => ' FAIL '.white.bgRed.bold,
        loading: (_) {
          if (ref.watch($isEarlyAbort)) return ' STOP '.white.bgGrey.bold;
          return ' RUNS '.black.bgYellow.bold;
        },
      ),
      if (suite.path != null) suite.path!,
    ].join(' ');
  });
}, dependencies: [$suite, $scaffoldGroup, $suiteStatus, $isEarlyAbort]);

final $spinner = Provider.autoDispose<String>((ref) {
  String charForOffset(int offset) {
    switch (offset) {
      case 0:
        return '|';
      case 1:
        return '\\';
      case 2:
        return '–';
      case 3:
        return '/';
      case 4:
        return '|';
      case 5:
        return '\\';
      case 6:
        return '–';
      case 6:
        return '/';
      default:
        throw FallThroughError();
    }
  }

  var offset = 0;
  final inverval = Stream.periodic(Duration(milliseconds: 200), (_) {
    offset++;
    if (offset > 6) offset = 0;
    ref.state = charForOffset(offset);
  });

  ref.onDispose(inverval.listen((_) {}).cancel);

  return charForOffset(offset);
});

final $testMessages =
    Provider.autoDispose.family<List<String>, TestKey>((ref, testKey) {
  final events = ref.watch($events);

  return events
      .whereType<TestEventMessage>()
      // TODO can we have the groupID/suiteID too?
      .where((e) => e.testID == testKey.testID)
      .map((e) => e.message)
      .toList();
}, dependencies: [$events]);

final $testLabel =
    Provider.autoDispose.family<String?, TestKey>((ref, testKey) {
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
    Provider.autoDispose.family<String?, TestKey>((ref, testKey) {
  if (!ref.watch($hasExitCode)) return null;

  final status = ref.watch($testStatus(testKey));

  return status.whenOrNull<String?>(
    fail: (err, stack) {
      return '''
$err
${stack.trim()}''';
    },
  );
}, dependencies: [$test, $testStatus, $spinner, $testName, $hasExitCode]);

final AutoDisposeProviderFamily<AsyncValue<String?>, GroupKey> $groupOutput =
    Provider.autoDispose.family<AsyncValue<String?>, GroupKey>((ref, groupKey) {
  return merge((unwrap) {
    final groupDepth = unwrap(ref.watch($groupDepth(groupKey)));
    final label = unwrap(ref.watch($groupName(groupKey)));
    final tests = unwrap(ref.watch($testsForGroup(groupKey)));
    final childrenGroups = ref.watch($childrenGroupsForGroup(groupKey));

    final testContent = tests
        .sortedByStatus(ref)
        .map((test) {
          return _renderTest(
            status: ref.watch($testStatus(test.key)),
            hasExitCode: ref.watch($hasExitCode),
            messages: ref.watch($testMessages(test.key)),
            error: ref.watch($testError(test.key)),
            label: ref.watch($testLabel(test.key)),
            depth: groupDepth + 1,
          );
        })
        .whereNotNull()
        .join('\n');

    final childrenGroupsContent = childrenGroups
        .map((group) => ref.watch($groupOutput(group.key)).asData?.value)
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
  $hasExitCode,
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

  error = error?.multilinePadLeft(depth * 2 + 4);

  return [
    if (label != null) label.multilinePadLeft(depth * 2 + 2),
    if (status.pending || (status.failing && hasExitCode))
      ...messages, // messages are voluntarily not indented
    if (error != null && hasExitCode)
      if (messages.isNotEmpty) '\n$error' else error,
  ].join('\n');
}

final $suiteOutput =
    Provider.autoDispose.family<AsyncValue<String>, SuiteKey>((ref, suiteKey) {
  return merge((unwrap) {
    final suiteStatus = ref.watch($suiteStatus(suiteKey));
    final showContent = suiteStatus.map(
      data: (_) => false,
      error: (_) => true,
      loading: (_) => true,
    );

    final rootTestsOutput = showContent
        ? ref
            .watch($rootTestsForSuite(suiteKey))
            .sortedByStatus(ref)
            .map((test) {
              return _renderTest(
                status: ref.watch($testStatus(test.key)),
                hasExitCode: ref.watch($hasExitCode),
                messages: ref.watch($testMessages(test.key)),
                error: ref.watch($testError(test.key)),
                label: ref.watch($testLabel(test.key)),
                depth: 0,
              );
            })
            .whereNotNull()
            .join('\n')
        : null;

    final rootGroupsOutput = showContent
        ? ref
            .watch($rootGroupsForSuite(suiteKey))
            .map((group) => ref.watch($groupOutput(group.key)).asData?.value)
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
  $hasExitCode,
  $suiteOutputLabel,
  $rootTestsForSuite,
]);

final $summary = Provider.autoDispose<String?>((ref) {
  // Don't show the summary until the very last render
  final exitCode = ref.watch($exitCode);
  if (exitCode is! AsyncData) return null;

  final suites = ref.watch($suites);
  final failingSuitesCount =
      suites.where((e) => ref.watch($suiteStatus(e.key)) is AsyncError).length;
  final passingSuitesCount =
      suites.where((e) => ref.watch($suiteStatus(e.key)) is AsyncData).length;

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
  $exitCode,
  $suites,
  $allTests,
  $testStatus,
  $suiteStatus,
  $startTime,
]);

final $output = Provider.autoDispose<AsyncValue<String>>((ref) {
  return merge((unwrap) {
    final isDone = ref.watch($hasExitCode);
    final suites =
        ref.watch($suites).sorted((a, b) => a.path!.compareTo(b.path!));

    final passingSuites = suites
        .where((suite) => ref.watch($suiteStatus(suite.key)) is AsyncData)
        .map((suite) => unwrap(ref.watch($suiteOutput(suite.key))))
        .join('\n');
    final failingSuites = suites
        .where((suite) => ref.watch($suiteStatus(suite.key)) is AsyncError)
        .map((suite) => unwrap(ref.watch($suiteOutput(suite.key))))
        .join('\n');
    final loadingSuites = suites
        .where((suite) => ref.watch($suiteStatus(suite.key)) is AsyncLoading)
        .map((suite) => unwrap(ref.watch($suiteOutput(suite.key))))
        .join('\n');

    final summary = ref.watch($summary);

    // During the summary, only show passing suites if there are not failures
    final shouldShowPassingSuites = !isDone || failingSuites.isEmpty;

    return [
      if (shouldShowPassingSuites && passingSuites.isNotEmpty) passingSuites,
      if (!isDone && loadingSuites.isNotEmpty) loadingSuites,
      if (failingSuites.isNotEmpty) failingSuites,
      if (summary != null) summary,
    ].join('\n\n');
  });
}, dependencies: [
  $suites,
  $hasExitCode,
  $suiteOutput,
  $suiteStatus,
  $summary,
]);

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
