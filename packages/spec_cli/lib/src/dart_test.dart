import 'dart:io';

import 'package:dart_test_adapter/dart_test_adapter.dart';
import 'package:path/path.dart';
import 'package:pubspec/pubspec.dart';
import 'package:pubspec_parse/pubspec_parse.dart';
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

    final workingDir = ref.watch($workingDirectory);

    Future(() async {
      final packages = await _getPackageList(workingDir);

      final package = packages.first;

      final eventsStream = package.isFlutter
          ? flutterTest(
              tests: tests,
              workdingDirectory: ref.watch($workingDirectory).path,
            )
          : dartTest(
              tests: tests,
              workdingDirectory: ref.watch($workingDirectory).path,
            );

      final sub = eventsStream.listen((events) {
        ref.state = events;
      });
      ref.onDispose(sub.cancel);
    });

    return [];
  },
  dependencies: [
    $workingDirectory,
    $failedTestsLocationFromPreviousRun.notifier
  ],
);

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
