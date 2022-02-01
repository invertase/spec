part of 'expect.dart';

/// Matchers for booleans
extension BoolExpectation<Return> on ExpectationBase<Object?, Return, bool> {
  /// A matcher that matches anything except the Boolean value true.
  Return isFalse() {
    return runMatcher(dart_test.isFalse);
  }

  /// A matcher that matches the Boolean value true.
  Return isTrue() {
    return runMatcher(dart_test.isTrue);
  }
}
