import 'package:dart_test_adapter/dart_test_adapter.dart';
import 'package:riverpod/riverpod.dart';
import 'package:collection/collection.dart';

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
        data: (_) => ' PASS '.black.bgGreen,
        error: (_) => ' FAIL '.white.bgRed,
        loading: (_) => ' RUNS '.black.bgYellow,
      ),
      if (suite.path != null) suite.path!,
    ].join(' ');
  });
}, dependencies: [$suite, $scaffoldGroup, $suiteStatus]);

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
        pending: () => '${ref.watch($spinner)} $name',
        // TODO show skipReason
        skip: (skipReason) => '○ $name',
      );
    }

    return null;
  }).whenOrNull<String?>(data: (data) => data);
}, dependencies: [$test, $testStatus, $spinner, $testName]);

final $testError =
    Provider.autoDispose.family<String?, TestKey>((ref, testKey) {
  final status = ref.watch($testStatus(testKey));

  return status.whenOrNull<String?>(
    fail: (err, stack) {
      return '''
$err
${stack.trim()}''';
    },
  );
}, dependencies: [$test, $testStatus, $spinner, $testName]);

final AutoDisposeProviderFamily<AsyncValue<String>, GroupKey> $groupOutput =
    Provider.autoDispose.family<AsyncValue<String>, GroupKey>((ref, groupKey) {
  return merge((unwrap) {
    final groupDepth = unwrap(ref.watch($groupDepth(groupKey)));
    final label = unwrap(ref.watch($groupName(groupKey)));
    final tests = unwrap(ref.watch($testsForGroup(groupKey)));
    final childrenGroups = ref.watch($childrenGroupsForGroup(groupKey));

    final testContent = tests
        .sortedByStatus(ref)
        .map((test) {
          return _renderTest(
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
  $testLabel,
  $testMessages,
  $childrenGroupsForGroup,
]);

String? _renderTest({
  required List<String> messages,
  required String? error,
  required String? label,
  required int depth,
}) {
  if (messages.isEmpty && error == null && label == null) return null;

  error = error?.multilinePadLeft(depth * 2 + 4);

  return [
    if (label != null) label.multilinePadLeft(depth * 2 + 2),
    ...messages, // messages are voluntarily not indented
    if (error != null)
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
  $suiteOutputLabel,
  $rootTestsForSuite,
]);

final $output = Provider.autoDispose<AsyncValue<String>>((ref) {
  return merge((unwrap) {
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

    return [
      if (passingSuites.isNotEmpty) passingSuites,
      if (loadingSuites.isNotEmpty) loadingSuites,
      if (failingSuites.isNotEmpty) failingSuites,
    ].join('\n\n');
  });
}, dependencies: [
  $suites,
  $suiteOutput,
  $suiteStatus,
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
