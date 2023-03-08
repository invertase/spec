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
  });

  group('list', () {
    test('containsAll', () {
      expect([1, 2, 3]).containsAll([1, 2]);

      t.expect(
        () => expect([1, 2, 3]).containsAll([1, 2, 4]),
        throwsTestFailure,
      );
    });

    test('not contains', () {
      expect([1, 2, 3]).not.containsAll([1, 2, 4]);

      t.expect(
        () => expect([1, 2, 3]).not.containsAll([1, 2]),
        throwsTestFailure,
      );
    });

    test('contains', () {
      expect([1, 2, 3]).contains(1);

      t.expect(
        () => expect([1, 2, 3]).contains(4),
        throwsTestFailure,
      );
    });
  });

  group('map', () {
    test('containsPair', () {
      expect({'a': 1, 'b': 2}).containsPair('a', 1);

      t.expect(
        () => expect({'a': 1, 'b': 2}).containsPair('a', 2),
        throwsTestFailure,
      );
    });

    test('containsKey', () {
      expect({'a': 1, 'b': 2}).containsKey('a');

      t.expect(
        () => expect({'a': 1, 'b': 2}).containsKey('c'),
        throwsTestFailure,
      );
    });
  });
}
