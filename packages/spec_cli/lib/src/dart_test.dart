import 'dart:async';
import 'dart:io';

import 'package:dart_test_adapter/dart_test_adapter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:path/path.dart';
import 'package:pubspec/pubspec.dart';
import 'package:riverpod/riverpod.dart';

import 'io.dart';

part 'dart_test.freezed.dart';

final $failedTestsLocationFromPreviousRun =
    StateProvider<List<FailedTestLocation>?>((ref) => null);

final $testNameFilters = StateProvider<RegExp?>((ref) => null);
final $filePathFilters = StateProvider<List<String>>((ref) => []);
final $isWatchMode = StateProvider<bool>((ref) => false);

final $events = StateNotifierProvider<TestEventsNotifier, TestEventsState>(
  (ref) => TestEventsNotifier(ref),
  dependencies: [
    $testNameFilters,
    $filePathFilters,
    $workingDirectory,
    $failedTestsLocationFromPreviousRun,
  ],
);

@freezed
class TestEventsState with _$TestEventsState {
  const factory TestEventsState({
    required bool isInterrupted,
    required List<TestEvent> events,
  }) = _TestEventsState;
}

class TestEventsNotifier extends StateNotifier<TestEventsState> {
  TestEventsNotifier(Ref ref)
      : super(
          const TestEventsState(
            isInterrupted: false,
            events: [],
          ),
        ) {
    final locations = ref.watch($failedTestsLocationFromPreviousRun) ?? [];

    final tests = locations.isNotEmpty
        ? locations
            .map(
              (location) =>
                  '${location.path}?full-name=${Uri.encodeQueryComponent(location.name)}',
            )
            .toList()
        : ref.watch($filePathFilters);

    final arguments = [
      if (ref.watch($testNameFilters) != null)
        '--name=${ref.watch($testNameFilters)!.pattern}',
    ];

    print('arguments $arguments');

    final workingDir = ref.watch($workingDirectory);

    Future(() async {
      final packages = await _getPackageList(workingDir);

      final package = packages.first;

      final eventsStream = package.isFlutter
          ? flutterTest(
              tests: tests,
              arguments: arguments,
              workdingDirectory: ref.watch($workingDirectory).path,
            )
          : dartTest(
              tests: tests,
              arguments: arguments,
              workdingDirectory: ref.watch($workingDirectory).path,
            );

      _eventsSub = eventsStream.listen((events) {
        state = TestEventsState(isInterrupted: false, events: events);
      });
    });
  }

  StreamSubscription<List<TestEvent>>? _eventsSub;

  /// Stops the test process
  void stop() {
    // Cancelling the stream subscription will ultimately kill the process
    _eventsSub!.cancel();
    state = state.copyWith(isInterrupted: true);
  }

  @override
  void dispose() {
    _eventsSub?.cancel();
    super.dispose();
  }
}

Future<List<_Package>> _getPackageList(Directory workingDir) async {
  final pubspec = await PubSpec.load(workingDir);
  return [
    _Package(
      isFlutter: pubspec.allDependencies.containsKey('flutter'),
      path: normalize(workingDir.absolute.path),
    ),
  ];
}

class _Package {
  _Package({required this.isFlutter, required this.path});
  final bool isFlutter;
  final String path;
}

class FailedTestLocation {
  FailedTestLocation({required this.path, required this.name});

  final String path;
  final String name;
}
