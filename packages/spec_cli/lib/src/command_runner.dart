import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod/riverpod.dart';
import 'package:dart_test_adapter/dart_test_adapter.dart';
import 'package:ansi_styles/ansi_styles.dart';
import 'package:spec_cli/src/container.dart';
import 'package:spec_cli/src/logger.dart';

import 'vt100.dart';

Future<void> festCommandRunner(List<String> args) async {
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

final _$workingDirectory = Provider((ref) => Directory.current);

final _$fileChange = StreamProvider<void>((ref) {
  final dir = ref.watch(_$workingDirectory);

  return dir
      .watch(recursive: true)
      .where((e) => !e.path.contains('/.dart_tool/'));
}, dependencies: [_$workingDirectory]);

extension Ansi on String {
  String get reset => AnsiStyles.reset(this);
  String get bold => AnsiStyles.bold(this);
  String get dim => AnsiStyles.dim(this);
  String get italic => AnsiStyles.italic(this);
  String get underline => AnsiStyles.underline(this);
  String get blink => AnsiStyles.blink(this);
  String get inverse => AnsiStyles.inverse(this);
  String get hidden => AnsiStyles.hidden(this);
  String get strikethrough => AnsiStyles.strikethrough(this);
  String get black => AnsiStyles.black(this);
  String get red => AnsiStyles.red(this);
  String get green => AnsiStyles.green(this);
  String get yellow => AnsiStyles.yellow(this);
  String get blue => AnsiStyles.blue(this);
  String get magenta => AnsiStyles.magenta(this);
  String get cyan => AnsiStyles.cyan(this);
  String get white => AnsiStyles.white(this);
  String get blackBright => AnsiStyles.blackBright(this);
  String get redBright => AnsiStyles.redBright(this);
  String get greenBright => AnsiStyles.greenBright(this);
  String get yellowBright => AnsiStyles.yellowBright(this);
  String get blueBright => AnsiStyles.blueBright(this);
  String get magentaBright => AnsiStyles.magentaBright(this);
  String get cyanBright => AnsiStyles.cyanBright(this);
  String get whiteBright => AnsiStyles.whiteBright(this);
  String get bgBlack => AnsiStyles.bgBlack(this);
  String get bgRed => AnsiStyles.bgRed(this);
  String get bgGreen => AnsiStyles.bgGreen(this);
  String get bgYellow => AnsiStyles.bgYellow(this);
  String get bgBlue => AnsiStyles.bgBlue(this);
  String get bgMagenta => AnsiStyles.bgMagenta(this);
  String get bgCyan => AnsiStyles.bgCyan(this);
  String get bgWhite => AnsiStyles.bgWhite(this);
  String get bgBlackBright => AnsiStyles.bgBlackBright(this);
  String get bgRedBright => AnsiStyles.bgRedBright(this);
  String get bgGreenBright => AnsiStyles.bgGreenBright(this);
  String get bgYellowBright => AnsiStyles.bgYellowBright(this);
  String get bgBlueBright => AnsiStyles.bgBlueBright(this);
  String get bgMagentaBright => AnsiStyles.bgMagentaBright(this);
  String get bgCyanBright => AnsiStyles.bgCyanBright(this);
  String get bgWhiteBright => AnsiStyles.bgWhiteBright(this);
  String get grey => AnsiStyles.grey(this);
  String get bgGrey => AnsiStyles.bgGrey(this);
  String get gray => AnsiStyles.gray(this);
  String get bgGray => AnsiStyles.bgGray(this);
}

class _FailedTestLocation {
  _FailedTestLocation({required this.path, required this.name});

  final String path;
  final String name;
}

@visibleForTesting
abstract class TestStatus {
  static final $failedTestsLocationFromPreviousRun =
      StateProvider<List<_FailedTestLocation>?>((ref) => null);

  static final $result = Provider<TestResult>(
    (ref) {
      final locations =
          ref.watch($failedTestsLocationFromPreviousRun.notifier).state;

      final tests = locations
          ?.map(
            (location) =>
                '${location.path}?full-name=${Uri.encodeQueryComponent(location.name)}',
          )
          .toList();

      final result = dartTest(
        tests: tests,
        workdingDirectory: ref.watch(_$workingDirectory).path,
      );
      ref.onDispose(result.dispose);
      return result;
    },
    dependencies: [
      _$workingDirectory,
      $failedTestsLocationFromPreviousRun.notifier
    ],
  );

  static final $suiteCount = FutureProvider<int>((ref) async {
    final allSuites = await ref.watch($result).allSuites();
    return allSuites.count;
  }, dependencies: [$result]);

  static final $suite = FutureProvider.family<Suite, int>((ref, suiteID) async {
    final suiteEvent = await ref
        .watch($result)
        .suites()
        .firstWhere((e) => e.suite.id == suiteID);

    return suiteEvent.suite;
  }, dependencies: [$result]);

  static final $suiteStatus =
      Provider.family<AsyncValue<void>, int>((ref, suiteID) {
    final testIds = ref.watch($testIdsForSuite(suiteID));

    return testIds.when(
      error: (err, stack) => AsyncError(err, stackTrace: stack),
      loading: () => AsyncLoading(),
      data: (testIds) {
        // any loading leads to RUNNING, even if there's an error/success
        final hasLoading =
            testIds.any((id) => ref.watch($testStatus(id)) is AsyncLoading);
        if (hasLoading) return AsyncLoading();

        late final error = testIds
            .map((id) => ref.watch($testStatus(id)))
            .firstWhereOrNull((status) => status is AsyncError) as AsyncError?;

        if (error != null) {
          return AsyncError(
            error.error,
            stackTrace: error.stackTrace,
          );
        }

        return AsyncData(null);
      },
    );
  }, dependencies: [$testIdsForSuite]);

  static final $group = FutureProvider.family<Group, int>((ref, groupID) async {
    final groupEvent = await ref
        .watch($result)
        .groups()
        .firstWhere((e) => e.group.id == groupID);

    return groupEvent.group;
  }, dependencies: [$result]);

  static final $rootGroup = FutureProvider.family<Group, int>((ref, suiteID) {
    return ref
        .watch($result)
        .groups()
        .firstWhere((e) => e.group.parentID == null)
        .then((e) => e.group);
  }, dependencies: [$result]);

  static final $testIdsForSuite =
      StreamProvider.family<List<int>, int>((ref, suiteID) async* {
    yield* ref.watch($result).testStart().where((event) {
      return event.test.url != null && event.test.suiteID == suiteID;
    }).map((event) {
      return event.test.id;
    }).combined();
  }, dependencies: [$result]);

  static final $test = StreamProvider.family<Test, int>((ref, testID) async* {
    await for (final events in ref.watch($result).testStart().combined()) {
      final event = events.lastWhereOrNull((e) => e.test.id == testID);

      if (event != null) yield event.test;
    }
  }, dependencies: [$result]);

  static final $allTests = StreamProvider<List<Test>>((ref) {
    return ref.watch($result).testStart().map((event) => event.test).combined();
  }, dependencies: [$result]);

  static final $allFailedTests = Provider<AsyncValue<List<Test>>>((ref) {
    return _merge((unwrap) {
      return unwrap(ref.watch($allTests))
          .where((test) => ref.watch($testStatus(test.id)) is AsyncError)
          .toList();
    });
  }, dependencies: [$allTests, $testStatus]);

  static final $currentlyFailedTestsLocation =
      Provider<AsyncValue<List<_FailedTestLocation>>>((ref) {
    return _merge((unwrap) {
      final failedTests = unwrap(ref.watch($allFailedTests));

      return failedTests.map((test) {
        final suite = unwrap(
          ref.watch($suite(test.suiteID)),
        );

        return _FailedTestLocation(
          path: suite.path!,
          name: test.name,
        );
      }).toList();
    });
  }, dependencies: [$allFailedTests, $suite]);

  static final $testStatus =
      FutureProvider.family<void, int>((ref, testID) async {
    // No need to wait for test start event

    // will either throw or complete, allowing test status handling through "when(loading, error, data)   "

    await Future.any([
      ref //
          .watch($result)
          .testDone()
          .firstWhere(
            (e) => e.testID == testID && e.result == TestDoneStatus.success,
          ),
      ref
          .watch($result)
          .testError()
          .firstWhere((e) => e.testID == testID)
          .then((e) => throw FailedTestException(e)),
    ]);
  }, dependencies: [$result]);

  static final $suites = StreamProvider<List<Suite>>((ref) {
    final result = ref.watch($result);

    return result
        .suites()
        .combined()
        .map((event) => event.map((e) => e.suite).toList());
  }, dependencies: [$result]);

  static final $suiteOutputLabel =
      Provider.family<AsyncValue<String>, int>((ref, suiteID) {
    return _merge((unwrap) {
      final suite = unwrap(ref.watch($suite(suiteID)));
      final rootGroup = unwrap(ref.watch($rootGroup(suiteID)));
      final suiteStatus = ref.watch($suiteStatus(suiteID));

      return [
        suiteStatus.map(
          data: (_) => ' PASS '.black.bgGreen,
          error: (_) => ' FAIL '.white.bgRed,
          loading: (_) => ' RUNS '.black.bgYellow,
        ),
        if (suite.path != null) suite.path!,
        if (rootGroup.name.isNotEmpty) rootGroup.name,
      ].join(' ');
    });
  }, dependencies: [$suite, $rootGroup, $suiteStatus]);

  static final $spinner = Provider.autoDispose<String>((ref) {
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

  static final $testsOutputLabel =
      Provider.autoDispose.family<AsyncValue<String>, int>((ref, testID) {
    return _merge((unwrap) {
      final test = unwrap(ref.watch($test(testID)));

      final status = ref.watch($testStatus(testID));

      return status.when(
        data: (data) => '  ${'✓'.green} ${test.name}',
        error: (err, stack) {
          final error = err is FailedTestException ? err.testError.error : err;

          final stackTrace = err is FailedTestException
              ? err.testError.stackTrace
              : stack.toString();

          return '''
  ${'✕'.red} ${test.name}
${error.toString().multilinePadLeft(4)}
${stackTrace.multilinePadLeft(4)}''';
        },
        loading: () => '  ${ref.watch($spinner)} ${test.name}',
      );
    });
  }, dependencies: [$test, $testStatus, $spinner]);

  static final $suiteTestsOutputLabels =
      Provider.autoDispose.family<AsyncValue<String>, int>((ref, suiteID) {
    return _merge((unwrap) {
      final testIds = unwrap(ref.watch($testIdsForSuite(suiteID)));

      final loadingTestLabels = testIds
          .where((id) => ref.watch($testStatus(id)) is AsyncLoading)
          .map((id) => ref.watch($testsOutputLabel(id)).asData?.value)
          .where((label) => label != null)
          .join('\n');
      final failingTestLabels = testIds
          .where((id) => ref.watch($testStatus(id)) is AsyncError)
          .map((id) => ref.watch($testsOutputLabel(id)).asData?.value)
          .where((label) => label != null)
          .join('\n');
      final successTestLabels = testIds
          .where((id) => ref.watch($testStatus(id)) is AsyncData)
          .map((id) => ref.watch($testsOutputLabel(id)).asData?.value)
          .where((label) => label != null)
          .join('\n');

      return [
        if (successTestLabels.isNotEmpty) successTestLabels,
        if (loadingTestLabels.isNotEmpty) loadingTestLabels,
        if (failingTestLabels.isNotEmpty) failingTestLabels,
      ].join('\n');
    });
  }, dependencies: [$testIdsForSuite, $testStatus, $testsOutputLabel]);

  static final $output = Provider.autoDispose<AsyncValue<String>>((ref) {
    return _merge((unwrap) {
      final suites = unwrap(ref.watch($suites));

      final passingSuites = suites
          .where((suite) => ref.watch($suiteStatus(suite.id)) is AsyncData)
          .map((suite) => unwrap(ref.watch($suiteOutputLabel(suite.id))))
          .join('\n');
      final failingSuites = suites
          .where((suite) => ref.watch($suiteStatus(suite.id)) is AsyncError)
          .expand((suite) {
        return [
          unwrap(ref.watch($suiteOutputLabel(suite.id))),
          unwrap(ref.watch($suiteTestsOutputLabels(suite.id))),
        ];
      }).join('\n');
      final loadingSuites = suites
          .where((suite) => ref.watch($suiteStatus(suite.id)) is AsyncLoading)
          .expand((suite) {
        return [
          unwrap(ref.watch($suiteOutputLabel(suite.id))),
          unwrap(ref.watch($suiteTestsOutputLabels(suite.id))),
        ];
      }).join('\n');

      return [
        if (passingSuites.isNotEmpty) passingSuites,
        if (loadingSuites.isNotEmpty) loadingSuites,
        if (failingSuites.isNotEmpty) failingSuites,
      ].join('\n\n');
    });
  }, dependencies: [
    $suites,
    $suiteStatus,
    $suiteOutputLabel,
    $suiteTestsOutputLabels
  ]);
}

extension on String {
  String multilinePadLeft(int tab) {
    return this.split('\n').map((e) {
      // Don't add padding on empty lines
      if (e.isEmpty) return e;
      return ' ' * tab + e;
    }).join('\n');
  }
}

AsyncValue<T> _merge<T>(T Function(R Function<R>(AsyncValue<R>) unwrap) cb) {
  try {
    R unwrap<R>(AsyncValue<R> asyncValue) {
      return asyncValue.map(
        data: (d) => d.value,
        error: (e) => throw e,
        loading: (l) => throw l,
      );
    }

    return AsyncData(cb(unwrap));
  } on AsyncError catch (e) {
    return AsyncError(e.error, stackTrace: e.stackTrace);
  } on AsyncLoading {
    return AsyncLoading();
  } catch (err, stack) {
    return AsyncError<T>(err, stackTrace: stack);
  }
}

extension<T> on Stream<T> {
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

Future<void> fest({
  bool watch = false,
  String? workingDirectory,
}) {
  return runScoped((ref) async {
    if (watch) {
      stdout.write('${VT100.clearScreen}${VT100.moveCursorToTopLeft}');

      ref.listen(
        _$fileChange,
        (prev, value) {
          ref.refresh(TestStatus.$result);
        },
      );

      List<_FailedTestLocation> _lastFailedTests = [];

      ref.listen<AsyncValue<List<_FailedTestLocation>>>(
          TestStatus.$currentlyFailedTestsLocation, (prev, value) {
        value.when(
          data: (value) => _lastFailedTests = value,
          loading: () => _lastFailedTests = [],
          error: (err, stack) => print('error'),
        );
      });

      ref.listen(_$fileChange, (prev, value) {
        ref
            .read(TestStatus.$failedTestsLocationFromPreviousRun.notifier)
            .state = _lastFailedTests;
      });
      stdin.listen((event) {
        if (event.first == 10) {
          // enter
          ref
              .read(TestStatus.$failedTestsLocationFromPreviousRun.notifier)
              .state = _lastFailedTests;
        }
      });
    }

    // TODO dispose

    ref.listen<AsyncValue<String>>(TestStatus.$output, (lastOutput, output) {
      final logger = ref.read(loggerProvider);

      // console.cursorPosition = originalCursorPosition;
      if (watch) {
        logger.stdout(
          '${VT100.moveCursorToTopLeft}${VT100.clearScreenFromCursorDown}',
        );
      } else {
        if (lastOutput?.asData != null) {
          final lastOutputHeight = lastOutput!.asData!.value.split('\n').length;

          logger.stdout(VT100.moveCursorUp(lastOutputHeight));
        }
        logger.stdout(VT100.clearScreenFromCursorDown);
      }

      output.when(
        loading: () {}, // nothing to do
        error: (err, stack) {}, // TODO print error
        data: (output) => logger.stdout(output),
      );
    });

    final completer = Completer<void>();

    if (!watch) {
      // if not in watch mode, finish the command when the test proccess completes.
      final sub = ref.listen<TestResult>(
        TestStatus.$result,
        (previous, current) {},
      );
      Future(sub.read().done).then(completer.complete);
    }

    await completer.future;
  }, overrides: [
    if (workingDirectory != null)
      _$workingDirectory.overrideWithValue(Directory(workingDirectory)),
  ]);
}
