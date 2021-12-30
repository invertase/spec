import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:dart_test_adapter/dart_test_adapter.dart';
import 'package:collection/collection.dart';
import 'package:riverpod/riverpod.dart';
import 'package:spec_cli/src/collection.dart';
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
          ref.refresh($events);
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
          error: (err, stack) => print('Error: failed to render\n$err\n$stack'),
          data: (output) {
            if (output.trim().isNotEmpty) renderer.renderFrame(output);
          },
        );
      },
      fireImmediately: true,
    );

    final exitCodeCompleter = Completer<int>();

    if (!watch) {
      // if not in watch mode, finish the command when the test proccess completes.

      // use "listen" to prevent the provider from getting disposed while
      // awaiting the done operation
      ref.listen<List<TestEvent>>(
        $events,
        (_, events) {
          final doneEvent = events.firstWhereTypeOrNull<TestEventDone>();
          if (doneEvent == null) return;

          // TODO test `success = null`
          final exitCode = doneEvent.success != false ? 0 : -1;

          exitCodeCompleter.complete(exitCode);
        },
        fireImmediately: true,
      );
    }

    await exitCodeCompleter.future;
    // Wait for the summary to be printed, since it is renderer right after the
    // exit code is obtained to obtain the time spent
    await ref.pump();

    return exitCodeCompleter.future;
  }, overrides: [
    if (workingDirectory != null)
      $workingDirectory.overrideWithValue(Directory(workingDirectory)),
  ]);
}

final $done = Provider.autoDispose<TestEventDone?>((ref) {
  final events = ref.watch($events);

  return events.whereType<TestEventDone>().firstOrNull;
}, dependencies: [$events]);
