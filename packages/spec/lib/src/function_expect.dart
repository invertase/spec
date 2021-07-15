part of 'expect.dart';

extension FunctionExpectationMapper<FnReturn>
    on Expectation<FnReturn Function()> {
  /// Reverse the expectation
  FunctionExpectation<FnReturn> get throws =>
      _ThrowsFunctionExpectation(actual);

  void returnsNormally() {
    return runMatcher(
      createMatcher(dart_test.returnsNormally),
    );
  }
}

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
