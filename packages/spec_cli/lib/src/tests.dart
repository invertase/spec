import 'dart:async';

import 'package:dart_test_adapter/dart_test_adapter.dart';
import 'package:riverpod/riverpod.dart';

import 'dart_test.dart';
import 'dart_test_utils.dart';
import 'groups.dart';
import 'provider_utils.dart';
import 'rendering.dart';
import 'suites.dart';

final $rootTestsForSuite =
    Provider.autoDispose.family<List<Test>, SuiteKey>((ref, suiteKey) {
  final testsForSuite =
      ref.watch($testsForSuite(suiteKey)).when<Map<TestKey, Test>>(
            data: (res) => res,
            error: (err, stack) => {},
            loading: () => {},
          );

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
    final testsForSuite = unwrap(ref.watch($testsForSuite(group.suiteKey)));

    return testsForSuite.values
        .where((test) => test.groupKey == groupKey)
        .toList();
  });
}, dependencies: [$testsForSuite]);

final $testsForSuite =
    StreamProvider.family<Map<TestKey, Test>, SuiteKey>((ref, suiteKey) {
  final controller = StreamController<Map<TestKey, Test>>();
  controller.onListen = () => controller.add({});
  ref.onDispose(controller.close);

  final tests = <TestKey, Test>{};

  ref
      .watch($result)
      .testStart()
      .where((event) => event.test.suiteKey == suiteKey)
      .where((event) => !event.test.isHidden)
      .listen((event) {
    if (!tests.containsKey(event.test.key)) {
      tests[event.test.key] = event.test;
      controller.add({...tests});
    }
  });

  return controller.stream;
}, dependencies: [$result]);

final $test = StreamProvider.family<Test, TestKey>((ref, testKey) async* {
  await for (final testStart in ref.watch($result).testStart()) {
    if (testStart.test.key == testKey) {
      yield testStart.test;
    }
  }
}, dependencies: [$result]);

final $allTests = StreamProvider<List<Test>>((ref) {
  return ref.watch($result).testStart().map((event) => event.test).combined();
}, dependencies: [$result]);

final $allFailedTests = Provider<AsyncValue<List<Test>>>((ref) {
  return merge((unwrap) {
    return unwrap(ref.watch($allTests))
        .where((test) => ref.watch($testStatus(test.key)) is AsyncError)
        .toList();
  });
}, dependencies: [$allTests, $testStatus]);

final $testStatus = FutureProvider.family<void, TestKey>((ref, testKey) async {
  // No need to wait for test start event

  // will either throw or complete, allowing test status handling through "when(loading, error, data)   "

  await Future.any([
    ref //
        .watch($result)
        .testDone()
        .firstWhere(
          // TODO can we have the groupID/suiteID too?
          (e) =>
              e.testID == testKey.testID && e.result == TestDoneStatus.success,
        ),
    ref
        .watch($result)
        .testError()
        // TODO can we have the groupID/suiteID too?
        .firstWhere((e) => e.testID == testKey.testID)
        .then((e) => throw FailedTestException(e)),
  ]);
}, dependencies: [$result]);

final $currentlyFailedTestsLocation =
    Provider<AsyncValue<List<FailedTestLocation>>>((ref) {
  return merge((unwrap) {
    final failedTests = unwrap(ref.watch($allFailedTests));

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
