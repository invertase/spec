import 'dart:async';

import 'package:dart_test_adapter/dart_test_adapter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:path/path.dart';
import 'package:pubspec/pubspec.dart';
import 'package:riverpod/riverpod.dart';

import 'dart_test_utils.dart';
import 'io.dart';

part 'dart_test.freezed.dart';

final $failedTestLocationToExecute =
    StateProvider<List<FailedTestLocation>?>((ref) => null);

final $testNameFilters = StateProvider<RegExp?>((ref) => null);
final $filePathFilters = StateProvider<List<String>>((ref) => []);
final $isWatchMode = StateProvider<bool>((ref) => false);
final $isRunningOnlyFailingTests = StateProvider<bool>((ref) => false);

final $events =
    StateNotifierProvider.autoDispose<TestEventsNotifier, TestEventsState>(
  (ref) => TestEventsNotifier(ref),
  dependencies: [
    $packages,
    $testNameFilters,
    $filePathFilters,
    $failedTestLocationToExecute,
    $isRunningOnlyFailingTests,
  ],
);

@freezed
class TestEventsState with _$TestEventsState {
  const factory TestEventsState({
    required bool isInterrupted,
    required List<Packaged<TestEvent>> events,
  }) = _TestEventsState;
}

class TestEventsNotifier extends StateNotifier<TestEventsState> {
  TestEventsNotifier(AutoDisposeRef ref)
      : super(const TestEventsState(isInterrupted: false, events: [])) {
    final failedTestsLocation = ref.watch($isRunningOnlyFailingTests)
        ? (ref.watch($failedTestLocationToExecute) ?? [])
        : <FailedTestLocation>[];

    final tests = failedTestsLocation.isNotEmpty
        ? failedTestsLocation
            .map(
              (location) =>
                  '${location.testPath}?full-name=${Uri.encodeQueryComponent(location.name)}',
            )
            .toList()
        : ref.watch($filePathFilters);

    final arguments = [
      if (ref.watch($testNameFilters) != null)
        '--name=${ref.watch($testNameFilters)!.pattern}',
    ];

    final controller = StreamController<List<Packaged<TestEvent>>>();
    ref.onDispose(controller.close);
    final packagesSubscriptions = <StreamSubscription>[];

    controller.onCancel = () {
      for (final sub in packagesSubscriptions) {
        sub.cancel();
      }
    };

    Future(() async {
      final packages = await ref.watch($packages.future);

      for (final package in packages) {
        final packageStream = package.isFlutter
            ? flutterTest(
                tests: tests,
                arguments: arguments,
                workdingDirectory: package.path,
              )
            : dartTest(
                tests: tests,
                arguments: arguments,
                workdingDirectory: package.path,
              );

        packagesSubscriptions.add(
          packageStream.listen((event) {
            state = TestEventsState(
              isInterrupted: false,
              events: [
                ...state.events,
                Packaged(package.path, event),
              ],
            );
          }),
        );
      }
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

final $packages = FutureProvider<List<_Package>>((ref) async {
  final workingDir = ref.watch($workingDirectory);
  final pubspec = await PubSpec.load(workingDir);
  return [
    _Package(
      isFlutter: pubspec.allDependencies.containsKey('flutter'),
      path: normalize(workingDir.absolute.path),
    ),
  ];
}, dependencies: [$workingDirectory]);

final $package =
    FutureProvider.family.autoDispose<_Package, String>((ref, path) async {
  final packages = await ref.watch($packages.future);
  return packages.firstWhere((element) => element.path == path);
}, dependencies: [$workingDirectory, $packages]);

class _Package {
  _Package({required this.isFlutter, required this.path});
  final bool isFlutter;
  final String path;
}

@immutable
class FailedTestLocation {
  const FailedTestLocation({
    required this.testPath,
    required this.name,
    required this.packagePath,
  });

  final String testPath;
  final String name;
  final String packagePath;

  @override
  bool operator ==(Object other) =>
      other is FailedTestLocation &&
      other.runtimeType == runtimeType &&
      other.packagePath == packagePath &&
      other.testPath == testPath &&
      other.name == name;

  @override
  int get hashCode => Object.hash(runtimeType, testPath, name, packagePath);
}
