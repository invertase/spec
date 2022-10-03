import 'dart:async';

import 'package:collection/collection.dart';
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
      final packages = unwrap(ref.watch($filteredPackages));
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
  dependencies: [$events, $filteredPackages],
  name: 'suiteCount',
);

final $suites = Provider.autoDispose<List<Packaged<Suite>>>((ref) {
  final events = ref.watch($events).events;

  return events
      .where((e) => e.value is TestEventSuite)
      .map((e) => e.next((value) => value.cast<TestEventSuite>()!.suite))
      .toList();
}, dependencies: [$events]);

final $completedSuiteKeysInCompletionOrder =
    Provider.autoDispose<List<Packaged<SuiteKey>>>(
  (ref) {
    final sortedSuiteKeys = <Packaged<SuiteKey>>{};

    for (final event in ref.watch($events).events.reversed) {
      event.value.map(
        testDone: (e) {
          final test = ref
              .watch($allTests)
              // TODO is there a way to filter groupID/suiteID?
              .firstWhereOrNull(
                (test) =>
                    test.packagePath == event.packagePath &&
                    test.value.id == e.testID,
              );

          if (test == null) return;

          sortedSuiteKeys.add(test.next((value) => value.suiteKey));
        },
        processDone: (_) {},
        suite: (e) {},
        start: (_) {},
        done: (_) {},
        allSuites: (_) {},
        group: (_) {},
        testStart: (_) {},
        print: (_) {},
        error: (_) {},
        debug: (_) {},
        unknown: (_) {},
      );
    }

    return sortedSuiteKeys.toList().reversed.toList();
  },
  dependencies: [$events, $allTests],
);

final $hasAllSuites = Provider.autoDispose<bool>(
  (ref) {
    final suiteCount = ref.watch($suiteCount).value;
    if (suiteCount == null) return false;

    final suites = ref.watch($suites);
    return suites.length == suiteCount;
  },
  dependencies: [$suites, $suiteCount, $filteredPackages],
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

final $packageExitCode =
    Provider.family.autoDispose<AsyncValue<int>, String>((ref, packagePath) {
  return ref
      .watch($events)
      .events
      .where((e) => e.packagePath == packagePath)
      .map((e) => e.value)
      .whereType<TestProcessDone>()
      .map((e) => e.exitCode)
      .firstDataOrLoading;
}, dependencies: [$events]);

final $isPackageDone =
    Provider.family.autoDispose<bool, String>((ref, packagePath) {
  return !ref.watch($packageExitCode(packagePath)).isLoading &&
      !ref.watch($coverageForPackage(packagePath)).isLoading;
}, dependencies: [$packageExitCode, $coverageForPackage]);

final $suiteStatus = Provider.family
    .autoDispose<SuiteStatus, Packaged<SuiteKey>>((ref, suiteKey) {
  final tests = ref.watch($testsForSuite(suiteKey));
  final visibleTests = tests.values.where((test) => !test.isHidden).toList();

  // If we received the done event for a package, bypass loading checks.
  // This allows us to handle compilation errors properly as in those cases
  // we'd never be able to load the tests, so the suite would always be considered
  // as loading.
  final isDone = ref.watch($isPackageDone(suiteKey.packagePath));
  if (!isDone) {
    /// We verify that "testIds" contains all ids that this suite is supposed
    /// to have. In case we have yet to receive some test events.
    final hasAllVisibleIds = ref.watch(
      $scaffoldGroup(suiteKey).select(
        (rootGroup) =>
            rootGroup.asData != null &&
            visibleTests.length >= rootGroup.asData!.value.testCount,
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
  }

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
  $isPackageDone,
]);

final $exitCode = AsyncNotifierProvider.autoDispose<ExitCode, int>(
  ExitCode.new,
  dependencies: [
    $suites,
    $filteredPackages,
    $suiteStatus,
    $isEarlyAbort,
    $hasAllSuites,
    $events,
    $isPackageDone,
    $coverageForPackage,
    $packageExitCode,
  ],
  name: 'exitCode',
);

class ExitCode extends AutoDisposeAsyncNotifier<int> {
  @override
  FutureOr<int> build() {
    // The exit code will be preemptively obtained when a signal is sent.
    // No matter whether all tests executed are passing or not, since the command
    // didn't have the time to complete, we consider the command as failing
    if (ref.watch($isEarlyAbort)) return -1;

    if (!ref.watch($hasAllSuites)) {
      return future;
    }

    final packages = ref.watch($filteredPackages);
    if (packages.isLoading) return future;

    final coverageReports = packages.value!
        .map((p) => ref.watch($coverageForPackage(p.path)))
        .toList();
    if (coverageReports.any((element) => element.isLoading)) {
      return future;
    }
    if (coverageReports.any((element) => element.hasError)) {
      // TODO print error
      return -1;
    }

    final hasPendingPackage = packages.value!.any(
      (package) => !ref.watch($isPackageDone(package.path)),
    );
    if (hasPendingPackage) return future;

    final exitCode = packages.value!
        .map((package) => ref.watch($packageExitCode(package.path)).value!)
        .firstWhereOrNull((exitCode) => exitCode != 0);

    return exitCode ?? 0;
  }
}

final $isDone = Provider.autoDispose<bool>(
  (ref) {
    final packages = ref.watch($filteredPackages);
    if (packages.isLoading) return false;

    return ref.watch($exitCode).map(
              data: (d) => d.isRefreshing == false,
              error: (_) => false,
              loading: (_) => false,
            ) ||
        packages.value!.any((p) => ref.watch($events).isInterrupted);
  },
  dependencies: [$exitCode, $events, $filteredPackages],
  name: 'isDone',
);
