@TestOn('android')
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('sync', () {});

  group('group', () {
    test('fails after 2 sec', () async {
      await Future.delayed(const Duration(seconds: 2));
      throw StateError('This is an error');
    });
  });

  test('pass after 1 sec', () async {
    await Future.delayed(const Duration(seconds: 1));
  });

  test('bar', () {});
}
