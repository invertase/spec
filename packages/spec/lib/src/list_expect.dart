// ignore_for_file: public_member_api_docs

part of 'expect.dart';

extension ListExpectation<Return, Param>
    on ExpectationBase<Object?, Return, List<Param>> {
  Return containsAll(List<Param> expected) {
    return runMatcher(dart_test.containsAll(expected));
  }

  Return contains(Param expected) {
    return runMatcher(dart_test.contains(expected));
  }
}
