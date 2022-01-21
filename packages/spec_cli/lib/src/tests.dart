import 'package:dart_test_adapter/dart_test_adapter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod/riverpod.dart';

import 'collection.dart';
import 'dart_test.dart';
import 'dart_test_utils.dart';
import 'groups.dart';
import 'provider_utils.dart';
import 'suites.dart';

part 'tests.freezed.dart';

@freezed
class TestStatus with _$TestStatus {
  const TestStatus._();

  const factory TestStatus.pass() = _TestStatusPass;
  const factory TestStatus.fail(
    String error, {
    required String stackTrace,
  }) = _TestStatusFail;
  const factory TestStatus.skip({String? skipReason}) = _TestStatusSkip;
  const factory TestStatus.pending() = _TestStatusPending;

  bool get passing => this is _TestStatusPass;
  bool get failing => this is _TestStatusFail;
  bool get skipped => this is _TestStatusSkip;
  bool get pending => this is _TestStatusPending;
}

final $rootTestsForSuite = Provider.autoDispose
    .family<List<Test>, Packaged<SuiteKey>>((ref, suiteKey) {
  final testsForSuite = ref.watch($testsForSuite(suiteKey));

  return testsForSuite.values
      // Tests with no groups are errored tests such as when there is a compilation error.
      // Tests with a single group are user-defined tests, since that group is added implicitly
      .where((test) => test.groupIDs.length < 2)
      .toList();
}, dependencies: [$testsForSuite]);

final $testName = Provider.autoDispose
    .family<AsyncValue<String>, Packaged<TestKey>>((ref, testKey) {
  return merge((unwrap) {
    final test = unwrap(ref.watch($test(testKey)));
    final parentGroup = test.groupKey != null
        ? unwrap(
            ref.watch($group(Packaged(testKey.packagePath, test.groupKey!))),
          )
        : null;

    // Tests without groups or tests where their group is the [$scaffoldGroup]
    // have their correct name
    if (parentGroup == null || parentGroup.parentID == null) {
      return test.name;
    }

    // test names are the concatenation of their name plus their parent's name
    // and a whitespace. So to determine the true group name, we're removing those
    return test.name.substring(parentGroup.name.length + 1);
  });
}, dependencies: [$test]);

final $testsForGroup = Provider.autoDispose
    .family<AsyncValue<List<Test>>, Packaged<GroupKey>>((ref, groupKey) {
  return merge((unwrap) {
    final group = unwrap(ref.watch($group(groupKey)));
    final testsForSuite = ref
        .watch($testsForSuite(Packaged(groupKey.packagePath, group.suiteKey)));

    return testsForSuite.values
        .where((test) => test.groupKey == groupKey.value)
        .toList();
  });
}, dependencies: [$testsForSuite]);

final $testsForSuite = Provider.autoDispose
    .family<Map<Packaged<TestKey>, Test>, Packaged<SuiteKey>>((ref, suiteKey) {
  return Map.fromEntries(
    ref
        .watch($events)
        .events
        .where((e) => e.packagePath == suiteKey.packagePath)
        .map((e) => e.value)
        .whereType<TestEventTestStart>()
        .where((event) => event.test.suiteKey == suiteKey.value)
        .where((event) => !event.test.isHidden)
        .map((e) =>
            MapEntry(Packaged(suiteKey.packagePath, e.test.key), e.test)),
  );
}, dependencies: [$events]);

final $test = Provider.autoDispose.family<AsyncValue<Test>, Packaged<TestKey>>(
    (ref, testKey) {
  return ref
      .watch($events)
      .events
      .where((e) => e.packagePath == testKey.packagePath)
      .map((e) => e.value)
      .whereType<TestEventTestStart>()
      .where((event) => event.test.key == testKey.value)
      .map((e) => e.test)
      .firstDataOrLoading;
}, dependencies: [$events]);

final $allTests = Provider.autoDispose<List<Packaged<Test>>>((ref) {
  return ref.watch($events).events.expand<Packaged<Test>>((e) {
    final value = e.value;
    if (value is! TestEventTestStart) return const [];
    return [Packaged(e.packagePath, value.test)];
  }).toList();
}, dependencies: [$events]);

final $allFailedTests = Provider.autoDispose<List<Packaged<Test>>>((ref) {
  return ref
      .watch($allTests)
      .where((test) => ref.watch($testStatus(test.key)).failing)
      .toList();
}, dependencies: [$allTests, $testStatus]);

final $testStatus =
    Provider.autoDispose.family<TestStatus, Packaged<TestKey>>((ref, testKey) {
  final test = ref.watch($test(testKey)).value;
  if (test == null) return const TestStatus.pending();

  // Rely on test metadatas to determine if a test is skipped instead of the
  // done event's "skipped" property, because the latter will arrive later.
  // This ensures that we're not showing the test as "pending" when it's known
  // to be skipped.
  if (test.metadata.skip) {
    return TestStatus.skip(skipReason: test.metadata.skipReason);
  }

  final events = ref
      .watch($events)
      .events
      .where((e) => e.packagePath == testKey.packagePath)
      .map((e) => e.value)
      .toList();

  final error = events
      .whereType<TestEventTestError>()
      // TODO can we have the groupID/suiteID too?
      .where((e) => e.testID == testKey.value.testID)
      .firstOrNull;
  if (error != null) {
    return TestStatus.fail(
      error.error,
      stackTrace: error.stackTrace,
    );
  }

  final done = events
      .whereType<TestEventTestDone>()
      // TODO can we have the groupID/suiteID too?
      .where((e) => e.testID == testKey.value.testID)
      .firstOrNull;

  if (done != null) {
    assert(
      !done.skipped && done.result == TestDoneStatus.success,
      'Failing tests should already be dealt with previously',
    );
    return const TestStatus.pass();
  }

  return const TestStatus.pending();
}, dependencies: [$events]);

final $currentlyFailedTestsLocation =
    Provider.autoDispose<AsyncValue<List<FailedTestLocation>>>((ref) {
  return merge((unwrap) {
    final packages = unwrap(ref.watch($packages));

    return packages
        .expand((package) {
          final failedTests = ref.watch($allFailedTests);

          return failedTests.map((test) {
            final suite = unwrap(
              ref.watch($suite(test.suiteKey)),
            );

            return FailedTestLocation(
              packagePath: package.path,
              testPath: suite.path!,
              name: test.value.name,
            );
          });
        })
        // TODO remove once https://github.com/dart-lang/test/issues/1663 is fixed
        // Due to some issue with `dart test`, it's possible that `dart test` will
        // execute twice the same file. So we're removing the duplicate ourselves.
        .toSet()
        .toList();
  });
}, dependencies: [$allFailedTests, $suite, $packages]);
