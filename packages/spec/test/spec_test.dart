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

    test('toContain', () {
      expect('Hello world').toContain('Hello');
      expect([1, 2]).toContain(2);
      expect({'hello': 'world'}).toContain('hello');

      t.expect(() => expect('Hello world').toContain('Bye'), throwsTestFailure);
      t.expect(() => expect([1, 2]).toContain(3), throwsTestFailure);
      t.expect(() => expect({'hello': 'world'}).toContain('world'),
          throwsTestFailure);
      t.expect(() => expect(1).toContain(2), throwsTestFailure);
    });

    test('toHaveLength', () {
      expect('Hello').toHaveLength(5);
      expect([1, 2]).toHaveLength(2);
      expect({'hello': 'world'}).toHaveLength(1);

      t.expect(() => expect('Hello').toHaveLength(4), throwsTestFailure);
      t.expect(() => expect([1, 2]).toHaveLength(3), throwsTestFailure);
      t.expect(
          () => expect({'hello': 'world'}).toHaveLength(2), throwsTestFailure);
    });
  });

  group('number matchers', () {
    test('isNaN', () {
      expect(double.nan).isNaN();

      t.expect(() => expect(1).isNaN(), throwsTestFailure);
    });

    test('isPositive', () {
      expect(42).isPositive();

      t.expect(() => expect(-42).isPositive(), throwsTestFailure);
      t.expect(() => expect(0).isPositive(), throwsTestFailure);
    });
    test('isNegative', () {
      expect(-42).isNegative();

      t.expect(() => expect(42).isNegative(), throwsTestFailure);
      t.expect(() => expect(0).isNegative(), throwsTestFailure);
    });

    test('isZero', () {
      expect(0).isZero();

      t.expect(() => expect(42).isZero(), throwsTestFailure);
    });

    test('lessThanOrEqualTo', () {
      expect(42).lessThanOrEqualTo(42);
      expect(42).lessThanOrEqualTo(43);

      t.expect(() => expect(42).lessThanOrEqualTo(41), throwsTestFailure);
    });

    test('lessThan', () {
      expect(42).lessThan(43);

      t.expect(() => expect(42).lessThan(41), throwsTestFailure);
      t.expect(() => expect(42).lessThan(42), throwsTestFailure);
    });

    test('greaterThanOrEqualTo', () {
      expect(42).greaterThanOrEqualTo(42);
      expect(42).greaterThanOrEqualTo(41);

      t.expect(() => expect(42).greaterThanOrEqualTo(43), throwsTestFailure);
    });

    test('greaterThan', () {
      expect(42).greaterThan(41);

      t.expect(() => expect(42).greaterThan(43), throwsTestFailure);
      t.expect(() => expect(42).greaterThan(42), throwsTestFailure);
    });

    test('toBeCloseTo', () {
      expect(0.2 + 0.1).toBeCloseTo(0.3, 0.1);
      expect(0.2 + 0.1).toBeCloseTo(0.35, 0.1);
      expect(0.2 + 0.1).toBeCloseTo(0.25, 0.1);

      t.expect(
          () => expect(0.2 + 0.1).toBeCloseTo(0.5, 0.1), throwsTestFailure);
    });
  });

  group('Map matchers', () {
    test('toHaveKey', () {
      expect({'hello': 'world'}).toHaveKey('hello');

      t.expect(() => expect({'hello': 'world'}).toHaveKey('world'),
          throwsTestFailure);
    });

    test('toHaveValue', () {
      expect({'hello': 'world'}).toHaveValue('world');

      t.expect(() => expect({'hello': 'world'}).toHaveValue('hello'),
          throwsTestFailure);
    });

    test('toHaveKeyValuePair', () {
      expect({'hello': 'world'}).toHaveKeyValuePair('hello', 'world');

      t.expect(
          () => expect({'hello': 'world'}).toHaveKeyValuePair('bye', 'world'),
          throwsTestFailure);
      t.expect(
          () => expect({'hello': 'world'}).toHaveKeyValuePair('hello', 'dart'),
          throwsTestFailure);
    });
  });
}
