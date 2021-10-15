import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:args/args.dart';
import 'package:cli_util/cli_logging.dart';
import 'package:riverpod/riverpod.dart';
import 'package:dart_test_adapter/dart_test_adapter.dart';
import 'package:ansi_styles/ansi_styles.dart';
import 'package:collection/collection.dart';
import 'package:dart_console/dart_console.dart';
import 'package:test/expect.dart';

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
});

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

const _ESC = '\x1B';

abstract class _VT100 {
  static const String clearScreen = '$_ESC[2J';
  static const String moveCursorToTopLeft = '$_ESC[H';

  static const String saveCursor = '${_ESC}7';
  static const String restoreCursor = '${_ESC}8';

  static const String clearScreenFromCursorDown = '$_ESC[J';
}

class _FailedTestLocation {
  _FailedTestLocation({required this.path, required this.name});

  final String path;
  final String name;
}

abstract class _TestStatus {
  static final $result = Provider<TestResult>((ref) => flutterTest());

  static final $failedTestsLocation =
      StateProvider<List<_FailedTestLocation>>((ref) => []);

  static final $suiteCount = FutureProvider<int>((ref) async {
    final allSuites = await ref.watch($result).allSuites();
    return allSuites.count;
  });

  static final $suite = FutureProvider.family<Suite, int>((ref, suiteID) async {
    final suiteEvent = await ref
        .watch($result)
        .suites()
        .firstWhere((e) => e.suite.id == suiteID);

    return suiteEvent.suite;
  });

  static final $suiteStatus =
      Provider.family<AsyncValue<void>, int>((ref, suiteID) {
    final testIds = ref.watch($testIdsForSuite(suiteID));

    return testIds.when(
      error: (err, stack, _) => AsyncError(err, stackTrace: stack),
      loading: (_) => AsyncLoading(),
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
  });

  static final $group = FutureProvider.family<Group, int>((ref, groupID) async {
    final groupEvent = await ref
        .watch($result)
        .groups()
        .firstWhere((e) => e.group.id == groupID);

    return groupEvent.group;
  });

  static final $rootGroup = FutureProvider.family<Group, int>((ref, suiteID) {
    return ref
        .watch($result)
        .groups()
        .firstWhere((e) => e.group.parentID == null)
        .then((e) => e.group);
  });

  static final $testIdsForSuite =
      StreamProvider.family<List<int>, int>((ref, suiteID) async* {
    yield* ref.watch($result).testStart().where((event) {
      return event.test.url != null && event.test.suiteID == suiteID;
    }).map((event) {
      return event.test.id;
    }).combined();
  });

  static final $test = StreamProvider.family<Test, int>((ref, testID) async* {
    await for (final events in ref.watch($result).testStart().combined()) {
      final event = events.lastWhereOrNull((e) => e.test.id == testID);

      if (event != null) yield event.test;
    }
  });

  static final $allTests = StreamProvider<List<Test>>((ref) {
    return ref.watch($result).testStart().map((event) => event.test).combined();
  });

  static final $allFailedTests = Provider<AsyncValue<List<Test>>>((ref) {
    return _merge((unwrap) {
      return unwrap(ref.watch($allTests))
          .where((test) => ref.watch($testStatus(test.id)) is AsyncError)
          .toList();
    });
  });

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
  });

  static final $suites = StreamProvider<List<Suite>>((ref) {
    final result = ref.watch(_TestStatus.$result);

    return result
        .suites()
        .combined()
        .map((event) => event.map((e) => e.suite).toList());
  });

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
        rootGroup.name,
      ].join(' ');
    });
  });

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

      'started test:  ${test.name}';

      final status = ref.watch($testStatus(testID));

      return status.when(
        data: (data) => '${'✓'.green} ${test.name}',
        error: (err, stack, _) {
          if (err is FailedTestException) {
            return '''
${'✕'.red} ${test.name}

Error:
${err.testError.error}

At:
${err.testError.stackTrace}''';
          }
          return '''
${'✕'.red}: ${test.name}

Error:
$err

At:
$stack''';
        },
        loading: (_) => '${ref.watch($spinner)} ${test.name}',
      );
    });
  });

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
  });

  static final $output = Provider.autoDispose<AsyncValue<String>>((ref) {
    return _merge((unwrap) {
      final suites = unwrap(ref.watch($suites));

      final passingSuites = suites
          .where((suite) => ref.watch($suiteStatus(suite.id)) is AsyncData)
          .map((suite) =>
              unwrap(ref.watch($suiteOutputLabel(suite.id))) +
              ' `${suite.platform}`')
          .join('\n');
      final failingSuites = suites
          .where((suite) => ref.watch($suiteStatus(suite.id)) is AsyncError)
          .expand((suite) {
        return [
          unwrap(ref.watch($suiteOutputLabel(suite.id))),
          unwrap(ref.watch($suiteTestsOutputLabels(suite.id))),
          ' `${suite.platform}`',
        ];
      }).join('\n');
      final loadingSuites = suites
          .where((suite) => ref.watch($suiteStatus(suite.id)) is AsyncLoading)
          .expand((suite) {
        return [
          unwrap(ref.watch($suiteOutputLabel(suite.id))),
          unwrap(ref.watch($suiteTestsOutputLabels(suite.id))),
          ' `${suite.platform}`',
        ];
      }).join('\n');

      return [
        if (passingSuites.isNotEmpty) passingSuites,
        if (loadingSuites.isNotEmpty) loadingSuites,
        if (failingSuites.isNotEmpty) failingSuites,
      ].join('\n\n');
    });
  });
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

extension on ProviderContainer {
  Stream<T> listenAsStream<T>(ProviderBase<AsyncValue<T>> provider) {
    final controller = StreamController<T>();

    late ProviderSubscription<AsyncValue<T>> sub;

    controller.onListen = () => sub = listen<AsyncValue<T>>(
          provider,
          (value) {
            value.when(
              data: controller.add,
              error: (error, stack, _) => controller.addError(error, stack),
              loading: (_) {},
            );
          },
        );
    controller.onCancel = () => sub.close();

    return controller.stream;
  }
}

class FailedTestException implements Exception {
  FailedTestException(this.testError);
  final TestEventTestError testError;
}

Future<void> fest({
  bool watch = false,
  Logger? logger,
}) async {
  logger ??= Logger.standard();

  final container = ProviderContainer();

  if (watch) {
    stdout.write('${_VT100.clearScreen}${_VT100.moveCursorToTopLeft}');

    container.listen(
      _$fileChange,
      (value) => container.refresh(_TestStatus.$result),
    );

    container.listen<AsyncValue<List<Test>>>(
      _TestStatus.$allFailedTests,
      (value) {
        _merge((unwrap) {
          final failedTests = unwrap(value);

          final failedTestsLocations = failedTests.map((test) {
            final suite = unwrap(
              container.read(_TestStatus.$suite(test.suiteID)),
            );

            return _FailedTestLocation(
              path: suite.path!,
              name: test.name,
            );
          }).toList();

          container.read(_TestStatus.$failedTestsLocation).state =
              failedTestsLocations;
        });
      },
    );
  }

  // TODO dispose

  String? lastOutput;

  final outputStream = container.listenAsStream(_TestStatus.$output);

  await outputStream.forEach((output) {
    // console.cursorPosition = originalCursorPosition;

    if (lastOutput != null) {
      final lastOutputHeight = lastOutput!.split('\n').length;

      stdout.write('${_ESC}[${lastOutputHeight}A');
    }
    stdout.write('${_ESC}[J');

    print(output);

    lastOutput = output;
  });
}
