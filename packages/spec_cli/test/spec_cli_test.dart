import 'dart:io';

import 'package:path/path.dart';
import 'package:spec_cli/src/command_runner.dart';
import 'package:spec_cli/src/renderer.dart';
import 'package:spec_cli/src/rendering.dart';
import 'package:test/test.dart';

import 'utils.dart';

void main() {
  groupScope(
    'Spec',
    () {
      // TODO on sigint/sigterm, report suites/tests that were not executed. Blocked by https://github.com/dart-lang/test/issues/1654

      testScope('supports generating coverage in Flutter projects',
          (ref) async {
        final testRenderer = rendererOverride = TestRenderer();
        addTearDown(() => rendererOverride = null);

        final workingDir = await createProject([
          PackageInfo(
            name: 'a',
            isFlutterPackage: true,
            files: {
              'test/my_test.dart': '''
import 'package:test/test.dart';
import 'package:a/foo.dart';
void main() {
  test('hello foo', () {
    expect(fn(), 0);
  });
}
''',
              'lib/foo.dart': '''
int fn() {
  return 0;
}
''',
            },
          ),
        ]);

        final exitCode = await spec(
          workingDirectory: workingDir.path,
          options: SpecOptions.fromArgs(const ['--coverage', '--no-ci']),
        );

        expect(
          testRenderer.frames.last,
          '''
 PASS  packages/a/test/my_test.dart

Test Suites: 1 passed, 1 total
Tests:       1 passed, 1 total
Time:        00:00:00
''',
        );
        expect(exitCode, 0);

        final lcovFile = File(
            join(workingDir.path, 'packages', 'a', 'coverage', 'lcov.info'));

        expect(
          lcovFile.existsSync(),
          true,
        );
      });

      testScope('supports generating coverage in Dart projects', (ref) async {
        final testRenderer = rendererOverride = TestRenderer();
        addTearDown(() => rendererOverride = null);

        final workingDir = await createProject([
          PackageInfo(
            name: 'a',
            files: {
              'test/my_test.dart': '''
import 'package:test/test.dart';
import 'package:a/foo.dart';
void main() {
  test('hello foo', () {
    expect(fn(), 0);
  });
}
''',
              'lib/foo.dart': '''
int fn() {
  return 0;
}
''',
            },
          ),
        ]);

        final exitCode = await spec(
          workingDirectory: workingDir.path,
          options: SpecOptions.fromArgs(const ['--coverage', '--no-ci']),
        );

        expect(
          testRenderer.frames.last,
          '''
 PASS  packages/a/test/my_test.dart

Test Suites: 1 passed, 1 total
Tests:       1 passed, 1 total
Time:        00:00:00
''',
        );
        expect(exitCode, 0);

        final lcovFile = File(
            join(workingDir.path, 'packages', 'a', 'coverage', 'lcov.info'));

        expect(
          lcovFile.existsSync(),
          true,
        );
      });

      testScope(
          'handles non-json logs from the test output (such as Flutter\'s "Downloading ...")',
          (ref) async {});
      testScope('pipe stderr of dart/flutter test', (ref) async {});

      testScope('applies path filter only to packages containing those paths',
          (ref) async {
        final testRenderer = rendererOverride = TestRenderer();
        addTearDown(() => rendererOverride = null);

        final workingDir = await createProject([
          PackageInfo(
            name: 'a',
            files: {
              'test/my_test.dart': '''
import 'package:test/test.dart';
void main() {
  test('hello foo', () {});
}
''',
            },
          ),
          PackageInfo(
            name: 'b',
            files: {
              'test/another_test.dart': '''
import 'package:test/test.dart';
void main() {
  test('hello bar', () {});
}
''',
            },
          ),
          PackageInfo(
            name: 'c',
            files: {
              'test/skipped_test.dart': '''
import 'package:test/test.dart';
void main() {
  test('hello baz', () => throw StateError('error'));
}
''',
            },
          ),
        ]);

        final exitCode = await spec(
          workingDirectory: join(workingDir.path, 'packages', 'a'),
          options: SpecOptions.fromArgs(const ['.', '../b/test', '--no-ci']),
        );

        final lastFrame = testRenderer.frames.last;
        expect(lastFrame, contains(' PASS  ../b/test/another_test.dart\n'));
        expect(lastFrame, contains(' PASS  test/my_test.dart\n'));
        expect(lastFrame, isNot(contains('PASS  ../c/test/skipped_test.dart')));
        expect(
          lastFrame,
          endsWith('''
Test Suites: 2 passed, 2 total
Tests:       2 passed, 2 total
Time:        00:00:00
'''),
        );
        expect(lastFrame.split('\n').length, 7);

        expect(exitCode, 0);
      });

      testScope('handles async group errors', (ref) async {
        final exitCode = await runTest({
          'my_test.dart': '''
import 'package:test/test.dart';

void main() {
  group('invalid', () async {
    test('never reached', () {});
  });
  test('valid', () {});
} 
'''
        });

        expect(
          testRenderer!.frames.last,
          '''

  ● loading test/my_test.dart test/my_test.dart
    Failed to load "test/my_test.dart": Invalid argument(s): Groups may not be async.
    package:test_api                           Declarer.group
    package:test_core/scaffolding.dart 219:13  group
    test/my_test.dart 4:3                      main

Test Suites: 0 total
Tests:       0 total
Time:        00:00:00
''',
        );

        expect(exitCode, 1);
      });

      testScope(
          'on sigint/sigterm, abort and show failures details', (ref) async {},
          skip: true);

      testScope(
        'on sigint/sigterm, pending tests/suites are shown as skipped/stopped',
        (ref) async {},
        skip: true,
      );

      testScope('does not collapse passing suites if there is only one suite',
          (ref) async {},
          skip: true);

      testScope('handles skipped tests with a reason', (ref) async {},
          skip: true);

      testScope('handle errors inside setup', (ref) async {}, skip: true);

      testScope('handle errors inside tearDown', (ref) async {}, skip: true);

      testScope('handle test failure after test done', (ref) async {},
          skip: true);

      testScope('handle test failure after test done', (ref) async {},
          skip: true);

      testScope(
        'on file path filter, if path not found, commands fails',
        (ref) async {},
        skip: true,
      );

      testScope('support flutter projects within melos workspaces',
          (ref) async {
        // DON'T add a "lib/main.dart"
      }, skip: true);

      testScope('handles setups/teardowns', (ref) async {
        final exitCode = await runTest({
          'my_test.dart': '''
import 'package:test/test.dart';
void main() {
  setUpAll(() => Future.delayed(Duration(milliseconds: 10)));
  tearDownAll(() => Future.delayed(Duration(milliseconds: 10)));

  setUp(() => Future.delayed(Duration(milliseconds: 10)));
  tearDown(() => Future.delayed(Duration(milliseconds: 10)));

  test('hello world', () => Future.delayed(Duration(milliseconds: 10)));
  group('foo', () {
    setUp(() => Future.delayed(Duration(milliseconds: 10)));
    tearDown(() => Future.delayed(Duration(milliseconds: 10)));

    test('hello world', () => Future.delayed(Duration(milliseconds: 10)));
  });
}
''',
          'another_test.dart': '''
import 'package:test/test.dart';
void main() {
  test('slow', () => Future.delayed(Duration(seconds: 1)));
}
''',
        });

        final lastFrame = testRenderer!.frames.last;
        expect(lastFrame, contains('PASS  test/my_test.dart'));
        expect(lastFrame, contains('PASS  test/another_test.dart'));
        expect(
          lastFrame,
          endsWith('''
Test Suites: 2 passed, 2 total
Tests:       3 passed, 3 total
Time:        00:00:00
'''),
        );
        expect(exitCode, 0);
      });

      testScope('can filter tests by name', (ref) async {
        final exitCode = await runTest(
          {
            'my_test.dart': '''
import 'package:test/test.dart';
void main() {
  test('hello world', () {});
  test('fail', () => throw StateError('fail'));
  test('hello baz', () {});
}
''',
          },
          options: SpecOptions.fromArgs(const ['--name=hello', '--no-ci']),
        );

        expect(testRenderer!.frames.last, '''
 PASS  test/my_test.dart

Test Suites: 1 passed, 1 total
Tests:       2 passed, 2 total
Time:        00:00:00
''');

        expect(exitCode, 0);
      });

      testScope('cross package file filter works', (ref) async {
        final testRenderer = rendererOverride = TestRenderer();
        addTearDown(() => rendererOverride = null);

        final workingDir = await createProject([
          PackageInfo(
            name: 'a',
            files: {
              'test/my_test.dart': '''
import 'package:test/test.dart';
void main() {
  test('hello world', () {});
}
''',
            },
          ),
          PackageInfo(
            name: 'b',
            files: {
              'test/another.dart': '''
import 'package:test/test.dart';
void main() {
  test('hello world', () {});
}
''',
            },
          ),
        ]);

        final exitCode = await spec(
          workingDirectory: workingDir.path,
          options: SpecOptions.fromArgs(
            ['${workingDir.path}/packages/a/test/my_test.dart', '--no-ci'],
          ),
        );

        expect(testRenderer.frames.last, '''
 PASS  packages/a/test/my_test.dart

Test Suites: 1 passed, 1 total
Tests:       1 passed, 1 total
Time:        00:00:00
''');

        expect(exitCode, 0);
      });

      testScope('supports empty suites due to test name filter', (ref) async {
        final exitCode = await runTest(
          {
            'my_test.dart': '''
import 'package:test/test.dart';
void main() {
  test('hello', () {});
}
''',
            'maybe_empty_test.dart': '''
import 'package:test/test.dart';
void main() {
  test('fail', () => throw StateError('fail'));
}
''',
          },
          options: SpecOptions.fromArgs(const ['--name=hello', '--no-ci']),
        );

        expect(testRenderer!.frames.last, '''
 PASS  test/my_test.dart

Test Suites: 1 passed, 1 total
Tests:       1 passed, 1 total
Time:        00:00:00
''');

        expect(exitCode, 0);
      });

      testScope('can filter suites by path', (ref) async {
        final exitCode = await runTest(
          {
            'my_test.dart': '''
import 'package:test/test.dart';
void main() {
  // force my_test to end after another_test to make the order reliable
  test('hello world', () => Future.delayed(Duration(milliseconds: 10)));
}
''',
            'another_test.dart': '''
import 'package:test/test.dart';
void main() {
  test('pass', () {});
}
''',
            'excuded_test.dart': '''
import 'package:test/test.dart';
void main() {
  test('fail', () => throw StateError('fail'));
}
''',
          },
          options: SpecOptions.fromArgs(
            const ['test/my_test.dart', 'test/another_test.dart', '--no-ci'],
          ),
        );

        final lastFrame = testRenderer!.frames.last;
        expect(lastFrame, contains('PASS  test/another_test.dart'));
        expect(lastFrame, contains('PASS  test/my_test.dart'));
        expect(
          lastFrame,
          endsWith('''
Test Suites: 2 passed, 2 total
Tests:       2 passed, 2 total
Time:        00:00:00
'''),
        );
        expect(exitCode, 0);
      });

      testScope('handles flutter packages', (ref) async {
        final exitCode = await runTest({
          'my_test.dart': '''
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('example', (tester) async {
    await tester.pumpWidget(
      Text('foo', textDirection: TextDirection.ltr),
    );

    expect(find.text('foo'), findsOneWidget);
  });
}
''',
        }, isFlutter: true);

        expect(testRenderer!.frames.last, '''
 PASS  test/my_test.dart

Test Suites: 1 passed, 1 total
Tests:       1 passed, 1 total
Time:        00:00:00
''');

        expect(exitCode, 0);
      });

      testScope('handles skipped groups', (ref) async {
        final exitCode = await runTest({
          'my_test.dart': '''
import 'package:test/test.dart';

void main() {
  group('skipped group', () {
    test('test', () {});
  }, skip: true);
  test('pass', () => Future.delayed(Duration(seconds: 1)));
}
''',
        });

        expect(
          testRenderer!.frames.last,
          '''
 RUNS  test/my_test.dart
  ... pass
  skipped group
    ○ test
---
 PASS  test/my_test.dart
---
 PASS  test/my_test.dart

Test Suites: 1 passed, 1 total
Tests:       1 passed, 1 skipped, 2 total
Time:        00:00:00
''',
        );

        expect(exitCode, 0);
      }, skip: 'need verbose mode');

      testScope('handles skipped tests', (ref) async {
        final exitCode = await runTest({
          'my_test.dart': '''
import 'package:test/test.dart';

void main() {
  test('skipped', () => throw StateError('??'), skip: true);
  test('pass', () => Future.delayed(Duration(seconds: 1)));
  test('fail', () => throw StateError('fail'));
}
''',
        });

        expect(
          testRenderer!.frames.last,
          '''
 FAIL  test/my_test.dart
  ✕ fail
    Bad state: fail
    test/my_test.dart 6:22  main.<fn>

  ● fail test/my_test.dart:6:3
    Bad state: fail
    test/my_test.dart 6:22  main.<fn>

Test Suites: 1 failed, 1 total
Tests:       1 failed, 1 passed, 1 skipped, 3 total
Time:        00:00:00
''',
        );

        expect(exitCode, 1);
      }, skip: 'need verbose mode');

      testScope('handles nested groups', (ref) async {
        final exitCode = await runTest({
          'my_test.dart': '''
import 'package:test/test.dart';

void main() {
  test('root-test', () {});

  group('root', () {
    group('mid', () {
      test('test', () => print('hello world'));
    });
    group('mid-2', () {
      test('test-2', () => throw StateError('fail'));
    });
    test('root-test', () {});
  });

  group('root2', () {
    group('mid2', () {
      test('test2', () {});
    });
    group('mid2-2', () {
      test('test2-2', () => throw StateError('fail'));
    });
    test('root-test2', () {});
  });

  test('root failing test', () => throw StateError('fail'));
}
''',
        });

        expect(
          testRenderer!.frames.last,
          '''
 FAIL  test/my_test.dart
  ✕ root failing test
    Bad state: fail
    test/my_test.dart 26:35  main.<fn>
  root
    mid-2
      ✕ test-2
        Bad state: fail
        test/my_test.dart 11:28  main.<fn>.<fn>.<fn>
  root2
    mid2-2
      ✕ test2-2
        Bad state: fail
        test/my_test.dart 21:29  main.<fn>.<fn>.<fn>

  ● root mid-2 test-2 test/my_test.dart:11:7
    Bad state: fail
    test/my_test.dart 11:28  main.<fn>.<fn>.<fn>

  ● root2 mid2-2 test2-2 test/my_test.dart:21:7
    Bad state: fail
    test/my_test.dart 21:29  main.<fn>.<fn>.<fn>

  ● root failing test test/my_test.dart:26:3
    Bad state: fail
    test/my_test.dart 26:35  main.<fn>

Test Suites: 1 failed, 1 total
Tests:       3 failed, 5 passed, 8 total
Time:        00:00:00
''',
        );

        expect(exitCode, 1);
      });

      testScope(
        'handles empty suites',
        (ref) async {
          final exitCode = await runTest({
            'my_test.dart': '''
import 'package:test/test.dart';

void main() {}
''',
          });

          expect(
            testRenderer!.frames,
            framesMatch(
              '''
 RUNS  test/my_test.dart
---
 PASS  test/my_test.dart
---
 PASS  test/my_test.dart

Test Suites: 1 passed, 1 total
Tests:       1 passed, 1 total
Time:        00:00:00
''',
            ),
          );

          expect(exitCode, 0);
        },
        skip:
            'blocked by https://github.com/dart-lang/test/issues/1652 because '
            'we cannot determine if a suite is completed without tests',
      );

      testScope(
        'handle empty groups',
        (ref) async {
          final exitCode = await runTest({
            'my_test.dart': '''
import 'package:test/test.dart';

void main() {
  group('empty', () {});
}
''',
          });

          expect(
            testRenderer!.frames,
            framesMatch(
              '''
 RUNS  test/my_test.dart
---
 PASS  test/my_test.dart
---
 PASS  test/my_test.dart

Test Suites: 1 passed, 1 total
Tests:       0 total
Time:        00:00:00
''',
            ),
          );

          expect(exitCode, 0);
        },
        skip:
            'blocked by https://github.com/dart-lang/test/issues/1652 because '
            'we cannot determine if a group is completed without tests',
      );

      testScope('handle suites that fail to compile', (ref) async {
        final exitCode = await runTest({'my_test.dart': 'invalid'});

        expect(
          testRenderer!.frames.last,
          startsWith('''

  ● loading test/my_test.dart test/my_test.dart
    Failed to load "test/my_test.dart":
    test/my_test.dart:1:1: Error: Variables must be declared using the keywords 'const', 'final', 'var' or a type name.
    Try adding the name of the type of the variable or the keyword 'var'.
    invalid
    ^^^^^^^
    test/my_test.dart:1:1: Error: Expected ';' after this.
    invalid
    ^^^^^^^
'''),
        );

        expect(exitCode, 1);
      });

      testScope('render error logs made during tests', (ref) async {
        final exitCode = await runTest({
          'my_test.dart': '''
import 'package:test/test.dart';
import 'dart:io';

void main() {
  test('first', () async {
    print('hello');
    stderr.write('this an error');
    await Future.delayed(Duration(milliseconds: 10));
  });
}
''',
        });

        expect(
          testRenderer!.frames.last,
          '''
 PASS  test/my_test.dart

Test Suites: 1 passed, 1 total
Tests:       1 passed, 1 total
Time:        00:00:00
''',
        );

        expect(exitCode, 0);
      });

      testScope('render logs made during tests', (ref) async {
        final exitCode = await runTest({
          'my_test.dart': r'''
import 'package:test/test.dart';
import 'dart:async';

void main() {
  final secondCompleter = Completer<void>();
  final thirdCompleter = Completer<void>();
  test('first', () {
    addTearDown(secondCompleter.complete);
    print('hello\nfirst');
    print('another');
    throw StateError('first');
  });
  test('second', () async {
    addTearDown(thirdCompleter.complete);
    print('hello\nsecond');
    await secondCompleter.future;
    await Future.delayed(Duration(milliseconds: 10));
  });
  test('third', () async {
    print('hello\nthird');
    await thirdCompleter.future;
    await Future.delayed(Duration(milliseconds: 10));
  });
}
''',
        });

        expect(
          testRenderer!.frames.last,
          '''
 FAIL  test/my_test.dart
  ✕ first
hello
first
another

    Bad state: first
    test/my_test.dart 11:5  main.<fn>

  ● first test/my_test.dart:7:3
hello
first
another

    Bad state: first
    test/my_test.dart 11:5  main.<fn>

Test Suites: 1 failed, 1 total
Tests:       1 failed, 2 passed, 3 total
Time:        00:00:00
''',
        );

        expect(exitCode, 1);
      });

      testScope('passing suites are showed first and collapsed', (ref) async {
        final exitCode = await runTest({
          'pending_test.dart': '''
import 'package:test/test.dart';
void main() {
  test('pending', () => Future.delayed(Duration(milliseconds: 100)));
}
''',
          'passing_test.dart': '''
import 'package:test/test.dart';
void main() {
  test('passing', () {});
}
''',
        });

        final lastFrame = testRenderer!.frames.last;
        expect(lastFrame, contains('PASS  test/passing_test.dart'));
        expect(lastFrame, contains('PASS  test/pending_test.dart'));
        expect(
          lastFrame,
          endsWith('''
Test Suites: 2 passed, 2 total
Tests:       2 passed, 2 total
Time:        00:00:00
'''),
        );
        expect(exitCode, 0);
      });

      testScope('shows progress as tests complete', (ref) async {
        final exitCode = await runTest({
          'my_test.dart': '''
import 'package:test/test.dart';
import 'dart:async';

void main() {
  final secondCompleter = Completer<void>();
  final thirdCompleter = Completer<void>();
  test('first', () {
    addTearDown(secondCompleter.complete);
  });
  test('second', () async {
    addTearDown(thirdCompleter.complete);
    await secondCompleter.future;
    await Future.delayed(Duration(milliseconds: 10));
  });
  test('third', () async {
    await thirdCompleter.future;
    await Future.delayed(Duration(milliseconds: 10));
  });
}
''',
        });

        expect(
          testRenderer!.frames.last,
          '''
 PASS  test/my_test.dart

Test Suites: 1 passed, 1 total
Tests:       3 passed, 3 total
Time:        00:00:00
''',
        );
        expect(exitCode, 0);
      });

      testScope('errors within a file are showed last', (ref) async {
        final exitCode = await runTest({
          'my_test.dart': '''
import 'package:test/test.dart';
import 'dart:async';

void main() {
  final secondCompleter = Completer<void>();
  final thirdCompleter = Completer<void>();
  test('first', () {
    addTearDown(secondCompleter.complete);
    throw StateError('first');
  });
  test('second', () async {
    addTearDown(thirdCompleter.complete);
    await secondCompleter.future;
    await Future.delayed(Duration(milliseconds: 10));
  });
  test('third', () async {
    await thirdCompleter.future;
    await Future.delayed(Duration(milliseconds: 10));
  });
}
''',
        });

        expect(
          testRenderer!.frames.last,
          '''
 FAIL  test/my_test.dart
  ✕ first
    Bad state: first
    test/my_test.dart 9:5  main.<fn>

  ● first test/my_test.dart:7:3
    Bad state: first
    test/my_test.dart 9:5  main.<fn>

Test Suites: 1 failed, 1 total
Tests:       1 failed, 2 passed, 3 total
Time:        00:00:00
''',
        );

        expect(exitCode, 1);
      });

      testScope('errored suites are showed last', (ref) async {
        final exitCode = await runTest({
          'failing_test.dart': '''
import 'package:test/test.dart';
void main() {
  test('failing', () => throw StateError('fail'));
}
''',
          'passing_test.dart': '''
import 'package:test/test.dart';
void main() {
  test('passing', () => Future.delayed(Duration(milliseconds: 100)));
}
''',
        });

        final lastFrame = testRenderer!.frames.last;
        expect(lastFrame, contains('PASS  test/passing_test.dart'));
        expect(lastFrame, contains('FAIL  test/failing_test.dart'));
        expect(
          lastFrame,
          contains(
            '''
  ✕ failing
    Bad state: fail
    test/failing_test.dart 3:25  main.<fn>
''',
          ),
        );

        expect(
          lastFrame,
          endsWith(
            '''
  ● failing test/failing_test.dart:3:3
    Bad state: fail
    test/failing_test.dart 3:25  main.<fn>

Test Suites: 1 failed, 1 passed, 2 total
Tests:       1 failed, 1 passed, 2 total
Time:        00:00:00
''',
          ),
        );

        expect(exitCode, 1);
      });

      testScope(
          'summary contains list of all errors independently from suites/groups',
          (ref) async {
        final exitCode = await runTest({
          'failing_test.dart': '''
import 'package:test/test.dart';
void main() {
  test('failing', () => throw StateError('fail'));
  test('passing', () {});
}
''',
          'failing_group_test.dart': '''
import 'package:test/test.dart';
void main() {
  group('group', () {
    test('failing', () => throw StateError('fail'));
  });
  test('passing', () => Future.delayed(Duration(milliseconds: 50)));
}
''',
          'passing_test.dart': '''
import 'package:test/test.dart';
void main() {
  test('passing', () => Future.delayed(Duration(milliseconds: 100)));
}
''',
        });

        final lastFrame = testRenderer!.frames.last;
        expect(lastFrame, contains('PASS  test/passing_test.dart'));
        expect(
          lastFrame,
          contains('''
 FAIL  test/failing_test.dart
  ✕ failing
    Bad state: fail
    test/failing_test.dart 3:25  main.<fn>
'''),
        );
        expect(
          lastFrame,
          contains('''
 FAIL  test/failing_group_test.dart
  group
    ✕ failing
      Bad state: fail
      test/failing_group_test.dart 4:27  main.<fn>.<fn>
'''),
        );

        const groupFailingTest = '''
  ● group failing test/failing_group_test.dart:4:5
    Bad state: fail
    test/failing_group_test.dart 4:27  main.<fn>.<fn>
''';

        const failingTest = '''
  ● failing test/failing_test.dart:3:3
    Bad state: fail
    test/failing_test.dart 3:25  main.<fn>
''';

        const testResults = '''
Test Suites: 2 failed, 1 passed, 3 total
Tests:       2 failed, 3 passed, 5 total
Time:        00:00:00''';

        if (lastFrame.endsWith('''
$failingTest
$testResults
''')) {
          expect(
            lastFrame,
            endsWith(
              '''
$groupFailingTest
$failingTest
$testResults
''',
            ),
          );
        } else {
          expect(
            lastFrame,
            endsWith(
              '''
$failingTest
$groupFailingTest
$testResults
''',
            ),
          );
        }

        expect(exitCode, 1);
      });
    },
    overrides: [$spinner.overrideWithValue('...')],
    timeout: const Timeout.factor(2),
  );
}
