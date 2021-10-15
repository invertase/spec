import 'package:flutter_test/flutter_test.dart';

void main() {
  test('sync', () {});
  test('pass after 1 sec', () async {
    await Future.delayed(const Duration(seconds: 1));
  });
}
