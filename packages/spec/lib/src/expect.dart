import 'dart:async';

import 'package:meta/meta.dart';
import 'package:test/test.dart' as dart_test;

part 'bool_expect.dart';
part 'error_expect.dart';
part 'function_expect.dart';
part 'future_expect.dart';
part 'num_expect.dart';
part 'stream_expect.dart';
part 'string_expect.dart';

Expectation<Actual> expect<Actual>(Actual value) {
  return Expectation._(value);
}

abstract class ExpectationBase<Actual, Return, Param> {
  ExpectationBase(
    this.actual, {
    dart_test.Matcher Function(dart_test.Matcher)? matcherBuilder,
  }) : _matcherBuilder = matcherBuilder ?? ((matcher) => matcher);

  final Actual actual;

  final dart_test.Matcher Function(dart_test.Matcher) _matcherBuilder;

  /// Expect that [actual] matches with a Matcher from the Dart SDK.
  @protected
  Return runMatcher(dart_test.Matcher match);

  @protected
  ExpectationBase<Actual, Return, Param> _copyWith({
    dart_test.Matcher Function(dart_test.Matcher)? matcherBuilder,
  });

  /// Apply transformations to a matcher.
  @protected
  dart_test.Matcher createMatcher(dart_test.Matcher match) {
    return _matcherBuilder(match);
  }

  /// Reverse the expectation
  ExpectationBase<Actual, Return, Param> get not => _copyWith(
        matcherBuilder: (matcher) => dart_test.isNot(_matcherBuilder(matcher)),
      );

  /// Compares [actual] with [expected] using [identical].
  Return toBe(Param expected) {
    return runMatcher(
      createMatcher(dart_test.same(expected)),
    );
  }

  /// Compares [actual] with [expected] using the operator `==`.
  Return toEqual(Param expected) {
    return runMatcher(
      createMatcher(dart_test.equals(expected)),
    );
  }

  Return isNull() {
    return runMatcher(
      createMatcher(dart_test.isNull),
    );
  }

  Return toMatch(Pattern pattern) {
    return runMatcher(
      createMatcher(dart_test.matches(pattern)),
    );
  }
}

@sealed
class Expectation<Actual> extends ExpectationBase<Actual, void, Actual> {
  Expectation._(
    Actual actual, {
    dart_test.Matcher Function(dart_test.Matcher)? matcherBuilder,
  }) : super(actual, matcherBuilder: matcherBuilder);

  @override
  void runMatcher(dart_test.Matcher match) {
    runMatcher(createMatcher(match));
  }

  @override
  ExpectationBase<Actual, void, Actual> _copyWith({
    dart_test.Matcher Function(dart_test.Matcher)? matcherBuilder,
  }) {
    // TODO: implement _copyWith
    throw UnimplementedError();
  }
}
