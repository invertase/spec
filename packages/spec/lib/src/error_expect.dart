part of 'expect.dart';

extension ErrorExpectation<Return, Actual>
    on ExpectationBase<Object?, Return, Actual> {
  Return isArgumentError() {
    return runMatcher(
      createMatcher(dart_test.isArgumentError),
    );
  }

  Return isConcurrentModificationError() {
    return runMatcher(
      createMatcher(dart_test.isConcurrentModificationError),
    );
  }

  Return isCyclicInitializationError() {
    return runMatcher(
      createMatcher(dart_test.isCyclicInitializationError),
    );
  }

  Return isException() {
    return runMatcher(
      createMatcher(dart_test.isException),
    );
  }

  Return isFormatException() {
    return runMatcher(
      createMatcher(dart_test.isFormatException),
    );
  }

  Return isNoSuchMethodError() {
    return runMatcher(
      createMatcher(dart_test.isNoSuchMethodError),
    );
  }

  Return isNullThrownError() {
    return runMatcher(
      createMatcher(dart_test.isNullThrownError),
    );
  }

  Return isRangeError() {
    return runMatcher(
      createMatcher(dart_test.isRangeError),
    );
  }

  Return isStateError() {
    return runMatcher(
      createMatcher(dart_test.isStateError),
    );
  }

  Return isUnimplementedError() {
    return runMatcher(
      createMatcher(dart_test.isUnimplementedError),
    );
  }

  Return isUnsupportedError() {
    return runMatcher(
      createMatcher(dart_test.isUnsupportedError),
    );
  }
}
