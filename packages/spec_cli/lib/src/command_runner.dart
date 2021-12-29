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

  static final $suite =
      FutureProvider.family<Suite, _SuiteKey>((ref, suiteKey) async {
    final suiteEvent = await ref
        .watch($result)
        .suites()
        .firstWhere((e) => e.suite.key == suiteKey);

    return suiteEvent.suite;
  }, dependencies: [$result]);

  static final $suiteStatus =
      Provider.family<AsyncValue<void>, _SuiteKey>((ref, suiteKey) {
    return _merge((unwrap) {
      final tests = unwrap(ref.watch($testsForSuite(suiteKey)));
      final visibleTests =
          tests.values.where((test) => !test.isHidden).toList();

      /// We verify that "testIds" contains all ids that this suite is supposed
      /// to have. In case we have yet to receive some test events.
      final hasAllVisibleIds = ref.watch(
        $scaffoldGroup(suiteKey).select(
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
      final hasLoading = tests.keys
          .any((testKey) => ref.watch($testStatus(testKey)) is AsyncLoading);
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

  static final $group =
      FutureProvider.family<Group, _GroupKey>((ref, groupKey) async {
    final groupEvent = await ref
        .watch($result) //
        .groups()
        .firstWhere((e) => e.group.key == groupKey);

    return groupEvent.group;
  }, dependencies: [$result]);

  static final $groupName = Provider.autoDispose
      .family<AsyncValue<String>, _GroupKey>((ref, groupKey) {
    return _merge((unwrap) {
      final group = unwrap(ref.watch($group(groupKey)));
      final parentGroup = group.parentKey == null
          ? null
          : unwrap(ref.watch($group(group.parentKey!)));

      if (parentGroup == null || parentGroup.parentID == null) {
        return group.name;
      }

      // group names are the concatenation of their name plus their parent's name
      // and a whitespace. So to determine the true group name, we're removing those
      return group.name.substring(parentGroup.name.length + 1);
    });
  }, dependencies: [$group]);

  /// The virtual top-most group added by the test package.
  static final $scaffoldGroup =
      FutureProvider.family<Group, _SuiteKey>((ref, suiteKey) {
    return ref
        .watch($result)
        .groups()
        .firstWhere(
            (e) => e.group.parentID == null && e.group.suiteKey == suiteKey)
        .then((e) => e.group);
  }, dependencies: [$result]);

  /// User-defined groups at the root of a suite (excluding [$scaffoldGroup])
  static final $rootGroupsForSuite =
      Provider.family<List<Group>, _SuiteKey>((ref, suiteKey) {
    ref.watch($scaffoldGroup(suiteKey).future).then((scaffoldGroup) {
      final rootGroups = ref
          .watch($result)
          .groups()
          .where((e) => e.group.parentKey == scaffoldGroup.key)
          .map((e) => e.group)
          .combined();

      final sub = rootGroups.listen((rootGroups) => ref.state = rootGroups);
      ref.onDispose(sub.cancel);
    });

    return [];
  }, dependencies: [$scaffoldGroup, $result]);

  static final $childrenGroupsForGroup =
      Provider.family<List<Group>, _GroupKey>((ref, groupKey) {
    final children = ref
        .watch($result)
        .groups()
        .where((e) => e.group.parentKey == groupKey)
        .map((e) => e.group)
        .combined();

    final sub = children.listen((children) => ref.state = children);
    ref.onDispose(sub.cancel);

    return [];
  }, dependencies: [$result]);

  /** Tests */

  static final $rootTestsForSuite =
      Provider.autoDispose.family<List<Test>, _SuiteKey>((ref, suiteKey) {
    final testsForSuite =
        ref.watch($testsForSuite(suiteKey)).when<Map<_TestKey, Test>>(
              data: (res) => res,
              error: (err, stack) => {},
              loading: () => {},
            );

    return testsForSuite.values
        // Tests with no groups are errored tests such as when there is a compilation error.
        // Tests with a single group are user-defined tests, since that group is added implicitly
        .where((test) => test.groupIDs.length < 2)
        .toList();
  }, dependencies: [$testsForSuite]);

  static final $testName =
      Provider.autoDispose.family<AsyncValue<String>, _TestKey>((ref, testKey) {
    return _merge((unwrap) {
      final test = unwrap(ref.watch($test(testKey)));
      final parentGroup = test.groupKey != null
          ? unwrap(ref.watch($group(test.groupKey!)))
          : null;

      // Tests without groups or tests where their group is the [$scaffoldGroup]
      // have their correct name
      if (parentGroup == null || parentGroup.parentID == null) {
        return test.name;
      }

      // test names are the concatenation of their name plus their parent's name
      // and a whitespace. So to determine the true group name, we're removing those
      return test.name.substring(parentGroup.name.length + 1);
    });
  }, dependencies: [$test]);

  static final $testsForGroup = Provider.autoDispose
      .family<AsyncValue<List<Test>>, _GroupKey>((ref, groupKey) {
    return _merge((unwrap) {
      final group = unwrap(ref.watch($group(groupKey)));
      final testsForSuite = unwrap(ref.watch($testsForSuite(group.suiteKey)));

      return testsForSuite.values
          .where((test) => test.groupKey == groupKey)
          .toList();
    });
  }, dependencies: [$testsForSuite]);

  static final $testsForSuite =
      StreamProvider.family<Map<_TestKey, Test>, _SuiteKey>((ref, suiteKey) {
    final controller = StreamController<Map<_TestKey, Test>>();
    controller.onListen = () => controller.add({});
    ref.onDispose(controller.close);

    final tests = <_TestKey, Test>{};

    ref
        .watch($result)
        .testStart()
        .where((event) => event.test.suiteKey == suiteKey)
        .where((event) => !event.test.isHidden)
        .listen((event) {
      if (!tests.containsKey(event.test.key)) {
        tests[event.test.key] = event.test;
        controller.add({...tests});
      }
    });

    return controller.stream;
  }, dependencies: [$result]);

  static final $test =
      StreamProvider.family<Test, _TestKey>((ref, testKey) async* {
    await for (final testStart in ref.watch($result).testStart()) {
      if (testStart.test.key == testKey) {
        yield testStart.test;
      }
    }
  }, dependencies: [$result]);

  static final $allTests = StreamProvider<List<Test>>((ref) {
    return ref.watch($result).testStart().map((event) => event.test).combined();
  }, dependencies: [$result]);

  static final $allFailedTests = Provider<AsyncValue<List<Test>>>((ref) {
    return _merge((unwrap) {
      return unwrap(ref.watch($allTests))
          .where((test) => ref.watch($testStatus(test.key)) is AsyncError)
          .toList();
    });
  }, dependencies: [$allTests, $testStatus]);

  static final $testStatus =
      FutureProvider.family<void, _TestKey>((ref, testKey) async {
    // No need to wait for test start event

    // will either throw or complete, allowing test status handling through "when(loading, error, data)   "

    await Future.any([
      ref //
          .watch($result)
          .testDone()
          .firstWhere(
            // TODO can we have the groupID/suiteID too?
            (e) =>
                e.testID == testKey.testID &&
                e.result == TestDoneStatus.success,
          ),
      ref
          .watch($result)
          .testError()
          // TODO can we have the groupID/suiteID too?
          .firstWhere((e) => e.testID == testKey.testID)
          .then((e) => throw FailedTestException(e)),
    ]);
  }, dependencies: [$result]);

  static final $currentlyFailedTestsLocation =
      Provider<AsyncValue<List<_FailedTestLocation>>>((ref) {
    return _merge((unwrap) {
      final failedTests = unwrap(ref.watch($allFailedTests));

      return failedTests.map((test) {
        final suite = unwrap(
          ref.watch($suite(test.suiteKey)),
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
      Provider.family<AsyncValue<String>, _SuiteKey>((ref, suiteKey) {
    return _merge((unwrap) {
      final suite = unwrap(ref.watch($suite(suiteKey)));
      final suiteStatus = ref.watch($suiteStatus(suiteKey));

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

    return '○';
  });

  static final $testMessages =
      Provider.autoDispose.family<List<String>, _TestKey>((ref, testKey) {
    final result = ref.watch($result);

    final messages = result
        .messages()
        // TODO can we have the groupID/suiteID too?
        .where((e) => e.testID == testKey.testID)
        .map((e) => e.message);

    final sub = messages.listen(
      (message) => ref.state = [...ref.state, message],
    );
    ref.onDispose(sub.cancel);

    return [];
  }, dependencies: [$result]);

  static final $testLabel =
      Provider.autoDispose.family<String?, _TestKey>((ref, testKey) {
    return _merge<String?>((unwrap) {
      final test = unwrap(ref.watch($test(testKey)));
      final name = unwrap(ref.watch($testName(testKey)));
      final status = ref.watch($testStatus(testKey));

      if (test.url != null) {
        // Tests with a null URL are non-user-defined tests (such as setup/teardown).
        // They can fail, but we don't want to show their name.
        return status.when(
          data: (data) => '  ${'✓'.green} ${name}',
          error: (err, stack) => '  ${'✕'.red} ${name}',
          loading: () => '  ${ref.watch($spinner)} ${name}',
        );
      }

      return null;
    }).whenOrNull<String?>(data: (data) => data);
  }, dependencies: [$test, $testStatus, $spinner, $testName]);

  static final $testError =
      Provider.autoDispose.family<String?, _TestKey>((ref, testKey) {
    final status = ref.watch($testStatus(testKey));

    return status.whenOrNull<String?>(
      error: (err, stack) {
        final error = err is FailedTestException ? err.testError.error : err;

        final stackTrace = err is FailedTestException
            ? err.testError.stackTrace
            : stack.toString();

        return '''
${error.toString().multilinePadLeft(4)}
${stackTrace.trim().multilinePadLeft(4)}''';
      },
    );
  }, dependencies: [$test, $testStatus, $spinner, $testName]);

  static final AutoDisposeProviderFamily<AsyncValue<String>, _GroupKey>
      $groupOutput = Provider.autoDispose.family<AsyncValue<String>, _GroupKey>(
          (ref, groupKey) {
    return _merge((unwrap) {
      final label = unwrap(ref.watch($groupName(groupKey)));
      final tests = unwrap(ref.watch($testsForGroup(groupKey)));
      final childrenGroups = ref.watch($childrenGroupsForGroup(groupKey));

      final testContent = tests
          .sortedByStatus(ref)
          .map((test) => ref.watch($testLabel(test.key)))
          .whereNotNull()
          .join('\n');

      final childrenGroupsContent = childrenGroups
          .map((group) => ref.watch($groupOutput(group.key)).asData?.value)
          .whereNotNull()
          .join('\n');

      return [
        label,
        if (testContent.isNotEmpty) testContent,
        if (childrenGroupsContent.isNotEmpty) childrenGroupsContent,
      ].join('\n');
    });
  }, dependencies: [$groupName]);

  static final $suiteOutput = Provider.autoDispose
      .family<AsyncValue<String>, _SuiteKey>((ref, suiteKey) {
    return _merge((unwrap) {
      final suiteStatus = ref.watch($suiteStatus(suiteKey));
      final showContent = suiteStatus.map(
        data: (_) => false,
        error: (_) => true,
        loading: (_) => true,
      );

      final rootTestsOutput = showContent
          ? ref
              .watch($rootTestsForSuite(suiteKey))
              .sortedByStatus(ref)
              .expand((test) {
                final messages = ref.watch($testMessages(test.key));
                final error = ref.watch($testError(test.key));
                return [
                  ref.watch($testLabel(test.key)),
                  ...messages,
                  if (messages.isNotEmpty && error != null)
                    '\n$error'
                  else
                    error,
                ];
              })
              .whereNotNull()
              .join('\n')
          : null;

      final rootGroupsOutput = showContent
          ? ref
              .watch($rootGroupsForSuite(suiteKey))
              .map((group) => ref.watch($groupOutput(group.key)).asData?.value)
              .whereNotNull()
              .join('\n')
          : null;

      final res = [
        unwrap(ref.watch($suiteOutputLabel(suiteKey))),
        if (rootTestsOutput != null && rootTestsOutput.isNotEmpty)
          rootTestsOutput,
        if (rootGroupsOutput != null && rootGroupsOutput.isNotEmpty)
          rootGroupsOutput,
      ].join('\n');
      return res;
    });
  }, dependencies: [
    $suiteStatus,
    $testStatus,
    $rootGroupsForSuite,
    $groupOutput,
    $testLabel,
    $suiteOutputLabel,
    $rootTestsForSuite,
  ]);

  static final $output = Provider.autoDispose<AsyncValue<String>>((ref) {
    return _merge((unwrap) {
      final suites = unwrap(ref.watch($suites))
          .sorted((a, b) => a.path!.compareTo(b.path!));

      final passingSuites = suites
          .where((suite) => ref.watch($suiteStatus(suite.key)) is AsyncData)
          .map((suite) => unwrap(ref.watch($suiteOutput(suite.key))))
          .join('\n');
      final failingSuites = suites
          .where((suite) => ref.watch($suiteStatus(suite.key)) is AsyncError)
          .map((suite) => unwrap(ref.watch($suiteOutput(suite.key))))
          .join('\n');
      final loadingSuites = suites
          .where((suite) => ref.watch($suiteStatus(suite.key)) is AsyncLoading)
          .map((suite) => unwrap(ref.watch($suiteOutput(suite.key))))
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
    print('got exit code $exitCode');
    await Future.delayed(Duration(seconds: 2));
    print('done');
    return exitCode;
  }, overrides: [
    if (workingDirectory != null)
      _$workingDirectory.overrideWithValue(Directory(workingDirectory)),
  ]);
}

@immutable
class _TestKey {
  _TestKey({
    required this.testID,
    required this.groupID,
    required this.suiteID,
  });

  final int testID;
  final int? groupID;
  final int suiteID;

  @override
  bool operator ==(Object other) =>
      other is _TestKey &&
      other.runtimeType == runtimeType &&
      other.testID == testID &&
      other.groupID == groupID &&
      other.suiteID == suiteID;

  @override
  int get hashCode => Object.hash(runtimeType, testID, suiteID, groupID);
}

@immutable
class _GroupKey {
  _GroupKey({
    required this.groupID,
    required this.suiteID,
  });

  final int groupID;
  final int suiteID;

  @override
  bool operator ==(Object other) =>
      other is _GroupKey &&
      other.runtimeType == runtimeType &&
      other.groupID == groupID &&
      other.suiteID == suiteID;

  @override
  int get hashCode => Object.hash(runtimeType, suiteID, groupID);
}

@immutable
class _SuiteKey {
  _SuiteKey({required this.suiteID});

  final int suiteID;

  @override
  bool operator ==(Object other) =>
      other is _SuiteKey &&
      other.runtimeType == runtimeType &&
      other.suiteID == suiteID;

  @override
  int get hashCode => Object.hash(runtimeType, suiteID);
}

extension on Test {
  // when "url" is null, it means that this is not a user-defined test
  // and is instead a setup/tearOff/.., so it doesn't count
  bool get isHidden => url == null;

  _TestKey get key => _TestKey(
        testID: id,
        groupID: groupIDs.isEmpty ? null : groupIDs.last,
        suiteID: suiteID,
      );

  _GroupKey? get groupKey => groupIDs.isEmpty
      ? null
      : _GroupKey(suiteID: suiteID, groupID: groupIDs.last);

  _SuiteKey get suiteKey => _SuiteKey(suiteID: suiteID);
}

extension on Group {
  _GroupKey get key => _GroupKey(
        groupID: id,
        suiteID: suiteID,
      );

  _GroupKey? get parentKey =>
      parentID == null ? null : _GroupKey(groupID: parentID!, suiteID: suiteID);

  _SuiteKey get suiteKey => _SuiteKey(suiteID: suiteID);
}

extension on Suite {
  _SuiteKey get key => _SuiteKey(
        suiteID: id,
      );
}

extension on List<Test> {
  List<Test> sortedByStatus(Ref ref) {
    return sortedBy<num>((test) {
      return ref.watch(TestStatus.$testStatus(test.key)).map(
            data: (_) => 0,
            loading: (_) => 1,
            error: (_) => 2,
          );
    });
  }
}
