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

  /// Returns a matcher which matches maps containing the given [value].
  /// ```dart
  /// expect({'hello': 'world'}).containsValue('world');
  /// ```
  Return containsValue(ValueParam? value) {
    return runMatcher(dart_test.containsValue(value));
  }
}
