import 'package:dart_test_adapter/dart_test_adapter.dart';
import 'package:riverpod/riverpod.dart';
import 'package:spec_cli/src/collection.dart';

import 'dart_test.dart';
import 'dart_test_utils.dart';
import 'groups.dart';
import 'provider_utils.dart';
import 'suites.dart';

final $rootTestsForSuite =
    Provider.autoDispose.family<List<Test>, SuiteKey>((ref, suiteKey) {
  final testsForSuite = ref.watch($testsForSuite(suiteKey));

  return testsForSuite.values
      // Tests with no groups are errored tests such as when there is a compilation error.
      // Tests with a single group are user-defined tests, since that group is added implicitly
      .where((test) => test.groupIDs.length < 2)
      .toList();
}, dependencies: [$testsForSuite]);

final $testName =
    Provider.autoDispose.family<AsyncValue<String>, TestKey>((ref, testKey) {
  return merge((unwrap) {
    final test = unwrap(ref.watch($test(testKey)));
    final parentGroup = test.groupKey != null
        ? unwrap(ref.watch($group(test.groupKey!)))
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
    .family<AsyncValue<List<Test>>, GroupKey>((ref, groupKey) {
  return merge((unwrap) {
    final group = unwrap(ref.watch($group(groupKey)));
    final testsForSuite = ref.watch($testsForSuite(group.suiteKey));

    return testsForSuite.values
        .where((test) => test.groupKey == groupKey)
        .toList();
  });
}, dependencies: [$testsForSuite]);

final $testsForSuite =
    Provider.family<Map<TestKey, Test>, SuiteKey>((ref, suiteKey) {
  return Map.fromEntries(
    ref
        .watch($events)
        .whereType<TestEventTestStart>()
        .where((event) => event.test.suiteKey == suiteKey)
        .where((event) => !event.test.isHidden)
        .map((e) => MapEntry(e.test.key, e.test)),
  );
}, dependencies: [$events]);

final $test = Provider.family<AsyncValue<Test>, TestKey>((ref, testKey) {
  return ref
      .watch($events)
      .whereType<TestEventTestStart>()
      .where((event) => event.test.key == testKey)
      .map((e) => e.test)
      .firstDataOrLoading;
}, dependencies: [$events]);

final $allTests = Provider<List<Test>>((ref) {
  return ref
      .watch($events)
      .whereType<TestEventTestStart>()
      .map((e) => e.test)
      .toList();
}, dependencies: [$events]);

final $allFailedTests = Provider<List<Test>>((ref) {
  return ref
      .watch($allTests)
      .where((test) => ref.watch($testStatus(test.key)) is AsyncError)
      .toList();
}, dependencies: [$allTests, $testStatus]);

final $testStatus = Provider.family<AsyncValue<void>, TestKey>((ref, testKey) {
  final events = ref.watch($events);

  final error = events
      .whereType<TestEventTestError>()
      // TODO can we have the groupID/suiteID too?
      .where((e) => e.testID == testKey.testID)
      .firstOrNull;
  if (error != null) {
    return AsyncError(
      error.error,
      stackTrace: StackTrace.fromString(error.stackTrace),
    );
  }

  final done = events
      .whereType<TestEventTestDone>()
      // TODO can we have the groupID/suiteID too?
      .where((e) => e.testID == testKey.testID)
      .firstOrNull;
  if (done != null) return const AsyncData(null);

  return const AsyncLoading();
}, dependencies: [$events]);

final $currentlyFailedTestsLocation =
    Provider<AsyncValue<List<FailedTestLocation>>>((ref) {
  return merge((unwrap) {
    final failedTests = ref.watch($allFailedTests);

    return failedTests.map((test) {
      final suite = unwrap(
        ref.watch($suite(test.suiteKey)),
      );

      return FailedTestLocation(
        path: suite.path!,
        name: test.name,
      );
    }).toList();
  });
}, dependencies: [$allFailedTests, $suite]);
