import 'dart:async';
import 'dart:io';

import 'package:cli_util/cli_logging.dart';
import 'package:dart_test_adapter/dart_test_adapter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:melos/melos.dart';
import 'package:path/path.dart';
import 'package:pubspec/pubspec.dart';
import 'package:riverpod/riverpod.dart';

import 'dart_test_utils.dart';
import 'io.dart';
import 'third-party/format_coverage.dart';

part 'dart_test.freezed.dart';

final $failedTestLocationToExecute =
    StateProvider<List<FailedTestLocation>?>((ref) => null);

final $testNameFilters = StateProvider<RegExp?>((ref) => null);
final $filePathFilters = StateProvider<List<String>>((ref) => []);
final $isWatchMode = StateProvider<bool>((ref) => false);
final $isRunningOnlyFailingTests = StateProvider<bool>((ref) => false);
final $isCIMode = Provider((ref) => !stdin.supportsAnsiEscapes);
final $isMelosMode = StateProvider<bool>((ref) => true);
final $isCoverageMode = Provider<bool>((ref) => throw UnimplementedError());
final $isUpdateGoldensMode = StateProvider<bool>((ref) => false);

final $events = StateNotifierProvider<TestEventsNotifier, TestEventsState>(
  TestEventsNotifier.new,
  dependencies: [
    $filteredPackages,
    $filteredPackages,
    $testNameFilters,
    $filePathFilters,
    $failedTestLocationToExecute,
    $isRunningOnlyFailingTests,
    $isCoverageMode,
    $isUpdateGoldensMode,
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
  TestEventsNotifier(Ref ref)
      : super(const TestEventsState(isInterrupted: false, events: [])) {
    Future(() async {
      final packages = await ref.watch($filteredPackages.future);

      final packagesSubscriptions = <StreamSubscription>[];
      ref.onDispose(
        _closeSubs = () {
          for (final sub in packagesSubscriptions) {
            sub.cancel();
          }
          packagesSubscriptions.clear();
        },
      );

      for (final package in packages) {
        final packageStream = _runPackage(package, ref);

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

  void Function()? _closeSubs;

  Stream<TestEvent> _runPackage(_Package package, Ref ref) {
    final arguments = [
      if (ref.watch($testNameFilters) != null)
        '--name=${ref.watch($testNameFilters)!.pattern}',
    ];

    final failedTestsLocation = ref.watch($isRunningOnlyFailingTests)
        ? (ref.watch($failedTestLocationToExecute) ?? [])
        : const <FailedTestLocation>[];

    List<String> tests;

    if (failedTestsLocation.isNotEmpty) {
      tests = failedTestsLocation
          .where((location) => isWithin(package.path, location.testPath))
          .map(
        (location) {
          // workaround to https://github.com/dart-lang/test/issues/1667
          final relativeTestPath = relative(
            location.testPath,
            from: package.path,
          );

          return '$relativeTestPath?full-name=${Uri.encodeQueryComponent(location.name)}';
        },
      ).toList();
    } else {
      tests = ref
          .watch($filePathFilters)
          .where((path) => package.path == path || isWithin(package.path, path))
          // workaround to https://github.com/dart-lang/test/issues/1667
          .map((path) => relative(path, from: package.path))
          .toList();
    }

    final coverage = ref.watch($isCoverageMode);
    final updateGoldens = ref.watch($isUpdateGoldensMode);

    return package.isFlutter
        ? flutterTest(
            tests: tests,
            arguments: [
              ...arguments,
              if (coverage) '--coverage',
              if (updateGoldens) '--update-goldens',
            ],
            workdingDirectory: package.path,
          )
        : dartTest(
            tests: tests,
            arguments: [
              ...arguments,
              if (coverage) '--coverage=.dart_tool/spec_coverage/',
            ],
            workdingDirectory: package.path,
          );
  }

  /// Stops the test process
  void stop() {
    // Cancelling the stream subscription will ultimately kill the process
    _closeSubs?.call();
    state = state.copyWith(isInterrupted: true);
  }
}

final $coverageForPackage =
    FutureProvider.autoDispose.family<void, String>((ref, packagePath) async {
  if (!ref.watch($isCoverageMode)) return;

  final package = await ref.watch($package(packagePath).future);

  if (package.isFlutter) {
    return;
  }

  final completer = Completer<void>();
  // TODO onDispose completerError the completer

  late ProviderSubscription<TestEventsState> sub;
  sub = ref.listen($events, (previous, next) {
    if (next.events.any((event) => event.value is TestEventDone)) {
      completer.complete();
      sub.close();
    }
  });

  await completer.future;

  await formatCoverage(
    input: '$packagePath/.dart_tool/spec_coverage/',
    packagePath: '$packagePath/.packages',
    reportOn: ['$packagePath/lib'],
    output: '$packagePath/coverage/lcov.info',
  );
}, dependencies: [$package, $isCoverageMode, $events]);

final $allPackages = FutureProvider<List<_Package>>((ref) async {
  final workingDir = ref.watch($workingDirectory);
  Future<List<_Package>> singlePackage() async {
    late final hasPubspec =
        File(join(workingDir.path, 'pubspec.yaml')).existsSync();
    late final hasTestFolder =
        Directory(join(workingDir.path, 'test')).existsSync();

    return [
      if (hasPubspec && hasTestFolder)
        _Package(
          isFlutter: await PubSpec.load(workingDir).then(
            (pubspec) => pubspec.allDependencies.containsKey('flutter'),
          ),
          path: normalize(workingDir.absolute.path),
        ),
    ];
  }

  final isMelosMode = ref.watch($isMelosMode);
  if (!isMelosMode) {
    return singlePackage();
  }

  try {
    final melosWorkspace = await MelosWorkspace.fromConfig(
      await MelosWorkspaceConfig.fromDirectory(workingDir),
      filter: PackageFilter(dirExists: const ['test']),
      logger: MelosLogger(Logger.standard()),
    );

    return melosWorkspace.filteredPackages.values
        .map((e) => _Package(isFlutter: e.isFlutterPackage, path: e.path))
        .toList();
  } on MelosException {
    return singlePackage();
  }
}, dependencies: [$workingDirectory]);

final $filteredPackages = FutureProvider<List<_Package>>(
  (ref) async {
    final all = await ref.watch($allPackages.future);
    final filters = ref.watch($filePathFilters);

    final result = all.where((package) {
      return filters.isEmpty ||
          filters.any((element) {
            return package.path == element || isWithin(package.path, element);
          });
    }).toList();

    return result;
  },
  dependencies: [$allPackages, $filePathFilters],
);

final $package =
    FutureProvider.family.autoDispose<_Package, String>((ref, path) async {
  final packages = await ref.watch($allPackages.future);
  return packages.firstWhere((element) => element.path == path);
}, dependencies: [$workingDirectory, $allPackages]);

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
