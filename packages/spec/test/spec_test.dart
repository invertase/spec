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

  test('completion', () async {
    await expect(Future.value(42)).completion.toBe(42);

    await t.expectLater(
      () => expect(Future.value(42)).completion.toBe(21),
      throwsTestFailure,
    );
  });

  test('emits', () async {
    await expect(Stream.value(42)).emits.toBe(42);

    await t.expectLater(
      () => expect(Stream.value(42)).emits.toBe(21),
      throwsTestFailure,
    );
  });

  test('not', () async {
    expect(42).not.toBe(21);

    await t.expectLater(
      () => expect(42).not.toBe(42),
      throwsTestFailure,
    );
  });
}
