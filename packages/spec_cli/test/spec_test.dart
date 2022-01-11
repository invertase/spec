import 'package:spec_cli/src/command_runner.dart';
import 'package:spec_cli/src/rendering.dart';
import 'package:test/test.dart';

import 'utils.dart';

void main() {
  groupScope('Spec', () {
    // TODO on sigint/sigterm, report suites/tests that were not executed. Blocked by https://github.com/dart-lang/test/issues/1654

    testScope(
        'handles non-json logs from the test output (such as Flutter\'s "Downloading ...")',
        (ref) async {});
    testScope('pipe stderr of dart/flutter test', (ref) async {});

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

    testScope('can filter tests by name', (ref) async {
      final exitCode = await runTest(
        {
          'my_test.dart': r'''
import 'package:test/test.dart';
void main() {
  test('hello world', () {});
  test('fail', () => throw StateError('fail'));
  test('hello baz', () {});
}
''',
        },
        options: SpecOptions.fromArgs(['--name=hello']),
      );

      expect(testRenderer!.frames.last, '''
 PASS  test/my_test.dart

Test Suites: 1 passed, 1 total
Tests:       2 passed, 2 total
Time:        00:00:00
''');

      expect(exitCode, 0);
    });

    testScope('supports empty suites due to test name filter', (ref) async {
      final exitCode = await runTest(
        {
          'my_test.dart': r'''
import 'package:test/test.dart';
void main() {
  test('hello', () {});
}
''',
          'maybe_empty_test.dart': r'''
import 'package:test/test.dart';
void main() {
  test('fail', () => throw StateError('fail'));
}
''',
        },
        options: SpecOptions.fromArgs(['--name=hello']),
      );

      expect(testRenderer!.frames.last, '''
 PASS  test/my_test.dart

Test Suites: 1 passed, 2 total
Tests:       1 passed, 1 total
Time:        00:00:00
''');

      expect(exitCode, 0);
    });

    testScope('can filter suites by path', (ref) async {
      final exitCode = await runTest(
        {
          'my_test.dart': r'''
import 'package:test/test.dart';
void main() {
  test('hello world', () {});
}
''',
          'another_test.dart': r'''
import 'package:test/test.dart';
void main() {
  test('pass', () {});
}
''',
          'excuded_test.dart': r'''
import 'package:test/test.dart';
void main() {
  test('fail', () => throw StateError('fail'));
}
''',
        },
        options: SpecOptions.fromArgs(
          ['test/my_test.dart', 'test/another_test.dart'],
        ),
      );

      expect(testRenderer!.frames.last, '''
 PASS  test/another_test.dart
 PASS  test/my_test.dart

Test Suites: 2 passed, 2 total
Tests:       2 passed, 2 total
Time:        00:00:00
''');

      expect(exitCode, 0);
    });

    testScope('handles flutter packages', (ref) async {
      final exitCode = await runTest({
        'my_test.dart': r'''
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
        'my_test.dart': r'''
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
        testRenderer!.frames,
        framesMatch(
          '''
 RUNS  test/my_test.dart
---
 RUNS  test/my_test.dart
  skipped group
---
 RUNS  test/my_test.dart
  skipped group
    ○ test
---
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
        ),
      );

      expect(exitCode, 0);
    });

    testScope('handles skipped tests', (ref) async {
      final exitCode = await runTest({
        'my_test.dart': r'''
import 'package:test/test.dart';

void main() {
  test('skipped', () => throw StateError('??'), skip: true);
  test('pass', () => Future.delayed(Duration(seconds: 1)));
  test('fail', () => throw StateError('fail'));
}
''',
      });

      expect(
        testRenderer!.frames,
        framesMatch(
          '''
 RUNS  test/my_test.dart
---
 RUNS  test/my_test.dart
  ○ skipped
---
 RUNS  test/my_test.dart
  ○ skipped
  ... pass
---
 RUNS  test/my_test.dart
  ○ skipped
  ✓ pass
---
 RUNS  test/my_test.dart
  ○ skipped
  ✓ pass
  ... fail
---
 FAIL  test/my_test.dart
  ○ skipped
  ✓ pass
  ✕ fail
    Bad state: fail
    test/my_test.dart 6:22  main.<fn>
---
 FAIL  test/my_test.dart
  ✕ fail
    Bad state: fail
    test/my_test.dart 6:22  main.<fn>

Test Suites: 1 failed, 1 total
Tests:       1 failed, 1 passed, 1 skipped, 3 total
Time:        00:00:00
''',
        ),
      );

      expect(exitCode, -1);
    });

    testScope('handles nested groups', (ref) async {
      final exitCode = await runTest({
        'my_test.dart': r'''
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

Test Suites: 1 failed, 1 total
Tests:       3 failed, 5 passed, 8 total
Time:        00:00:00
''',
      );

      expect(exitCode, -1);
    });

    testScope(
      'handles empty suites',
      (ref) async {
        final exitCode = await runTest({
          'my_test.dart': r'''
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
      skip: 'blocked by https://github.com/dart-lang/test/issues/1652 because '
          'we cannot determine if a suite is completed without tests',
    );

    testScope(
      'handle empty groups',
      (ref) async {
        final exitCode = await runTest({
          'my_test.dart': r'''
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
      skip: 'blocked by https://github.com/dart-lang/test/issues/1652 because '
          'we cannot determine if a group is completed without tests',
    );

    testScope('handle suites that fail to compile', (ref) async {
      final exitCode = await runTest({'my_test.dart': 'invalid'});

      expect(
          testRenderer!.frames,
          framesMatch(
            [
              ' RUNS  test/my_test.dart\n',
              contains('''
 FAIL  test/my_test.dart

    Failed to load "test/my_test.dart":
    test/my_test.dart:1:1: Error: Variables must be declared using the keywords \'const\', \'final\', \'var\' or a type name.
    Try adding the name of the type of the variable or the keyword \'var\'.
    invalid
    ^^^^^^^
    test/my_test.dart:1:1: Error: Expected \';\' after this.
    invalid
    ^^^^^^^
'''),
            ],
          ));

      expect(exitCode, -1);
    }, skip: 'blocked by https://github.com/dart-lang/test/issues/1652');

    testScope('render error logs made during tests', (ref) async {
      final exitCode = await runTest({
        'my_test.dart': r'''
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
        testRenderer!.frames,
        framesMatch(
          '''
 RUNS  test/my_test.dart
---
 RUNS  test/my_test.dart
  ... first
---
 RUNS  test/my_test.dart
  ... first
hello
---
 RUNS  test/my_test.dart
  ... first
hello
this is an error
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
        testRenderer!.frames,
        framesMatch(
          '''
 RUNS  test/my_test.dart
---
 RUNS  test/my_test.dart
  ... first
---
 RUNS  test/my_test.dart
  ... first
hello
first
---
 RUNS  test/my_test.dart
  ... first
hello
first
another
---
 RUNS  test/my_test.dart
  ✕ first
---
 RUNS  test/my_test.dart
  ... second
  ✕ first
---
 RUNS  test/my_test.dart
  ... second
hello
second
  ✕ first
---
 RUNS  test/my_test.dart
  ✓ second
  ✕ first
---
 RUNS  test/my_test.dart
  ✓ second
hello
second
  ... third
  ✕ first
---
 RUNS  test/my_test.dart
  ✓ second
  ... third
hello
third
  ✕ first
---
 FAIL  test/my_test.dart
  ✓ second
  ✓ third
  ✕ first
---
 FAIL  test/my_test.dart
  ✕ first
hello
first
another

    Bad state: first
    test/my_test.dart 11:5  main.<fn>

Test Suites: 1 failed, 1 total
Tests:       1 failed, 2 passed, 3 total
Time:        00:00:00
''',
        ),
      );

      expect(exitCode, -1);
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

      expect(
        testRenderer!.frames,
        framesMatch([
          anyOf(
            ' RUNS  test/pending_test.dart\n',
            ' RUNS  test/pending_test.dart\n',
          ),
          '''
 RUNS  test/passing_test.dart
 RUNS  test/pending_test.dart
''',
          anyOf(
            '''
 RUNS  test/passing_test.dart
 RUNS  test/pending_test.dart
  ... pending
''',
            '''
 RUNS  test/passing_test.dart
  ... passing
 RUNS  test/pending_test.dart
''',
          ),
          '''
 RUNS  test/passing_test.dart
  ... passing
 RUNS  test/pending_test.dart
  ... pending
---
 PASS  test/passing_test.dart

 RUNS  test/pending_test.dart
---
 PASS  test/passing_test.dart

 RUNS  test/pending_test.dart
  ... pending
---
 PASS  test/passing_test.dart
 PASS  test/pending_test.dart
---
 PASS  test/passing_test.dart
 PASS  test/pending_test.dart

Test Suites: 2 passed, 2 total
Tests:       2 passed, 2 total
Time:        00:00:00
''',
        ]),
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
        testRenderer!.frames,
        framesMatch(
          '''
 RUNS  test/my_test.dart
---
 RUNS  test/my_test.dart
  ... first
---
 RUNS  test/my_test.dart
  ✓ first
---
 RUNS  test/my_test.dart
  ✓ first
  ... second
---
 RUNS  test/my_test.dart
  ✓ first
  ✓ second
---
 RUNS  test/my_test.dart
  ✓ first
  ✓ second
  ... third
---
 PASS  test/my_test.dart
---
 PASS  test/my_test.dart

Test Suites: 1 passed, 1 total
Tests:       3 passed, 3 total
Time:        00:00:00
''',
        ),
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
        testRenderer!.frames,
        framesMatch(
          '''
 RUNS  test/my_test.dart
---
 RUNS  test/my_test.dart
  ... first
---
 RUNS  test/my_test.dart
  ✕ first
---
 RUNS  test/my_test.dart
  ... second
  ✕ first
---
 RUNS  test/my_test.dart
  ✓ second
  ✕ first
---
 RUNS  test/my_test.dart
  ✓ second
  ... third
  ✕ first
---
 FAIL  test/my_test.dart
  ✓ second
  ✓ third
  ✕ first
---
 FAIL  test/my_test.dart
  ✕ first
    Bad state: first
    test/my_test.dart 9:5  main.<fn>

Test Suites: 1 failed, 1 total
Tests:       1 failed, 2 passed, 3 total
Time:        00:00:00
''',
        ),
      );

      expect(exitCode, -1);
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

      expect(
        testRenderer!.frames,
        framesMatch('''
 RUNS  test/failing_test.dart
---
 RUNS  test/failing_test.dart
 RUNS  test/passing_test.dart
---
 RUNS  test/failing_test.dart
  ... failing
 RUNS  test/passing_test.dart
---
 RUNS  test/failing_test.dart
  ... failing
 RUNS  test/passing_test.dart
  ... passing
---
 RUNS  test/passing_test.dart

 FAIL  test/failing_test.dart
  ✕ failing
---
 RUNS  test/passing_test.dart
  ... passing

 FAIL  test/failing_test.dart
  ✕ failing
---
 PASS  test/passing_test.dart

 FAIL  test/failing_test.dart
  ✕ failing
---
 FAIL  test/failing_test.dart
  ✕ failing
    Bad state: fail
    test/failing_test.dart 3:25  main.<fn>

Test Suites: 1 failed, 1 passed, 2 total
Tests:       1 failed, 1 passed, 2 total
Time:        00:00:00
'''),
      );

      expect(exitCode, -1);
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
  test('passing', () {});
}
''',
        'passing_test.dart': '''
import 'package:test/test.dart';
void main() {
  test('passing', () {});
}
''',
      });

      expect(testRenderer!.frames.last, '''
 FAIL  test/failing_group_test.dart
  group
    ✕ failing
      Bad state: fail
      test/failing_group_test.dart 4:27  main.<fn>.<fn>
 FAIL  test/failing_test.dart
  ✕ failing
    Bad state: fail
    test/failing_test.dart 3:25  main.<fn>

Test Suites: 2 failed, 1 passed, 3 total
Tests:       2 failed, 3 passed, 5 total
Time:        00:00:00
''');

      expect(exitCode, -1);
    });
  }, overrides: [
    $spinner.overrideWithValue('...'),
  ]);
}
