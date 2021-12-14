import 'dart:async';
import 'dart:io';

import 'package:cli_util/cli_logging.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spec_cli/src/command_runner.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;
import 'package:riverpod/riverpod.dart';
import 'package:spec_cli/src/container.dart';
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

@isTest
void testScope(
  String description,
  FutureOr<void> Function(DartRef ref) cb, {
  List<Override> overrides = const [],
}) {
  return test(
    description,
    () => runScoped(cb, overrides: overrides),
    timeout: Timeout.factor(10),
  );
}

class TestLogger extends StandardLogger {
  final _buffer = StringBuffer();

  /// All the logs in order that were emitted so far.
  ///
  /// This includes both [stdout], [stderr] and [trace].
  /// Logs from [trace] and [stderr] are respectively prefixed by `t-` and `e-`
  /// such that:
  ///
  /// ```dart
  /// logger.stdout('Hello');
  /// logger.stderr('Error');
  /// logger.stdout('world');
  /// ```
  ///
  /// has the following output:
  ///
  /// ```
  /// Hello
  /// e-Error
  /// world
  /// ```
  ///
  /// This both ensures that tests to not forget to check errors and
  /// allows testing what the logs would actually look like.
  String get output => _buffer.toString();

  /// All logs in order, split by ANSI screen reset codes such as "clear screen"
  /// or "clear after cursor".
  /// Then, ANSI codes are removed, and finally the output is trimmed.
  List<String> get outputByScreenResetsWithoutAnsi {
    return output
        .split(
          RegExp(r'(?:\x1B\[2J|\x1B\[J)'),
        )
        .map((e) => e.replaceAll(ansiRegex, '').trim())
        .where((element) => element.isNotEmpty)
        .map((e) => '$e\n')
        .toList();
  }

  @override
  void stderr(String message) {
    _buffer.writeln(
      message.replaceAll(RegExp('^', multiLine: true), 'e-'),
    );
  }

  @override
  void stdout(String message) {
    _buffer.writeln(message);
  }

  @override
  void trace(String message) {
    _buffer.writeln(
      message.replaceAll(RegExp('^', multiLine: true), 't-'),
    );
  }

  @override
  void write(String message) {
    _buffer.write(message);
  }

  @override
  void writeCharCode(int charCode) {
    throw UnimplementedError();
  }

  void clear() => _buffer.clear();
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
  final workingDir = Directory(d.sandbox);

  await Future.wait<void>(
    packages.map((package) async {
      final packagePath = '${d.sandbox}/packages/${package.name}';

      await Future.wait(
        package.files.entries.map((entry) async {
          final file =
              await File('${packagePath}/${entry.key}').create(recursive: true);

          addTearDown(file.delete);

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

/// Runs a single test
///
/// For more advanced use-cases, use [createProject].
Future<void> runTest(String test) async {
  final dir = await createProject([
    PackageInfo(
      name: 'a',
      files: {'test/my_test.dart': test},
    ),
  ]);

  await fest(
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
