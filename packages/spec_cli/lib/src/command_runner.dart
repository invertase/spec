import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:dart_test_adapter/dart_test_adapter.dart';
import 'package:riverpod/riverpod.dart';
import 'package:spec_cli/src/container.dart';
import 'package:spec_cli/src/renderer.dart';

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
          ref.refresh($result);
        },
      );

      List<FailedTestLocation> _lastFailedTests = [];

      ref.listen<AsyncValue<List<FailedTestLocation>>>(
          $currentlyFailedTestsLocation, (prev, value) {
        value.when(
          data: (value) => _lastFailedTests = value,
          loading: () => _lastFailedTests = [],
          error: (err, stack) => print('error'),
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
            print('Error: failed to render\n$err\n$stack');
          },
          data: renderer.renderFrame,
        );
      },
      fireImmediately: true,
    );

    final completer = Completer<int>();

    if (!watch) {
      // if not in watch mode, finish the command when the test proccess completes.

      // use "listen" to prevent the provider from getting disposed while
      // awaiting the done operation
      final sub = ref.listen<TestResult>(
        $result,
        (previous, current) {},
      );
      Future(sub.read().done).then((doneEvent) {
        // TODO test `success = null`
        final exitCode = doneEvent.success != false ? 0 : -1;

        completer.complete(exitCode);
      });
    }

    final exitCode = await completer.future;
    print('got exit code $exitCode');
    await Future.delayed(Duration(seconds: 2));
    print('done');
    return exitCode;
  }, overrides: [
    if (workingDirectory != null)
      $workingDirectory.overrideWithValue(Directory(workingDirectory)),
  ]);
}
