import 'package:spec_cli/src/command_runner.dart';
import 'package:test/test.dart';

import 'utils.dart';

void main() {
  groupScope('Spec', () {
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
        framesMatch(
          '''
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
''',
        ),
      );

      expect(exitCode, -1);
    });
  }, overrides: [
    TestStatus.$spinner.overrideWithValue('...'),
  ]);
}
