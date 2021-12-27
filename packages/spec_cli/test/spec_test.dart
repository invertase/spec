import 'package:spec_cli/src/command_runner.dart';
import 'package:test/test.dart';

import 'utils.dart';

void main() {
  groupScope('Spec', () {
    testScope('handle errors inside setup', (ref) async {}, skip: true);

    testScope('handle errors inside tearDown', (ref) async {}, skip: true);

    testScope('handle test failure after test done', (ref) async {},
        skip: true);
    testScope('handle nested groups', (ref) async {}, skip: true);

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
hello
first
another

    Bad state: first
    test/my_test.dart 11:5  main.<fn>
---
 RUNS  test/my_test.dart
  ... second
  ✕ first
hello
first
another

    Bad state: first
    test/my_test.dart 11:5  main.<fn>
---
 RUNS  test/my_test.dart
  ... second
hello
second
  ✕ first
hello
first
another

    Bad state: first
    test/my_test.dart 11:5  main.<fn>
---
 RUNS  test/my_test.dart
  ✓ second
hello
second
  ✕ first
hello
first
another

    Bad state: first
    test/my_test.dart 11:5  main.<fn>
---
 RUNS  test/my_test.dart
  ✓ second
hello
second
  ... third
  ✕ first
hello
first
another

    Bad state: first
    test/my_test.dart 11:5  main.<fn>
---
 RUNS  test/my_test.dart
  ✓ second
hello
second
  ... third
hello
third
  ✕ first
hello
first
another

    Bad state: first
    test/my_test.dart 11:5  main.<fn>
---
 FAIL  test/my_test.dart
  ✓ second
hello
second
  ✓ third
hello
third
  ✕ first
hello
first
another

    Bad state: first
    test/my_test.dart 11:5  main.<fn>
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
  ... pending
---
 PASS  test/passing_test.dart
 PASS  test/pending_test.dart
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
    Bad state: first
    test/my_test.dart 9:5  main.<fn>
---
 RUNS  test/my_test.dart
  ... second
  ✕ first
    Bad state: first
    test/my_test.dart 9:5  main.<fn>
---
 RUNS  test/my_test.dart
  ✓ second
  ✕ first
    Bad state: first
    test/my_test.dart 9:5  main.<fn>
---
 RUNS  test/my_test.dart
  ✓ second
  ... third
  ✕ first
    Bad state: first
    test/my_test.dart 9:5  main.<fn>
---
 FAIL  test/my_test.dart
  ✓ second
  ✓ third
  ✕ first
    Bad state: first
    test/my_test.dart 9:5  main.<fn>
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
  ... passing

 FAIL  test/failing_test.dart
  ✕ failing
    Bad state: fail
    test/failing_test.dart 3:25  main.<fn>
---
 PASS  test/passing_test.dart

 FAIL  test/failing_test.dart
  ✕ failing
    Bad state: fail
    test/failing_test.dart 3:25  main.<fn>
'''),
      );

      expect(exitCode, -1);
    });
  }, overrides: [
    TestStatus.$spinner.overrideWithValue('...'),
  ]);
}
