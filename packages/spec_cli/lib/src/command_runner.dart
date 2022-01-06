import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:riverpod/riverpod.dart';
import 'package:spec_cli/src/container.dart';
import 'package:spec_cli/src/renderer.dart';
import 'package:spec_cli/src/suites.dart';

import 'dart_test.dart';
import 'io.dart';
import 'rendering.dart';
import 'tests.dart';
import 'vt100.dart';

Future<int> festCommandRunner(List<String> args) async {
  final parser = ArgParser();
  parser.addFlag(
    'watch',
    abbr: 'w',
    defaultsTo: false,
    negatable: false,
    help: 'Listens to changes in the project and '
        'run tests whenever something changed',
  );

  final result = parser.parse(args);

  return fest(
    watch: result['watch'] as bool,
  );
}

Future<int> fest({
  bool watch = false,
  String? workingDirectory,
}) {
  return runScoped((ref) async {
    if (watch) {
      stdout.write('${VT100.clearScreen}${VT100.moveCursorToTopLeft}');

      ref.listen(
        $fileChange,
        (prev, value) {
          ref.refresh($events);
        },
      );

      List<FailedTestLocation> _lastFailedTests = [];

      ref.listen<AsyncValue<List<FailedTestLocation>>>(
          $currentlyFailedTestsLocation, (prev, value) {
        value.when(
          data: (value) => _lastFailedTests = value,
          loading: () => _lastFailedTests = [],
          error: (err, stack) {
            Zone.current.handleUncaughtError(err, stack!);
          },
        );
      });

      ref.listen($fileChange, (prev, value) {
        ref.read($failedTestsLocationFromPreviousRun.notifier).state =
            _lastFailedTests;
      });
      stdin.listen((event) {
        if (event.first == 10) {
          // enter
          ref.read($failedTestsLocationFromPreviousRun.notifier).state =
              _lastFailedTests;
        }
      });
    }

    final renderer = rendererOverride ??
        (watch ? FullScreenRenderer() : BacktrackingRenderer());

    ref.listen<AsyncValue<String>>(
      $output,
      (lastOutput, output) {
        output.when(
          loading: () {}, // nothing to do
          error: (err, stack) {
            Zone.current.handleUncaughtError(err, stack!);
          },
          data: (output) {
            if (output.trim().isNotEmpty) renderer.renderFrame(output);
          },
        );
      },
      fireImmediately: true,
    );

    return ref.read($exitCode.future);
  }, overrides: [
    $startTime.overrideWithValue(DateTime.now()),
    if (workingDirectory != null)
      $workingDirectory.overrideWithValue(Directory(workingDirectory)),
  ]);
}
