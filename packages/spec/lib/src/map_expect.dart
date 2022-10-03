// ignore_for_file: public_member_api_docs

part of 'expect.dart';

extension MapExpectationX<Return, KeyParam, ValueParam> on ExpectationBase<
    Map<KeyParam, ValueParam>, Return, Map<KeyParam, ValueParam>> {
  Return containsPair(KeyParam key, ValueParam value) {
    return runMatcher(dart_test.containsPair(key, value));
  }

  Return containsKey(KeyParam key) {
    return runMatcher(dart_test.containsPair(key, dart_test.anything));
  }
}
