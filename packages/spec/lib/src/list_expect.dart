part of 'expect.dart';

/// Matchers for Lists
extension ListExpectation<Return, Param>
    on ExpectationBase<Object?, Return, List<Param>> {
  /// Matches [Iterable]s which contain an element matching every value in
  /// [expected] in any order, and may contain additional values.
  ///
  /// For example: `[0, 1, 0, 2, 0]` matches `containsAll([1, 2])` and
  /// `containsAll([2, 1])` but not `containsAll([1, 2, 3])`.
  ///
  /// Will only match values which implement [Iterable].
  ///
  /// Each element in the value will only be considered a match for a single
  /// matcher in [expected] even if it could satisfy more than one. For instance
  /// `containsAll([greaterThan(1), greaterThan(2)])` will not be satisfied by
  /// `[3]`. To check that all matchers are satisfied within an iterable and allow
  /// the same element to satisfy multiple matchers use
  /// `allOf(matchers.map(contains))`.
  ///
  /// Note that this is worst case O(n^2) runtime and memory usage so it should
  /// only be used on small iterables.
  Return containsAll(List<Param> expected) {
    return runMatcher(dart_test.containsAll(expected));
  }

  /// Returns a matcher that matches if the match argument contains the expected
  /// value.
  ///
  /// For [String]s this means substring matching;
  /// for [Map]s it means the map has the key, and for [Iterable]s
  /// it means the iterable has a matching element. In the case of iterables,
  /// [expected] can itself be a matcher.
  Return contains(Param expected) {
    return runMatcher(dart_test.contains(expected));
  }
}
