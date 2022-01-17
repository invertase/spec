import 'package:collection/collection.dart';
import 'package:dart_test_adapter/dart_test_adapter.dart';
import 'package:riverpod/riverpod.dart';

import 'collection.dart';
import 'dart_test.dart';
import 'dart_test_utils.dart';
import 'groups.dart';
import 'io.dart';
import 'tests.dart';

final $suiteCount =
    Provider.autoDispose.family<AsyncValue<int>, String>((ref, packagePath) {
  return ref
      .watch($events(packagePath))
      .events
      .whereType<TestEventAllSuites>()
      .map((e) => e.count)
      .firstDataOrLoading;
}, dependencies: [$events]);

final $suites =
    Provider.family.autoDispose<List<Suite>, String>((ref, packagePath) {
  final events = ref.watch($events(packagePath)).events;

  return events
      .whereType<TestEventSuite>()
      .map((event) => event.suite)
      .toList();
}, dependencies: [$events]);

final $hasAllSuites =
    Provider.family.autoDispose<bool, String>((ref, packagePath) {
  return ref.watch($suiteCount(packagePath)).when(
        error: (err, stack) => false,
        loading: () => false,
        data: (suiteCount) {
          final suites = ref.watch($suites(packagePath));
          return suites.length == suiteCount;
        },
      );
}, dependencies: [$suites, $suiteCount]);

final $suite = Provider.autoDispose
    .family<AsyncValue<Suite>, Packaged<SuiteKey>>((ref, suiteKey) {
  return ref
      .watch($events(suiteKey.packagePath))
      .events
      .whereType<TestEventSuite>()
      .where((e) => e.suite.key == suiteKey.value)
      .map((event) => event.suite)
      .firstDataOrLoading;
}, dependencies: [$events]);

enum SuiteStatus {
  pass,
  fail,
  pending,
}

final $suiteStatus = Provider.family
    .autoDispose<SuiteStatus, Packaged<SuiteKey>>((ref, suiteKey) {
  final tests = ref.watch($testsForSuite(suiteKey));
  final visibleTests = tests.values.where((test) => !test.isHidden).toList();

  /// We verify that "testIds" contains all ids that this suite is supposed
  /// to have. In case we have yet to receive some test events.
  final hasAllVisibleIds = ref.watch(
    $scaffoldGroup(suiteKey).select(
      (rootGroup) =>
          rootGroup.asData != null &&
          visibleTests.length == rootGroup.asData!.value.testCount,
    ),
  );
  if (!hasAllVisibleIds) {
    // TODO update after https://github.com/dart-lang/test/issues/1652 is resolved
    return SuiteStatus.pending;
  }

  // any loading leads to RUNNING, even if there's an error/success
  final hasLoading =
      tests.keys.any((testKey) => ref.watch($testStatus(testKey)).pending);
  if (hasLoading) return SuiteStatus.pending;

  final hasErroredTest = tests.keys
      .map((id) => ref.watch($testStatus(id)))
      .any((status) => status.failing);

  if (hasErroredTest) {
    return SuiteStatus.fail;
  }

  return SuiteStatus.pass;
}, dependencies: [
  $testsForSuite,
  $scaffoldGroup,
  $testStatus,
]);

final $exitCode = Provider.autoDispose<AsyncValue<int>>(
  (ref) {
    // The exit code will be preemptively obtained when a signal is sent.
    // No matter whether all tests executed are passing or not, since the command
    // didn't have the time to complete, we consider the command as failing
    if (ref.watch($isEarlyAbort)) return const AsyncData(-1);

    final packages = ref.watch($packages);

    return packages.when(
      loading: () => const AsyncLoading(),
      error: (err, stack) => AsyncError(err, stackTrace: stack),
      data: (packages) {
        final packageCode = packages.map<AsyncValue<int>>((package) {
          final doneEvent = ref
                  .watch($events(package.path))
                  .events
                  .firstWhereOrNull((event) => event is TestEventDone)
              as TestEventDone?;
          if (doneEvent != null) {
            // Something probably went wrong as we likely should've been able to quit
            // before obtaining the true "done" event, so we'll safely quit.
            return doneEvent.success ?? true
                ? const AsyncData(0)
                : const AsyncData(-1);
          }

          if (!ref.watch($hasAllSuites(package.path))) {
            return const AsyncLoading();
          }

          final suites = ref.watch($suites(package.path));

          final hasPendingSuite = suites.any(
            (suite) =>
                ref.watch($suiteStatus(Packaged(package.path, suite.key))) ==
                SuiteStatus.pending,
          );
          if (hasPendingSuite) return const AsyncLoading();

          final hasErroredSuite = suites.any(
            (suite) =>
                ref.watch($suiteStatus(Packaged(package.path, suite.key))) ==
                SuiteStatus.fail,
          );
          if (hasErroredSuite) return const AsyncData(-1);

          // All suites are completed and passing
          return const AsyncData(0);
        }).toList();

        if (packageCode.any((code) => code.isLoading)) {
          return const AsyncLoading();
        }
        final error =
            packageCode.firstWhereOrNull((element) => element.isError);
        if (error != null) return error;

        final firstFailing =
            packageCode.firstWhereOrNull((element) => element.value != 0);
        return AsyncData(firstFailing?.value ?? 0);
      },
    );
  },
  dependencies: [
    $suites,
    $suiteStatus,
    $isEarlyAbort,
    $hasAllSuites,
    $events,
  ],
);

final $isDone = Provider.autoDispose<bool>(
  (ref) {
    final packages = ref.watch($packages);
    if (packages.isLoading) return false;

    return ref.watch($exitCode).map(
              data: (d) => d.isRefreshing == false,
              error: (_) => false,
              loading: (_) => false,
            ) ||
        packages.value!.any((p) => ref.watch($events(p.path)).isInterrupted);
  },
  dependencies: [$exitCode, $events, $packages],
  name: 'isDone',
);
