import 'dart:async';

import 'package:meta/meta.dart';
import 'package:test/test.dart' as dart_test;

part 'bool_expect.dart';
part 'error_expect.dart';
part 'function_expect.dart';
part 'future_expect.dart';
part 'num_expect.dart';
part 'stream_expect.dart';
part 'string_expect.dart';
part 'list_expect.dart';
part 'map_expect.dart';

/// Perform expectations in a type safe way
Expectation<Actual> expect<Actual>(Actual value) {
  return Expectation._(value);
}

/// Internals for [expect]
/// Internals for [expect]
abstract class ExpectationBase<Actual, Return, Param> {
  /// Internals for [expect]
  ExpectationBase(
    this.actual, {
    dart_test.Matcher Function(dart_test.Matcher)? matcherBuilder,
  }) : _matcherBuilder = matcherBuilder ?? ((matcher) => matcher);

  /// The value that is tested
  final Actual actual;

  final dart_test.Matcher Function(dart_test.Matcher) _matcherBuilder;

  /// Expect that [actual] matches with a Matcher from the Dart SDK.
  @protected
  Return runMatcher(dart_test.Matcher match);

  @protected
  ExpectationBase<Actual, Return, Param> _copyWith({
    dart_test.Matcher Function(dart_test.Matcher)? matcherBuilder,
  });

  /// Apply transformations to a matcher.
  @protected
  dart_test.Matcher createMatcher(dart_test.Matcher match) {
    return _matcherBuilder(match);
  }

  /// Reverse the expectation
  ExpectationBase<Actual, Return, Param> get not => _copyWith(
        matcherBuilder: (matcher) => dart_test.isNot(_matcherBuilder(matcher)),
      );

  /// Returns a matches that matches if the value is the same instance
  /// as [expected], using [identical].
  Return toBe(Param expected) {
    return runMatcher(dart_test.same(expected));
  }

  /// Returns a matcher that matches if the value is structurally equal to
  /// [expected].
  ///
  /// For [Iterable]s and [Map]s, this will recursively match the elements. To
  /// handle cyclic structures a recursion depth [limit] can be provided. The
  /// default limit is 100. [Set]s will be compared order-independently.
  Return toEqual(Param expected, [int limit = 100]) {
    return runMatcher(dart_test.equals(expected, limit));
  }

  /// A matcher that matches any null value.
  Return isNull() {
    return runMatcher(dart_test.isNull);
  }

  /// A matcher that matches any null value.
  ///
  /// ```dart
  /// expect(value).toBeNull();
  /// ```
  Return toBeNull() {
    return isNull();
  }

  /// Returns a matcher that matches if the match argument is a string and
  /// matches the regular expression given by [re].
  ///
  /// [re] can be a [RegExp] instance or a [String]; in the latter case it will be
  /// used to create a RegExp instance.
  Return toMatch(Pattern re) {
    // TODO move to Pattern matcher
    return runMatcher(dart_test.matches(re));
  }

  /// Returns a matcher that matches objects with type [T].
  ///
  /// ```dart
  /// expect(shouldBeDuration).isA<Duration>();
  /// ```
  Return isA<T>() {
    return runMatcher(dart_test.isA<T>());
  }

  /// Returns a matcher that matches any value to be false or null.
  ///
  /// ```dart
  /// expect(value).toBeFalsy()
  /// ```
  Return toBeFalsy() {
    return runMatcher(dart_test.anyOf(dart_test.isFalse, dart_test.isNull));
  }

  /// Returns a matcher that matches any value that is not false or null.
  ///
  /// ```dart
  /// expect(value).toBeTruthy()
  /// ```
  Return toBeTruthy() {
    return runMatcher(
      dart_test.isNot(
        dart_test.anyOf(dart_test.isFalse, dart_test.isNull),
      ),
    );
  }

  /// Returns a matcher that matches if the match argument contains the
  /// expected value.
  ///
  /// For [String]s this means substring matching;
  /// for [Map]s it means the map has the key, and for [Iterable]s it means
  /// the iterable has a matching element.
  /// In the case of iterables, [expected] can itself be a matcher.
  ///
  /// ```dart
  /// expect('Hello world').toContain('Hello');
  /// expect([1,2]).toContain(2);
  /// expect({  'hello': 'world' }).toContain('hello');
  /// ```
  Return toContain(Object? expected) {
    return runMatcher(dart_test.contains(expected));
  }

  /// Returns a matcher that matches if an object has a length property that
  /// matches [matcher].
  /// ```dart
  /// expect('Hello').toHaveLength(5);
  /// expect([1, 2]).toHaveLength(2);
  /// expect({'hello': 'world'}).toHaveLength(1);
  /// ```
  Return toHaveLength(Object? matcher) {
    return runMatcher(dart_test.hasLength(matcher));
  }
}

/// A base class holding matchers
@sealed
class Expectation<Actual> extends ExpectationBase<Actual, void, Actual> {
  Expectation._(
    Actual actual, {
    dart_test.Matcher Function(dart_test.Matcher)? matcherBuilder,
  }) : super(actual, matcherBuilder: matcherBuilder);

  @override
  void runMatcher(dart_test.Matcher match) {
    dart_test.expect(actual, createMatcher(match));
  }

  @override
  ExpectationBase<Actual, void, Actual> _copyWith({
    dart_test.Matcher Function(dart_test.Matcher)? matcherBuilder,
  }) {
    return Expectation._(
      actual,
      matcherBuilder: matcherBuilder ?? _matcherBuilder,
    );
  }
}
