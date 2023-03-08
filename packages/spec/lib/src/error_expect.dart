part of 'expect.dart';

/// Matchers against errors
extension ErrorExpectation<Return, Actual>
    on ExpectationBase<Object?, Return, Actual> {
  /// A matcher for [ArgumentError].
  Return isArgumentError() {
    return runMatcher(dart_test.isArgumentError);
  }

  /// A matcher for [ConcurrentModificationError].
  Return isConcurrentModificationError() {
    return runMatcher(dart_test.isConcurrentModificationError);
  }

  // ignore: deprecated_member_use
  /// A matcher for [CyclicInitializationError].
  @Deprecated(
    'CyclicInitializationError is deprecated and will be removed in Dart 3. '
    'Use `isA<Error>()` instead.',
  )
  Return isCyclicInitializationError() {
    // ignore: deprecated_member_use
    return runMatcher(dart_test.isCyclicInitializationError);
  }

  /// A matcher for [Exception].
  Return isException() {
    return runMatcher(dart_test.isException);
  }

  /// A matcher for [FormatException].
  Return isFormatException() {
    return runMatcher(dart_test.isFormatException);
  }

  /// A matcher for [NoSuchMethodError].
  Return isNoSuchMethodError() {
    return runMatcher(dart_test.isNoSuchMethodError);
  }

  // ignore: deprecated_member_use
  /// A matcher for [NullThrownError].
  @Deprecated(
    'NullThrownError is deprecated and will be removed in Dart 3. '
    'Use `isA<TypeError>()` instead.',
  )
  Return isNullThrownError() {
    // ignore: deprecated_member_use
    return runMatcher(dart_test.isNullThrownError);
  }

  /// A matcher for [RangeError].
  Return isRangeError() {
    return runMatcher(dart_test.isRangeError);
  }

  /// A matcher for [StateError].
  Return isStateError() {
    return runMatcher(dart_test.isStateError);
  }

  /// A matcher for [UnimplementedError].
  Return isUnimplementedError() {
    return runMatcher(dart_test.isUnimplementedError);
  }

  /// A matcher for [UnsupportedError].
  Return isUnsupportedError() {
    return runMatcher(dart_test.isUnsupportedError);
  }
}
