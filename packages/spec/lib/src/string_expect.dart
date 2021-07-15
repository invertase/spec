part of 'expect.dart';

extension StringExpectation<Return>
    on ExpectationBase<Object?, Return, String> {
  Return equalsIgnoringCase(String value) {
    return runMatcher(
      createMatcher(dart_test.equalsIgnoringCase(value)),
    );
  }

  Return equalsIgnoringWhitespace(String value) {
    return runMatcher(
      createMatcher(dart_test.equalsIgnoringWhitespace(value)),
    );
  }

  Return startsWith(String value) {
    return runMatcher(
      createMatcher(dart_test.startsWith(value)),
    );
  }

  Return stringContainsInOrder(List<String> value) {
    return runMatcher(
      createMatcher(dart_test.stringContainsInOrder(value)),
    );
  }
}
