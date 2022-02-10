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
