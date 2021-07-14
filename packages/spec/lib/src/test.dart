import 'package:test/test.dart' as dart_test;
import 'package:meta/meta.dart';

@isTest
void test(String description, void Function() body) {
  dart_test.test(description, body);
}
