// ignore_for_file: omit_local_variable_types, prefer_final_locals

import 'package:spec/spec.dart';
import 'package:test/test.dart' as t;

import 'utils.dart';

void main() {
  group('futures', () {
    test('completion', () async {
      await expect(Future.value(42)).completion.toBe(42);

      await t.expectLater(
        () => expect(Future.value(42)).completion.toBe(21),
        throwsTestFailure,
      );

      await t.expectLater(
        () => expect(Future<int>.error(42)).completion.toBe(42),
        t.throwsA(42),
      );
    });

    test('throws', () async {
      await expect(Future<int>.error('err')).throws.toBe('err');

      await t.expectLater(
        () => expect(Future<int>.error('err')).throws.toBe('fail'),
        throwsTestFailure,
      );

      await t.expectLater(
        () => expect(Future<int>.value(42)).throws.toBe('fail'),
        throwsTestFailure,
      );
    });
  });

  group('streams', () {
    test('emits', () async {
      await expect(Stream.value(42)).emits.toBe(42);

      await t.expectLater(
        () => expect(Stream.value(42)).emits.toBe(21),
        throwsTestFailure,
      );
    });
  });

  group('object matchers', () {
    test('toBe', () {
      expect(42).toBe(42);

      t.expect(
        () => expect(42).toBe(21),
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

    test('isA', () {
      expect(42).isA<int>();

      t.expect(
        () => expect(42).isA<String>(),
        throwsTestFailure,
      );
    });

    test('toBeNull', () {
      expect(null).toBeNull();

      t.expect(
        () => expect(42).toBeNull(),
        throwsTestFailure,
      );
    });

    test('toBeFalsy', () {
      expect(false).toBeFalsy();
      expect(null).toBeFalsy();

      t.expect(() => expect(true).toBeFalsy(), throwsTestFailure);
      t.expect(() => expect(1).toBeFalsy(), throwsTestFailure);
      t.expect(() => expect('foo').toBeFalsy(), throwsTestFailure);
    });

    test('toBeTruthy', () {
      expect(true).toBeTruthy();
      expect(7).toBeTruthy();
      expect('foo').toBeTruthy();

      t.expect(() => expect(false).toBeTruthy(), throwsTestFailure);
      t.expect(() => expect(null).toBeTruthy(), throwsTestFailure);
    });
  });
}
