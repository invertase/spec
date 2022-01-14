import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod/riverpod.dart';

import 'container.dart';
import 'dart_test.dart';
import 'io.dart';
import 'key_codes.dart';
import 'renderer.dart';
import 'rendering.dart';
import 'suites.dart';
import 'tests.dart';
import 'vt100.dart';

Future<int> specCommandRunner(List<String> args) async {
  final exitCode = await _SpecCommandRunner().run(args);
  // May return null when using -h
  return exitCode ?? 0;
}

class _SpecCommandRunner extends CommandRunner<int> {
  _SpecCommandRunner()
      : super(
          'spec',
          'A command line for running tests on Dart/Flutter projects',
        ) {
    _setupArgParser(argParser);
  }

  static void _setupArgParser(ArgParser argParser) {
    argParser
      ..addFlag(
        'watch',
        abbr: 'w',
        negatable: false,
        help: 'Listens to changes in the project and '
            'run tests whenever something changed',
      )
      ..addFlag(
        'coverage',
        abbr: 'c',
        negatable: false,
        help: 'Extract code coverage reports.',
      )
      ..addMultiOption(
        'name',
        abbr: 'n',
        help: 'Filters tests by name.',
      );
  }

  static SpecOptions _decodeArgs(ArgResults result) {
    return SpecOptions(
      watch: result['watch'] as bool,
      fileFilters: result.rest,
      testNameFilters: result['name'] as List<String>,
      coverage: result['coverage'] as bool,
    );
  }

  @override
  Future<int?> runCommand(ArgResults topLevelResults) {
    if (topLevelResults['help'] as bool) {
      return super.runCommand(topLevelResults);
    }

    return spec(options: _decodeArgs(topLevelResults));
  }
}

@immutable
class SpecOptions {
  const SpecOptions({
    this.fileFilters = const [],
    this.testNameFilters = const [],
    this.watch = false,
    this.coverage = false,
  });

  factory SpecOptions.fromArgs(List<String> args) {
    final parser = ArgParser();
    _SpecCommandRunner._setupArgParser(parser);

    final result = parser.parse(args);

    return _SpecCommandRunner._decodeArgs(result);
  }

  final List<String> fileFilters;
  final List<String> testNameFilters;
  final bool watch;
  final bool coverage;

  @override
  bool operator ==(Object other) =>
      other is SpecOptions &&
      other.runtimeType == runtimeType &&
      other.coverage == coverage &&
      other.watch == watch &&
      const DeepCollectionEquality().equals(other.fileFilters, fileFilters) &&
      const DeepCollectionEquality()
          .equals(testNameFilters, other.testNameFilters);

  @override
  int get hashCode => Object.hash(
        runtimeType,
        coverage,
        watch,
        const DeepCollectionEquality().hash(fileFilters),
        const DeepCollectionEquality().hash(testNameFilters),
      );

  @override
  String toString() {
    return 'SpecOptions('
        'watch: $watch, '
        'coverage: $coverage, '
        'fileFilters: $fileFilters, '
        'testNameFilters: $testNameFilters'
        ')';
  }
}

final _$lastFailedTests = StateProvider<List<FailedTestLocation>>((ref) => []);

Future<int> spec({
  String? workingDirectory,
  SpecOptions options = const SpecOptions(),
}) {
  return runScoped((ref) async {
    try {
      if (stdin.hasTerminal) {
        // Stop your keystrokes being printed automatically.
        // Needs to be disabled for lineMode to be disabled too.
        stdin.echoMode = false;

        // This will cause the stdin stream to provide the input as soon as it
        // arrives, so in interactive mode this will be one key press at a time.
        stdin.lineMode = false;
      }

      // initializing option providers from command line options.
      ref.read($testNameFilters.notifier).state =
          options.testNameFilters.isEmpty
              ? null
              : RegExp(
                  '(?:${options.testNameFilters.map(RegExp.escape).join('|')})',
                );
      ref.read($filePathFilters.notifier).state = options.fileFilters;
      ref.read($isWatchMode.notifier).state = options.watch;
      ref.read($startTime.notifier).state = DateTime.now();

      if (options.watch) {
        stdout.write('${VT100.clearScreen}${VT100.moveCursorToTopLeft}');

        ref.listen<AsyncValue<List<FailedTestLocation>>>(
            $currentlyFailedTestsLocation, (prev, value) {
          value.when(
            data: (value) => ref.read(_$lastFailedTests.notifier).state = value,
            loading: () => ref.read(_$lastFailedTests.notifier).state = [],
            error: (err, stack) {
              Zone.current.handleUncaughtError(err, stack!);
            },
          );
        });

        ref.listen(
          $fileChange,
          (prev, value) {
            resartTests(ref);
          },
        );

        stdin.listen((event) {
          if (ref.read($isEditingTestNameFilter)) {
            _handleTestNameEditKeyPress(event, ref);
          } else {
            _handleWatchKeyPress(event, ref);
          }
        });
      }

      final renderer = rendererOverride ??
          (options.watch ? FullScreenRenderer() : BacktrackingRenderer());

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

      if (options.watch) {
        // In watch mode, don't quite until sigint/sigterm is sent
        final completer = Completer<int>();
        ref.listen<bool>($isEarlyAbort, (previous, isEarlyAbort) {
          if (isEarlyAbort) completer.complete(-1);
        });
        return await completer.future;
      } else {
        // Outside of watch mode, quite as soon we know what the exit code should be
        return await ref.read($exitCode.future);
      }
    } finally {
      stdout.write(VT100.showCursor);
    }
  }, overrides: [
    if (workingDirectory != null)
      $workingDirectory.overrideWithValue(Directory(workingDirectory)),
  ]);
}

void _handleTestNameEditKeyPress(List<int> keyCodes, DartRef ref) {
  if (keyCodes.length == 1) {
    switch (keyCodes.first) {
      case KeyCode.enter:
        // submitting the filter change and restarting tests
        ref.read($isEditingTestNameFilter.notifier).state = false;
        ref.read($testNameFilters.notifier).state =
            ref.read($editingTestNameTextField).isEmpty
                ? null
                : RegExp(ref.read($editingTestNameTextField));
        resartTests(ref);
        break;
      case KeyCode.escape:
        // aborts the edit
        ref.read($isEditingTestNameFilter.notifier).state = false;

        break;
      case KeyCode.delete:
        ref.read($editingTestNameTextField.notifier).update((state) {
          return state.isEmpty ? '' : state.substring(0, state.length - 1);
        });
        break;
      default:
        ref.read($editingTestNameTextField.notifier).state +=
            String.fromCharCode(keyCodes.single);
    }
  }
}

void _handleWatchKeyPress(List<int> keyCodes, DartRef ref) {
  if (keyCodes.length == 1) {
    switch (keyCodes.first) {
      case KeyCode.q:
        // stop the watch mode
        ref.read($didPressQ.notifier).state = true;
        break;
      case KeyCode.w:
        // pressed `w`, expanding the tooltip explaining the various commands
        // during watch mode
        ref.read($showWatchUsage.notifier).state = true;
        break;
      case KeyCode.f:
        // pressed `f`, toggling "run failing tests" mode

        ref.read($isRunningOnlyFailingTests.notifier).update((state) => !state);
        resartTests(ref);
        break;
      case KeyCode.t:
        // pressed `t`, starting the editing of "filter by name"

        ref.read($editingTestNameTextField.notifier).state =
            ref.read($testNameFilters)?.pattern ?? '';
        ref.read($isEditingTestNameFilter.notifier).state = true;
        resartTests(ref);
        break;
      case KeyCode.enter:
        // stop the watch mode
        // Aborting/resuming tests

        if (!ref.read($events).isInterrupted && !ref.read($isDone)) {
          ref.read($events.notifier).stop();
        } else {
          resartTests(ref);
        }

        // ref.read($failedTestsLocationFromPreviousRun.notifier).state =
        //     lastFailedTests;
        break;
      default:
    }
  }
}

void resartTests(DartRef ref) {
  ref.read($startTime.notifier).state = DateTime.now();
  ref.read($failedTestLocationToExecute.notifier).state =
      ref.read(_$lastFailedTests);
  ref.refresh($events);
}
