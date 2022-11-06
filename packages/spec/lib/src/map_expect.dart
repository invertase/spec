part of 'expect.dart';

/// Matchers for Maps
extension MapExpectationX<Return, KeyParam, ValueParam> on ExpectationBase<
    Map<KeyParam, ValueParam>, Return, Map<KeyParam, ValueParam>> {
  /// Returns a matcher which matches maps containing the key-value pair
  /// with [key] => [value].
  Return containsPair(KeyParam key, ValueParam value) =>
      runMatcher(dart_test.containsPair(key, value));

  /// Returns a matcher which matches maps containing the [key]
  /// with any value.
  Return containsKey(KeyParam key) => toContain(key);

  /// Returns a matcher which matches maps containing the key-value pair
  /// with [key] => [valueOrMatcher].
  /// ```dart
  /// expect({'hello': 'world'}).toHaveKeyValuePair('hello', 'world');
  /// ```
  Return containsValue(ValueParam? valueOrMatcher) {
    return runMatcher(dart_test.containsValue(valueOrMatcher));
  }
}
