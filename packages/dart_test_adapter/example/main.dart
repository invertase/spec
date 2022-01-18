// ignore_for_file: avoid_print

import 'package:dart_test_adapter/dart_test_adapter.dart';

void main() {
  dartTest()
      .where((e) => e is TestEventTestStart)
      .cast<TestEventTestStart>()
      .forEach((start) => print(start.test.name));
}
