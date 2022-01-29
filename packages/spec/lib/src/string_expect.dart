part of 'expect.dart';

/// Matchers for [String]s
extension StringExpectation<Return>
    on ExpectationBase<Object?, Return, String> {
  /// Returns a matcher which matches if the match argument is a string and
  /// is equal to [value] when compared case-insensitively.
  Return equalsIgnoringCase(String value) {
    return runMatcher(
      createMatcher(dart_test.equalsIgnoringCase(value)),
    );
  }

  /// Returns a matcher which matches if the match argument is a string and
  /// is equal to [value], ignoring whitespace.
  ///
  /// In this matcher, "ignoring whitespace" means comparing with all runs of
  /// whitespace collapsed to single space characters and leading and trailing
  /// whitespace removed.
  ///
  /// For example, the following will all match successfully:
  ///
  ///     expect("hello   world", equalsIgnoringWhitespace("hello world"));
  ///     expect("  hello world", equalsIgnoringWhitespace("hello world"));
  ///     expect("hello world  ", equalsIgnoringWhitespace("hello world"));
  ///
  /// The following will not match:
  ///
  ///     expect("helloworld", equalsIgnoringWhitespace("hello world"));
  ///     expect("he llo world", equalsIgnoringWhitespace("hello world"));
  Return equalsIgnoringWhitespace(String value) {
    return runMatcher(
      createMatcher(dart_test.equalsIgnoringWhitespace(value)),
    );
  }

  /// Returns a matcher that matches if the match argument is a string and
  /// starts with [prefixString].
  Return startsWith(String prefixString) {
    return runMatcher(
      createMatcher(dart_test.startsWith(prefixString)),
    );
  }

  /// Returns a matcher that matches if the match argument is a string and
  /// contains a given list of [substrings] in relative order.
  ///
  /// For example, `stringContainsInOrder(["a", "e", "i", "o", "u"])` will match
  /// "abcdefghijklmnopqrstuvwxyz".
  Return stringContainsInOrder(List<String> substrings) {
    return runMatcher(
      createMatcher(dart_test.stringContainsInOrder(substrings)),
    );
  }
}
