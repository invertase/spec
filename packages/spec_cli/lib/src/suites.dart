import 'package:dart_test_adapter/dart_test_adapter.dart';
import 'package:riverpod/riverpod.dart';
import 'package:collection/collection.dart';
import 'package:spec_cli/src/rendering.dart';

import 'dart_test.dart';
import 'dart_test_utils.dart';
import 'groups.dart';
import 'provider_utils.dart';
import 'tests.dart';

final $suiteCount = FutureProvider<int>((ref) async {
  final allSuites = await ref.watch($result).allSuites();
  return allSuites.count;
}, dependencies: [$result]);

final $suites = StreamProvider<List<Suite>>((ref) {
  final result = ref.watch($result);

  return result
      .suites()
      .combined()
      .map((event) => event.map((e) => e.suite).toList());
}, dependencies: [$result]);

final $suite = FutureProvider.family<Suite, SuiteKey>((ref, suiteKey) async {
  final suiteEvent = await ref
      .watch($result)
      .suites()
      .firstWhere((e) => e.suite.key == suiteKey);

  return suiteEvent.suite;
}, dependencies: [$result]);

final $suiteStatus =
    Provider.family<AsyncValue<void>, SuiteKey>((ref, suiteKey) {
  return merge((unwrap) {
    final tests = unwrap(ref.watch($testsForSuite(suiteKey)));
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
      unwrap(const AsyncLoading());
    }

    // any loading leads to RUNNING, even if there's an error/success
    final hasLoading = tests.keys
        .any((testKey) => ref.watch($testStatus(testKey)) is AsyncLoading);
    if (hasLoading) unwrap(const AsyncLoading());

    final error = tests.keys
        .map((id) => ref.watch($testStatus(id)))
        .firstWhereOrNull((status) => status is AsyncError) as AsyncError?;

    if (error != null) {
      unwrap(
        AsyncError(
          error.error,
          stackTrace: error.stackTrace,
        ),
      );
    }

    return;
  });
}, dependencies: [
  $testsForSuite,
  $scaffoldGroup,
  $testStatus,
]);
