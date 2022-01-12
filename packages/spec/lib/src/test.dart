import 'package:meta/meta.dart';
import 'package:test/test.dart' as dart_test;

@isTest
void test(String description, void Function() body) {
  dart_test.test(description, body);
}
