import 'package:spec_cli/src/command_runner.dart';
import 'package:spec_cli/src/renderer.dart';
import 'package:spec_cli/src/rendering.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'utils.dart';

void main() {
  groupScope('Testing utilities', () {
    testScope('createProject works', (ref) async {
      final renderer = rendererOverride = TestRenderer();
      addTearDown(() => rendererOverride = null);

      final dir = await createProject([
        PackageInfo(
          name: 'a',
          files: {
            'lib/foo.dart': '''
class Counter {
  int count = 0;
}
''',
            'test/my_test.dart': '''
import 'package:a/foo.dart';
import 'package:test/test.dart';

void main() {
  test('Counter defaults to 0', () {
    final counter = Counter();
    expect(counter.count, 0);
  });
}
''',
          },
        ),
      ]);

      await spec(
        workingDirectory: '${dir.path}/packages/a',
      );

      expect(
        renderer.frames,
        framesMatch(
          '''
 RUNS  test/my_test.dart
---
 RUNS  test/my_test.dart
  ... Counter defaults to 0
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
    });

    testScope('runTest works', (ref) async {
      await runTest({
        'my_test.dart': '''
import 'package:test/test.dart';

void main() {
  test('works', () {
    expect(0, 0);
  });
  test('fails', () {
    expect(0, 1);
  });
}
''',
      });

      expect(
        testRenderer!.frames.last,
        '''
 FAIL  test/my_test.dart
  ✕ fails
    Expected: <1>
      Actual: <0>

    package:test_api       expect
    test/my_test.dart 8:5  main.<fn>

Test Suites: 1 failed, 1 total
Tests:       1 failed, 1 passed, 2 total
Time:        00:00:00
''',
      );
    });
  }, overrides: [
    $spinner.overrideWithValue('...'),
  ]);
}
