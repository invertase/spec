## Dart Test Adapter

`dart_test_adapter` is a package designed to allow executing
`dart test`/`flutter test` using plain Dart code.

It exposes two functions:

```dart
dartTest();
flutterTest();
```

which respectively execute `dart test` or `flutter test`.

Both functions return a `Stream` of events representing the [Dart Test protocol](https://github.com/dart-lang/test/blob/master/pkgs/test/doc/json_reporter.md).

As such, it is possible to write code like:

```dart
dartTest()
    .where((e) => e is TestEventTestStart)
    .cast<TestEventTestStart>()
    .forEach((start) => print(start.test.name));
```

This code will run the tests of a project and print their names as they start.
