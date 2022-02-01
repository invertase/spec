import 'package:spec/spec.dart';
import 'package:test/test.dart' as t;

import 'utils.dart';

void main() {
  test('toBe', () {
    expect(42).toBe(42);

    t.expect(
      () => expect(42).toBe(21),
      throwsTestFailure,
    );
  });
}
