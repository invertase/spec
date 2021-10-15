import 'package:flutter_test/flutter_test.dart';

void main() {
  test('pass immediately', () {});

  group('group', () {
    test('a', () async {
      await Future.delayed(const Duration(seconds: 5));
    });
    // test('wait 5 sec then fails', () async {
    //   await Future.delayed(const Duration(seconds: 5));
    //   throw StateError('This is an error');
    // });
  });

  group('group', () {
    test('a', () {});
  });

  test('wait 2 sec then pass', () async {
    await Future.delayed(const Duration(seconds: 2));
  });
}
