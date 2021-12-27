import 'dart:async';
import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spec_cli/src/command_runner.dart';
import 'package:riverpod/riverpod.dart';
import 'package:spec_cli/src/container.dart';
import 'package:spec_cli/src/renderer.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

ProviderContainer createContainer({
  List<Override> overrides = const [],
}) {
  final container = ProviderContainer(
    overrides: overrides,
  );
  addTearDown(container.dispose);

  return container;
}

final _defaultOverridesKey = Object();

@isTestGroup
void groupScope(
  String description,
  FutureOr<void> Function() cb, {
  List<Override>? overrides,
}) {
  group(description, () {
    return runZoned(
      cb,
      zoneValues: {
        if (overrides != null) _defaultOverridesKey: overrides,
      },
    );
  });
}

@isTest
void testScope(
  String description,
  FutureOr<void> Function(DartRef ref) cb, {
  List<Override> overrides = const [],
  Timeout? timeout,
  Object? skip,
  int? retry,
  Map<String, Object?>? onPlatform,
  @Deprecated('solo should only be used during developemnt') bool solo = false,
  Object? tags,
  String? testOn,
}) {
  final defaultOverrides = Zone.current[_defaultOverridesKey];
  return test(
    description,
    () {
      return runScoped(cb, overrides: [
        ...?defaultOverrides,
        ...overrides,
      ]);
    },
    timeout: timeout,
    skip: skip,
    retry: retry,
    onPlatform: onPlatform,
    // ignore: deprecated_member_use
    solo: solo,
    tags: tags,
    testOn: testOn,
  );
}

class TestRenderer extends Renderer {
  final List<String> frames = [];

  @override
  void renderFrame(String output) {
    final outputWithoutAnsi = output.replaceAll(ansiRegex, '');

    frames.add(outputWithoutAnsi + '\n');
  }
}

/// Compares a list of frames against a pattern
///
/// The pattern is the concatenation of some individual frames, in order
/// of expected rendering.
///
/// Frames can be defined in a multiline string, separated by `---\n`, such as:
/// ```dart
/// framesMatch('''
/// firstFrame
/// ---
/// secondFrame
/// ---
/// thirdFrame
/// ''');
/// ```
///
/// Alternatively, [framesMatch] can be used with a list of matcher:
///
/// ```dart
/// framesMatch([
///   anyOf('firstFrame', 'first-name'),
///   '''
/// second frame
/// ---
/// third frame
/// ''', // litterals works too
/// ])
/// ```
///
/// Frames can be skipped. But no extra frame can be added.
/// Meaning the matcher:
///
/// ```dart
/// framesMatch('''
/// A
/// ---
/// B
/// ---
/// C
/// ''');
/// ```
///
/// will accept "A then B then C", "A then C" and "B then C". But it will reject:
/// - "A then C then B", becauses frames are not in the correct order
/// - "A then G", because even if B/C were skipped, G is not a known frame
/// - "A then B then C then C", because this defines 4 frames instead of 3
Matcher framesMatch(Object expectation) {
  assert(expectation is String || expectation is List);

  List<Matcher> splitStringFrame(String frame) {
    return frame
        .split(RegExp(r'^---\n', multiLine: true))
        .map(wrapMatcher)
        .toList();
  }

  final expectedFrames = expectation is String
      ? splitStringFrame(expectation)
      : (expectation as List<Object?>).expand((matcher) {
          return matcher is String
              ? splitStringFrame(matcher)
              : [matcher as Matcher];
        }).toList();

  return _FramesMatch(expectedFrames);
}

class _FramesMatch extends Matcher {
  _FramesMatch(this.frameMatchers);

  static final _extraExpectedFrameKey = Object();
  static final _expectedFrameStartAtKey = Object();
  static final _unknownFrameKey = Object();
  static final _unknownFrameIndexKey = Object();

  final List<Matcher> frameMatchers;

  @override
  bool matches(
    covariant List<String> frames,
    Map<Object?, Object?> matchState,
  ) {
    var expectedFrameIndex = 0;
    int? lastMatchIndex;
    for (var actualFrameIndex = 0; actualFrameIndex < frames.length;) {
      final actualFrame = frames[actualFrameIndex];

      /// Ran out of matcher to test the frame against.
      /// Either more frames were rendered than expected, or a frame
      /// had no matching matcher.
      if (expectedFrameIndex >= frameMatchers.length) {
        matchState[_unknownFrameKey] = actualFrame;
        matchState[_unknownFrameIndexKey] = actualFrameIndex;
        matchState[_expectedFrameStartAtKey] =
            lastMatchIndex == null ? 0 : lastMatchIndex + 1;
        return false;
      }

      final expectedFrame = frameMatchers[expectedFrameIndex];

      // current frame matches current frame-matcher, testing next frame
      if (expectedFrame.matches(actualFrame, matchState)) {
        lastMatchIndex = expectedFrameIndex;
        // TODO allow an expectation to match multiple frames
        expectedFrameIndex++;
        actualFrameIndex++;
        continue;
      }

      // current frame does not match current matcher. It's possible
      // that an expected frame was skipped, so testing same frame against
      // the next matcher.
      expectedFrameIndex++;
    }

    /// All the frames were matched, yet some frame matchers are remaining
    if (expectedFrameIndex < frameMatchers.length) {
      matchState[_extraExpectedFrameKey] = frameMatchers[expectedFrameIndex];
      matchState[_expectedFrameStartAtKey] = expectedFrameIndex;
      return false;
    }

    return true;
  }

  @override
  Description describe(Description description) {
    return description.addAll(
      'frames (${frameMatchers.length})\n  ',
      '\n  ---\n  ',
      '\n  in order',
      frameMatchers,
    );
  }

  @override
  Description describeMismatch(
    Object? item,
    Description mismatchDescription,
    Map<Object?, Object?> matchState,
    bool verbose,
  ) {
    if (matchState.containsKey(_unknownFrameKey)) {
      final unknownFrame = matchState[_unknownFrameKey];
      final unknownFrameIndex = matchState[_unknownFrameIndexKey] ?? 0;
      final lastMatchIndex = matchState[_expectedFrameStartAtKey] ?? 0;

      return mismatchDescription
          .add('received frame\n  ')
          .addDescriptionOf(unknownFrame)
          .add('\nat index #$unknownFrameIndex')
          .add(
              '\nbut does not match any expected frame starting the frame #$lastMatchIndex');
    }

    if (matchState.containsKey(_extraExpectedFrameKey)) {
      final failedFrame = matchState[_extraExpectedFrameKey];
      final failedFrameStartAt = matchState[_expectedFrameStartAtKey] ?? 0;

      return mismatchDescription
          .add('expected to find matching frame for\n  ')
          .addDescriptionOf(failedFrame)
          .add('\nat or after the frame at index #$failedFrameStartAt')
          .add('\nbut none were found.');
    }
    return mismatchDescription;
  }
}

// Cloned from https://github.com/chalk/ansi-regex/blob/main/index.js
final ansiRegex = RegExp(
  [
    '[\\u001B\\u009B][[\\]()#;?]*(?:(?:(?:(?:;[-a-zA-Z\\d\\/#&.:=?%@~_]+)*|[a-zA-Z\\d]+(?:;[-a-zA-Z\\d\\/#&.:=?%@~_]*)*)?\\u0007)',
    '(?:(?:\\d{1,4}(?:;\\d{0,4})*)?[\\dA-PR-TZcf-nq-uy=><~]))'
  ].join('|'),
);

/// Returns a matcher which matches if the match argument is a string and
/// is equal to [value] after removing ansi codes
Matcher equalsIgnoringAnsi(String value) => _IsEqualIgnoringAnsi(value);

class _IsEqualIgnoringAnsi extends Matcher {
  _IsEqualIgnoringAnsi(this._value);

  static final Object _mismatchedValueKey = Object();

  static String _removeAnsi(String s) => s.replaceAll(ansiRegex, '');

  final String _value;

  @override
  bool matches(Object? object, Map<Object?, Object?> matchState) {
    final description = _removeAnsi(object! as String);
    if (_value != description) {
      matchState[_mismatchedValueKey] = description;
      return false;
    }
    return true;
  }

  @override
  Description describe(Description description) {
    return description.addDescriptionOf(_value).add(' ignoring ansi codes');
  }

  @override
  Description describeMismatch(
    Object? item,
    Description mismatchDescription,
    Map<Object?, Object?> matchState,
    bool verbose,
  ) {
    if (matchState.containsKey(_mismatchedValueKey)) {
      final actualValue = matchState[_mismatchedValueKey]! as String;
      // Leading whitespace is added so that lines in the multiline
      // description returned by addDescriptionOf are all indented equally
      // which makes the output easier to read for this case.
      return mismatchDescription
          .add('expected normalized value\n  ')
          .addDescriptionOf(_value)
          .add('\nbut got\n  ')
          .addDescriptionOf(actualValue);
    }
    return mismatchDescription;
  }
}

Future<Directory> createProject(List<PackageInfo> packages) async {
  final workingDir = Directory(
    Directory.systemTemp
        .createTempSync('dart_test_')
        .resolveSymbolicLinksSync(),
  );

  addTearDown(() async {
    for (var i = 0; i < 5; i++) {
      try {
        // Sometimes the deletion fails to complete (likely because .dart_tool
        // takes too long to delete).
        // So we use a retry mechanism.
        await workingDir.delete(recursive: true);
        break;
      } on FileSystemException {}
    }

    // After all the retries, check that the folder was properly deleted.
    if (workingDir.existsSync()) {
      throw StateError('failed to delete $workingDir');
    }
  });

  await Future.wait<void>(
    packages.map((package) async {
      final packagePath = '${workingDir.path}/packages/${package.name}';

      await Future.wait(
        package.files.entries.map((entry) async {
          final file =
              await File('${packagePath}/${entry.key}').create(recursive: true);

          await file.writeAsString(entry.value);
        }),
      );

      await Process.run(
        'dart',
        [
          'pub',
          'get',
          // Some flags to speed up the bootstrap
          '--offline',
          '--no-precompile',
        ],
        workingDirectory: packagePath,
      );
    }),
  );

  return workingDir;
}

TestRenderer? testRenderer;

/// Runs a single test
///
/// For more advanced use-cases, use [createProject].
Future<int> runTest(Map<String, String> tests) async {
  if (testRenderer == null) {
    testRenderer = rendererOverride = TestRenderer();
    addTearDown(() => testRenderer = rendererOverride = null);
  }

  final dir = await createProject([
    PackageInfo(
      name: 'a',
      files: {
        for (final entry in tests.entries) 'test/' + entry.key: entry.value,
      },
    ),
  ]);

  return fest(
    workingDirectory: dir.path + '/packages/a',
  );
}

class PackageInfo {
  PackageInfo({
    this.name = 'tmp_package',
    this.isFlutterPackage = false,
    required Map<String, String> files,
  }) : files = {
          ...files,
          if (!files.containsKey('pubspec.yaml'))
            'pubspec.yaml': '''
name: $name
environment:
  sdk: ">=2.13.0 <3.0.0"


${isFlutterPackage ? 'dependencies: flutter: sdk' : ''}

dev_dependencies:
  test:
''',
        };

  final String name;
  final bool isFlutterPackage;
  final Map<String, String> files;
}
