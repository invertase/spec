part of 'expect.dart';

extension FutureExpectationMapper<Actual> on Expectation<Future<Actual>> {
  /// Reverse the expectation
  FutureExpectation<Actual> get completion => _ResolveFutureExpectation(actual);

  /// Reverse the expectation
  FutureExpectation<Actual> get throws => _RejectFutureExpectation(actual);

  void doesNotComplete() {
    return runMatcher(
      createMatcher(dart_test.doesNotComplete),
    );
  }
}

class FutureExpectation<Actual>
    extends ExpectationBase<Future<Actual>, Future<void>, Actual> {
  FutureExpectation._(
    Future<Actual> actual, {
    dart_test.Matcher Function(dart_test.Matcher)? matcherBuilder,
  }) : super(actual, matcherBuilder: matcherBuilder);

  @override
  Future<void> runMatcher(dart_test.Matcher match) {
    return dart_test.expectLater(actual, createMatcher(match));
  }

  @override
  FutureExpectation<Actual> _copyWith({
    dart_test.Matcher Function(dart_test.Matcher p1)? matcherBuilder,
  }) {
    return FutureExpectation._(actual, matcherBuilder: matcherBuilder);
  }
}

class _RejectFutureExpectation<Actual> extends FutureExpectation<Actual> {
  _RejectFutureExpectation(Future<Actual> actual)
      : super._(actual, matcherBuilder: dart_test.throwsA);
}

class _ResolveFutureExpectation<Actual> extends FutureExpectation<Actual> {
  _ResolveFutureExpectation(Future<Actual> actual)
      : super._(actual, matcherBuilder: dart_test.completion);
}
