part of 'expect.dart';

/// Matchers for [Functions()]
extension FunctionExpectationMapper<FnReturn>
    on Expectation<FnReturn Function()> {
  /// Performs expectations on the value thrown by this function
  FunctionExpectation<FnReturn> get throws =>
      _ThrowsFunctionExpectation(actual);

  /// A matcher that matches a function call against no exception.
  ///
  /// The function will be called once. Any exceptions will be silently swallowed.
  /// The value passed to expect() should be a reference to the function.
  /// Note that the function cannot take arguments; to handle this
  /// a wrapper will have to be created.
  void returnsNormally() {
    return runMatcher(dart_test.returnsNormally);
  }
}

/// A class holding matchers for [Function()]
class FunctionExpectation<FnReturn>
    extends ExpectationBase<FnReturn Function(), void, FnReturn> {
  FunctionExpectation._(
    FnReturn Function() actual, {
    dart_test.Matcher Function(dart_test.Matcher)? matcherBuilder,
  }) : super(actual, matcherBuilder: matcherBuilder);

  @override
  void runMatcher(dart_test.Matcher match) {
    return dart_test.expect(actual, createMatcher(match));
  }

  @override
  FunctionExpectation<FnReturn> _copyWith({
    dart_test.Matcher Function(dart_test.Matcher p1)? matcherBuilder,
  }) {
    return FunctionExpectation._(actual, matcherBuilder: matcherBuilder);
  }
}

class _ThrowsFunctionExpectation<FnReturn>
    extends FunctionExpectation<FnReturn> {
  _ThrowsFunctionExpectation(FnReturn Function() actual)
      : super._(actual, matcherBuilder: dart_test.throwsA);
}
