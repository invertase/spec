part of 'expect.dart';

/// Matchers for [Stream]s
extension StreamExpectationExt<Actual> on Expectation<Stream<Actual>> {
  /// Perform expectations on the next value emitted by the stream
  StreamExpectation<Actual> get emits {
    return _EmitsStreamExpectation(actual);
  }

  /// Perform expectations on the next error emitted by the stream
  StreamExpectation<Actual> get emitsError {
    return _EmitsErrorStreamExpectation(actual);
  }

  /// Expects that the stream emits a done event
  Future<void> emitsDone() {
    return dart_test.expectLater(actual, dart_test.emitsDone);
  }
}

/// A class exposing custom expectations for streams
class StreamExpectation<Actual>
    extends ExpectationBase<Stream<Actual>, Future<void>, Actual> {
  StreamExpectation._(
    Stream<Actual> actual, {
    dart_test.Matcher Function(dart_test.Matcher)? matcherBuilder,
  }) : super(actual, matcherBuilder: matcherBuilder);

  @override
  Future<void> runMatcher(dart_test.Matcher match) {
    return dart_test.expectLater(actual, createMatcher(match));
  }

  @override
  StreamExpectation<Actual> _copyWith({
    dart_test.Matcher Function(dart_test.Matcher p1)? matcherBuilder,
  }) {
    return StreamExpectation._(actual, matcherBuilder: matcherBuilder);
  }
}

class _EmitsStreamExpectation<Actual> extends StreamExpectation<Actual> {
  _EmitsStreamExpectation(Stream<Actual> actual)
      : super._(actual, matcherBuilder: dart_test.emits);
}

class _EmitsErrorStreamExpectation<Actual> extends StreamExpectation<Actual> {
  _EmitsErrorStreamExpectation(Stream<Actual> actual)
      : super._(actual, matcherBuilder: dart_test.emitsError);
}
