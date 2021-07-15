part of 'expect.dart';

extension NumExpectation<Return> on ExpectationBase<Object?, Return, num> {
  Return isNaN() {
    return runMatcher(
      createMatcher(dart_test.isNaN),
    );
  }

  Return isPositive() {
    return runMatcher(
      createMatcher(dart_test.isPositive),
    );
  }

  Return isNegative() {
    return runMatcher(
      createMatcher(dart_test.isNegative),
    );
  }

  Return isZero() {
    return runMatcher(
      createMatcher(dart_test.isZero),
    );
  }

  Return lessThanOrEqualTo(num nbr) {
    return runMatcher(
      createMatcher(dart_test.lessThanOrEqualTo(nbr)),
    );
  }

  Return lessThan(num nbr) {
    return runMatcher(
      createMatcher(dart_test.lessThan(nbr)),
    );
  }

  Return greaterThan(num nbr) {
    return runMatcher(
      createMatcher(dart_test.greaterThan(nbr)),
    );
  }

  Return greaterThanOrEqualTo(num nbr) {
    return runMatcher(
      createMatcher(dart_test.greaterThanOrEqualTo(nbr)),
    );
  }
}
