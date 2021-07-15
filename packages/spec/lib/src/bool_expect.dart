part of 'expect.dart';

extension BoolExpectation<Return> on ExpectationBase<Object?, Return, bool> {
  Return isFalse() {
    return runMatcher(
      createMatcher(dart_test.isFalse),
    );
  }

  Return isTrue() {
    return runMatcher(
      createMatcher(dart_test.isTrue),
    );
  }
}
