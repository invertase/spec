import 'package:dart_test_adapter/dart_test_adapter.dart';
import 'package:riverpod/riverpod.dart';

import 'io.dart';

final $failedTestsLocationFromPreviousRun =
    StateProvider<List<FailedTestLocation>?>((ref) => null);

final $events = Provider<List<TestEvent>>(
  (ref) {
    final locations =
        ref.watch($failedTestsLocationFromPreviousRun.notifier).state;

    final tests = locations
        ?.map(
          (location) =>
              '${location.path}?full-name=${Uri.encodeQueryComponent(location.name)}',
        )
        .toList();

    final eventsStream = dartTest(
      tests: tests,
      workdingDirectory: ref.watch($workingDirectory).path,
    );

    final sub = eventsStream.listen((events) {
      ref.state = events;
    });
    ref.onDispose(sub.cancel);

    return [];
  },
  dependencies: [
    $workingDirectory,
    $failedTestsLocationFromPreviousRun.notifier
  ],
);

class FailedTestLocation {
  FailedTestLocation({required this.path, required this.name});

  final String path;
  final String name;
}
