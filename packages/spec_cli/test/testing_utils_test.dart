import 'package:spec_cli/src/command_runner.dart';
import 'package:spec_cli/src/renderer.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'utils.dart';

void main() {
  late TestRenderer renderer;

  setUp(() => testRenderer = rendererOverride = renderer = TestRenderer());
  tearDown(() => rendererOverride = null);

  groupScope('Testing utilities', () {
    testScope('createProject works', (ref) async {
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

      await fest(
        workingDirectory: dir.path + '/packages/a',
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
  ✓ works
  ✕ fails
    Expected: <1>
      Actual: <0>

    package:test_api       expect
    test/my_test.dart 8:5  main.<fn>
''',
      );
    });
  }, overrides: [
    TestStatus.$spinner.overrideWithValue('...'),
  ]);
}
