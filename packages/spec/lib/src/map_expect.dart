part of 'expect.dart';

/// Matchers for [Map]s.
extension MapExpectation<Return> on ExpectationBase<Object?, Return, Map> {
  /// A matcher that matches if the argument is a map and has the [expected] key.
  /// ```dart
  /// expect({'hello': 'world'}).toHaveKey('hello');
  /// ```
  Return toHaveKey(Object? expected) {
    return toContain(expected);
  }

  /// Returns a matcher which matches maps containing the given [value].
  /// ```dart
  /// expect({'hello': 'world'}).toHaveValue('world');
  /// ```
  Return toHaveValue(Object? value) {
    return runMatcher(dart_test.containsValue(value));
  }

  /// Returns a matcher which matches maps containing the key-value pair
  /// with [key] => [valueOrMatcher].
  /// ```dart
  /// expect({'hello': 'world'}).toHaveKeyValuePair('hello', 'world');
  /// ```
  Return toHaveKeyValuePair(Object? key, Object? valueOrMatcher) {
    return runMatcher(dart_test.containsPair(key, valueOrMatcher));
  }
}
