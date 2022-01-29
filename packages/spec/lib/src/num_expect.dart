part of 'expect.dart';

/// Matchers for numbers
extension NumExpectation<Return> on ExpectationBase<Object?, Return, num> {
  /// A matcher that matches the numeric value NaN.
  Return isNaN() {
    return runMatcher(
      createMatcher(dart_test.isNaN),
    );
  }

  /// A matcher which matches if the match argument is positive.
  Return isPositive() {
    return runMatcher(
      createMatcher(dart_test.isPositive),
    );
  }

  /// A matcher which matches if the match argument is negative.
  Return isNegative() {
    return runMatcher(
      createMatcher(dart_test.isNegative),
    );
  }

  /// A matcher which matches if the match argument is zero.
  Return isZero() {
    return runMatcher(
      createMatcher(dart_test.isZero),
    );
  }

  /// Returns a matcher which matches if the match argument is less
  /// than or equal to the given [value].
  Return lessThanOrEqualTo(num value) {
    return runMatcher(
      createMatcher(dart_test.lessThanOrEqualTo(value)),
    );
  }

  /// Returns a matcher which matches if the match argument is less
  /// than the given [value].
  Return lessThan(num value) {
    return runMatcher(
      createMatcher(dart_test.lessThan(value)),
    );
  }

  /// Returns a matcher which matches if the match argument is greater
  /// than the given [value].
  Return greaterThan(num value) {
    return runMatcher(
      createMatcher(dart_test.greaterThan(value)),
    );
  }

  /// Returns a matcher which matches if the match argument is greater
  /// than or equal to the given [value].
  Return greaterThanOrEqualTo(num value) {
    return runMatcher(
      createMatcher(dart_test.greaterThanOrEqualTo(value)),
    );
  }
}
