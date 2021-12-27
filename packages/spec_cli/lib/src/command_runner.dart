import 'dart:async';
import 'dart:io';

import 'package:ansi_styles/ansi_styles.dart';
import 'package:args/args.dart';
import 'package:dart_test_adapter/dart_test_adapter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod/riverpod.dart';
import 'package:spec_cli/src/container.dart';
import 'package:spec_cli/src/renderer.dart';

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

  /** Suites */

  static final $suiteCount = FutureProvider<int>((ref) async {
    final allSuites = await ref.watch($result).allSuites();
    return allSuites.count;
  }, dependencies: [$result]);

  static final $suites = StreamProvider<List<Suite>>((ref) {
    final result = ref.watch($result);

    return result
        .suites()
        .combined()
        .map((event) => event.map((e) => e.suite).toList());
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
    return _merge((unwrap) {
      final tests = unwrap(ref.watch($testsForSuite(suiteID)));
      final visibleTests =
          tests.values.where((test) => !test.isHidden).toList();

      /// We verify that "testIds" contains all ids that this suite is supposed
      /// to have. In case we have yet to receive some test events.
      final hasAllVisibleIds = ref.watch(
        $scaffoldGroup(suiteID).select(
          (rootGroup) =>
              rootGroup.asData != null &&
              visibleTests.length == rootGroup.asData!.value.testCount,
        ),
      );
      if (!hasAllVisibleIds) {
        // TODO update after https://github.com/dart-lang/test/issues/1652 is resolved
        unwrap(const AsyncLoading());
      }

      // any loading leads to RUNNING, even if there's an error/success
      final hasLoading =
          tests.keys.any((id) => ref.watch($testStatus(id)) is AsyncLoading);
      if (hasLoading) unwrap(const AsyncLoading());

      final error = tests.keys
          .map((id) => ref.watch($testStatus(id)))
          .firstWhereOrNull((status) => status is AsyncError) as AsyncError?;

      if (error != null) {
        unwrap(
          AsyncError(
            error.error,
            stackTrace: error.stackTrace,
          ),
        );
      }

      return;
    });
  }, dependencies: [
    $testsForSuite,
    $scaffoldGroup,
    $testStatus,
  ]);

  /** Groups */

  static final $group = FutureProvider.family<Group, int>((ref, groupID) async {
    final groupEvent = await ref
        .watch($result)
        .groups()
        .firstWhere((e) => e.group.id == groupID);

    return groupEvent.group;
  }, dependencies: [$result]);

  /// The virtual top-most group added by the test package.
  static final $scaffoldGroup =
      FutureProvider.family<Group, int>((ref, suiteID) {
    return ref
        .watch($result)
        .groups()
        .firstWhere((e) => e.group.parentID == null)
        .then((e) => e.group);
  }, dependencies: [$result]);

  /// User-defined groups at the root of a suite (excluding [$scaffoldGroup])
  static final $rootGroupsForSuite = StreamProvider.autoDispose
      .family<List<Group>, int>((ref, suiteID) async* {
    final scaffoldGroup = await ref.watch($scaffoldGroup(suiteID).future);

    yield* ref
        .watch($result)
        .groups()
        .where((e) => e.group.parentID == scaffoldGroup)
        .map((e) => e.group)
        .combined();
  }, dependencies: [$scaffoldGroup, $result]);

  static final $childrenGroupsForGroup =
      StreamProvider.autoDispose.family<List<Group>, int>((ref, groupID) {
    return ref
        .watch($result)
        .groups()
        .where((e) => e.group.parentID == groupID)
        .map((e) => e.group)
        .combined();
  }, dependencies: [$result]);

  /** Tests */

  static final $rootTestsForSuite =
      Provider.autoDispose.family<AsyncValue<List<Test>>, int>((ref, suiteID) {
    return _merge((unwrap) {
      final testsForSuite = unwrap(ref.watch($testsForSuite(suiteID)));

      return testsForSuite.values
          // Tests with no groups are errored tests such as when there is a compilation error.
          // Tests with a single group are user-defined tests, since that group is added implicitly
          .where((test) => test.groupIDs.length < 2)
          .toList();
    });
  }, dependencies: [$testsForSuite]);

  static final $testsForGroup =
      Provider.autoDispose.family<AsyncValue<List<Test>>, _GroupID>((ref, id) {
    return _merge((unwrap) {
      final testsForSuite = unwrap(ref.watch($testsForSuite(id.suiteID)));

      return testsForSuite.values
          .where((test) =>
              test.groupIDs.isNotEmpty && test.groupIDs.last == id.groupID)
          .toList();
    });
  }, dependencies: [$testsForSuite]);

  static final $testsForSuite =
      StreamProvider.family<Map<int, Test>, int>((ref, suiteID) {
    final controller = StreamController<Map<int, Test>>();
    controller.onListen = () => controller.add({});
    ref.onDispose(controller.close);

    final tests = <int, Test>{};

    ref
        .watch($result)
        .testStart()
        .where((event) => event.test.suiteID == suiteID)
        .where((event) => !event.test.isHidden)
        .listen((event) {
      if (!tests.containsKey(event.test.id)) {
        tests[event.test.id] = event.test;
        controller.add({...tests});
      }
    });

    return controller.stream;
  }, dependencies: [$result]);

  static final $test = StreamProvider.family<Test, int>((ref, testID) async* {
    await for (final testStart in ref.watch($result).testStart()) {
      if (testStart.test.id == testID) yield testStart.test;
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

  /** Output */

  static final $suiteOutputLabel =
      Provider.family<AsyncValue<String>, int>((ref, suiteID) {
    return _merge((unwrap) {
      final suite = unwrap(ref.watch($suite(suiteID)));
      final suiteStatus = ref.watch($suiteStatus(suiteID));

      return [
        suiteStatus.map(
          data: (_) => ' PASS '.black.bgGreen,
          error: (_) => ' FAIL '.white.bgRed,
          loading: (_) => ' RUNS '.black.bgYellow,
        ),
        if (suite.path != null) suite.path!,
      ].join(' ');
    });
  }, dependencies: [$suite, $scaffoldGroup, $suiteStatus]);

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

  static final $testMessages =
      Provider.autoDispose.family<List<String>, int>((ref, testID) {
    final result = ref.watch($result);

    final messages = result
        .messages()
        .where((e) => e.testID == testID)
        .map((e) => e.message);

    final sub = messages.listen(
      (message) => ref.state = [...ref.state, message],
    );
    ref.onDispose(sub.cancel);

    return [];
  }, dependencies: [$result]);

  static final $testsOutputLabel =
      Provider.autoDispose.family<AsyncValue<String>, int>((ref, testID) {
    return _merge((unwrap) {
      final test = unwrap(ref.watch($test(testID)));

      final status = ref.watch($testStatus(testID));

      var result = '';

      if (test.url != null) {
        // Tests with a null URL are non-user-defined tests (such as setup/teardown).
        // They can fail, but we don't want to show their name.
        result = status.when(
          data: (data) => '  ${'✓'.green} ${test.name}',
          error: (err, stack) => '  ${'✕'.red} ${test.name}',
          loading: () => '  ${ref.watch($spinner)} ${test.name}',
        );
      }

      final messages = ref.watch($testMessages(testID));
      if (messages.isNotEmpty) {
        if (result.isNotEmpty) result += '\n';
        result += messages.join('\n');
      }

      return status.maybeWhen(
        error: (err, stack) {
          final error = err is FailedTestException ? err.testError.error : err;

          final stackTrace = err is FailedTestException
              ? err.testError.stackTrace
              : stack.toString();

          return '''
$result${messages.isNotEmpty ? '\n' : ''}
${error.toString().multilinePadLeft(4)}
${stackTrace.trim().multilinePadLeft(4)}''';
        },
        orElse: () => result,
      );
    });
  }, dependencies: [$test, $testStatus, $spinner]);

  static final $suiteTestsOutputLabels =
      Provider.autoDispose.family<AsyncValue<String>, int>((ref, suiteID) {
    return _merge((unwrap) {
      final tests = unwrap(ref.watch($testsForSuite(suiteID)));

      final loadingTestLabels = tests.keys
          .where((id) => ref.watch($testStatus(id)) is AsyncLoading)
          .map((id) => ref.watch($testsOutputLabel(id)).asData?.value)
          .where((label) => label != null)
          .join('\n');
      final failingTestLabels = tests.keys
          .where((id) => ref.watch($testStatus(id)) is AsyncError)
          .map((id) => ref.watch($testsOutputLabel(id)).asData?.value)
          .where((label) => label != null)
          .join('\n');
      final successTestLabels = tests.keys
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
  }, dependencies: [$testsForSuite, $testStatus, $testsOutputLabel]);

  static final $suiteOutput =
      Provider.autoDispose.family<AsyncValue<String>, int>((ref, suiteID) {
    return _merge((unwrap) {
      final suiteStatus = ref.watch($suiteStatus(suiteID));
      final showTests = suiteStatus.map(
        data: (_) => false,
        error: (_) => true,
        loading: (_) => true,
      );

      final testLabels = showTests
          ? unwrap(ref.watch($suiteTestsOutputLabels(suiteID)))
          : null;

      return [
        unwrap(ref.watch($suiteOutputLabel(suiteID))),
        if (testLabels != null && testLabels.isNotEmpty) testLabels,
      ].join('\n');
    });
  }, dependencies: [$suiteStatus, $suiteOutputLabel, $suiteTestsOutputLabels]);

  static final $output = Provider.autoDispose<AsyncValue<String>>((ref) {
    return _merge((unwrap) {
      final suites = unwrap(ref.watch($suites))
          .sorted((a, b) => a.path!.compareTo(b.path!));

      final passingSuites = suites
          .where((suite) => ref.watch($suiteStatus(suite.id)) is AsyncData)
          .map((suite) => unwrap(ref.watch($suiteOutput(suite.id))))
          .join('\n');
      final failingSuites = suites
          .where((suite) => ref.watch($suiteStatus(suite.id)) is AsyncError)
          .map((suite) => unwrap(ref.watch($suiteOutput(suite.id))))
          .join('\n');
      final loadingSuites = suites
          .where((suite) => ref.watch($suiteStatus(suite.id)) is AsyncLoading)
          .map((suite) => unwrap(ref.watch($suiteOutput(suite.id))))
          .join('\n');

      return [
        if (passingSuites.isNotEmpty) passingSuites,
        if (loadingSuites.isNotEmpty) loadingSuites,
        if (failingSuites.isNotEmpty) failingSuites,
      ].join('\n\n');
    });
  }, dependencies: [
    $suites,
    $suiteOutput,
    $suiteStatus,
  ]);
}

@immutable
class _GroupID {
  const _GroupID({
    required this.groupID,
    required this.suiteID,
  });

  final int groupID;
  final int suiteID;

  @override
  bool operator ==(Object other) =>
      other is _GroupID &&
      other.runtimeType == runtimeType &&
      other.groupID == groupID &&
      other.suiteID == suiteID;

  @override
  int get hashCode => Object.hash(runtimeType, groupID, suiteID);
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
  /// Emits the combination of all the previously emitted events and the new event.
  ///
  /// Meaning that by pushing `A` then `B` then `C`, this will emit in order:
  /// - `[A]`
  /// - `[A, B]`
  /// - `[A, B, C]`
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

Future<int> fest({
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

    final renderer = rendererOverride ??
        (watch ? FullScreenRenderer() : BacktrackingRenderer());

    ref.listen<AsyncValue<String>>(
      TestStatus.$output,
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
        TestStatus.$result,
        (previous, current) {},
      );
      Future(sub.read().done).then((doneEvent) {
        // TODO test `success = null`
        final exitCode = doneEvent.success != false ? 0 : -1;

        completer.complete(exitCode);
      });
    }

    final exitCode = await completer.future;
    return exitCode;
  }, overrides: [
    if (workingDirectory != null)
      _$workingDirectory.overrideWithValue(Directory(workingDirectory)),
  ]);
}

extension on Test {
  // when "url" is null, it means that this is not a user-defined test
  // and is instead a setup/tearOff/.., so it doesn't count
  bool get isHidden => url == null;
}
