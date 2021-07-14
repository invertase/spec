import 'package:test/test.dart' as dart_test;
import 'package:meta/meta.dart';

@sealed
class Expectation<ExpectedType, ReturnType> {
  Expectation._(
    this.actual, {
    dart_test.Matcher Function(dart_test.Matcher)? matcherBuilder,
    required ReturnType Function(Object? actual, dart_test.Matcher)
        expectBuilder,
  })  : _matcherBuilder = matcherBuilder ?? ((matcher) => matcher),
        _expectBuilder = expectBuilder;

  final Object? actual;

  final dart_test.Matcher Function(dart_test.Matcher) _matcherBuilder;
  final ReturnType Function(Object? actual, dart_test.Matcher) _expectBuilder;

  /// Reverse the expectation
  Expectation<ExpectedType, ReturnType> get not => Expectation._(
        actual,
        matcherBuilder: (matcher) => dart_test.isNot(_matcherBuilder(matcher)),
        expectBuilder: _expectBuilder,
      );

  /// Expect that [actual] matches with a Matcher from the Dart SDK.
  ReturnType toMatch(dart_test.Matcher match) {
    return _expectBuilder(actual, _matcherBuilder(match));
  }

  /// Compares [actual] with [expected] using [identical].
  ReturnType toBe(ExpectedType expected) {
    return toMatch(dart_test.same(expected));
  }

  /// Compares [actual] with [expected] using the operator `==`.
  ReturnType toEqual(ExpectedType expected) {
    return toMatch(dart_test.equals(expected));
  }
}

Expectation<ExpectedType, void> expect<ExpectedType>(ExpectedType value) {
  return Expectation._(
    value,
    expectBuilder: (actual, matcher) => dart_test.expect(actual, matcher),
  );
}

extension AsyncExpectation<ExpectedType>
    on Expectation<Future<ExpectedType>, void> {
  /// Reverse the expectation
  Expectation<ExpectedType, Future<void>> get resolve => Expectation._(
        actual,
        matcherBuilder: (matcher) =>
            dart_test.completion(_matcherBuilder(matcher)),
        expectBuilder: (actual, matcher) =>
            dart_test.expectLater(actual, matcher),
      );

  /// Reverse the expectation
  Expectation<ExpectedType, Future<void>> get reject => Expectation._(
        actual,
        matcherBuilder: (matcher) =>
            dart_test.throwsA(_matcherBuilder(matcher)),
        expectBuilder: (actual, matcher) =>
            dart_test.expectLater(actual, matcher),
      );
}
