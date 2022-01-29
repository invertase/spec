part of 'expect.dart';

/// Matchers against errors
extension ErrorExpectation<Return, Actual>
    on ExpectationBase<Object?, Return, Actual> {
  /// A matcher for [ArgumentError].
  Return isArgumentError() {
    return runMatcher(
      createMatcher(dart_test.isArgumentError),
    );
  }

  /// A matcher for [ConcurrentModificationError].
  Return isConcurrentModificationError() {
    return runMatcher(
      createMatcher(dart_test.isConcurrentModificationError),
    );
  }

  /// A matcher for [CyclicInitializationError].
  Return isCyclicInitializationError() {
    return runMatcher(
      createMatcher(dart_test.isCyclicInitializationError),
    );
  }

  /// A matcher for [Exception].
  Return isException() {
    return runMatcher(
      createMatcher(dart_test.isException),
    );
  }

  /// A matcher for [FormatException].
  Return isFormatException() {
    return runMatcher(
      createMatcher(dart_test.isFormatException),
    );
  }

  /// A matcher for [NoSuchMethodError].
  Return isNoSuchMethodError() {
    return runMatcher(
      createMatcher(dart_test.isNoSuchMethodError),
    );
  }

  /// A matcher for [NullThrownError].
  Return isNullThrownError() {
    return runMatcher(
      createMatcher(dart_test.isNullThrownError),
    );
  }

  /// A matcher for [RangeError].
  Return isRangeError() {
    return runMatcher(
      createMatcher(dart_test.isRangeError),
    );
  }

  /// A matcher for [StateError].
  Return isStateError() {
    return runMatcher(
      createMatcher(dart_test.isStateError),
    );
  }

  /// A matcher for [UnimplementedError].
  Return isUnimplementedError() {
    return runMatcher(
      createMatcher(dart_test.isUnimplementedError),
    );
  }

  /// A matcher for [UnsupportedError].
  Return isUnsupportedError() {
    return runMatcher(
      createMatcher(dart_test.isUnsupportedError),
    );
  }
}
