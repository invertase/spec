part of 'expect.dart';

/// Matchers for futures
extension FutureExpectationMapper<Actual> on Expectation<Future<Actual>> {
  /// Perform expectations on the value emitted by the future
  FutureExpectation<Actual> get completion => _ResolveFutureExpectation(actual);

  /// Perform expectations on the error thrown by the future
  FutureExpectation<Actual> get throws => _RejectFutureExpectation(actual);

  /// Matches a [Future] that does not complete.
  ///
  /// Note that this creates an asynchronous expectation. The call to
  /// `expect()` that includes this will return immediately and execution will
  /// continue.
  void doesNotComplete() {
    return runMatcher(dart_test.doesNotComplete);
  }
}

/// A class holding matchers for Futures
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
