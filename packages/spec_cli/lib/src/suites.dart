import 'package:dart_test_adapter/dart_test_adapter.dart';
import 'package:riverpod/riverpod.dart';

import 'collection.dart';
import 'dart_test.dart';
import 'dart_test_utils.dart';
import 'groups.dart';
import 'io.dart';
import 'provider_utils.dart';
import 'tests.dart';

/// The number of suites, all packages included
final $suiteCount = Provider.autoDispose<AsyncValue<int>>(
  (ref) {
    return merge((unwrap) {
      final packages = unwrap(ref.watch($packages));
      final events = ref.watch($events).events;

      return packages.fold(0, (acc, package) {
        final allSuite = unwrap(
          events
              .where((e) => e.packagePath == package.path)
              .map((e) => e.value)
              .whereType<TestEventAllSuites>()
              .firstDataOrLoading,
        );

        return acc + allSuite.count;
      });
    });
  },
  dependencies: [$events, $packages],
  name: 'suiteCount',
);

final $suites = Provider.autoDispose<List<Packaged<Suite>>>((ref) {
  final events = ref.watch($events).events;

  return events
      .where((e) => e.value is TestEventSuite)
      .map((e) => e.next((value) => value.cast<TestEventSuite>()!.suite))
      .toList();
}, dependencies: [$events]);

final $hasAllSuites = Provider.autoDispose<bool>(
  (ref) {
    return ref.watch($suiteCount).when(
          error: (err, stack) => false,
          loading: () => false,
          data: (suiteCount) {
            final suites = ref.watch($suites);
            return suites.length == suiteCount;
          },
        );
  },
  dependencies: [$suites, $suiteCount, $packages],
);

final $suite = Provider.autoDispose
    .family<AsyncValue<Suite>, Packaged<SuiteKey>>((ref, suiteKey) {
  return ref
      .watch($events)
      .events
      .where((e) => e.packagePath == suiteKey.packagePath)
      .map((e) => e.value)
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

    if (!ref.watch($hasAllSuites)) {
      return const AsyncLoading();
    }

    final packages = ref.watch($packages);
    if (packages.isLoading) return const AsyncLoading();

    /// Whether the done event was emitted for all packages
    final allPackagesDone = packages.value!.every(
      (package) => ref
          .watch($events)
          .events
          .where((event) => event.packagePath == package.path)
          .any((event) => event.value is TestEventDone),
    );

    if (allPackagesDone) {
      // Something probably went wrong as we likely should've been able to quit
      // before obtaining the true "done" event, so we'll safely quit.

      final hasFailingDoneEvent = ref
          .watch($events)
          .events
          .map((e) => e.value)
          .whereType<TestEventDone>()
          .any((done) => done.success == false);

      return hasFailingDoneEvent ? const AsyncData(-1) : const AsyncData(0);
    }

    final suites = ref.watch($suites);
    final hasPendingSuite = suites.any(
      (suite) => ref.watch($suiteStatus(suite.key)) == SuiteStatus.pending,
    );
    if (hasPendingSuite) return const AsyncLoading();

    final hasErroredSuite = suites.any(
      (suite) => ref.watch($suiteStatus(suite.key)) == SuiteStatus.fail,
    );
    if (hasErroredSuite) return const AsyncData(-1);

    // All suites are completed and passing
    return const AsyncData(0);
  },
  dependencies: [
    $suites,
    $packages,
    $suiteStatus,
    $isEarlyAbort,
    $hasAllSuites,
    $events,
  ],
  name: 'exitCode',
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
        packages.value!.any((p) => ref.watch($events).isInterrupted);
  },
  dependencies: [$exitCode, $events, $packages],
  name: 'isDone',
);
