<p align="center">
  <h1>Dart test adapter</h1>
  <span>A package for executing `dart test`/`flutter test` using plain Dart code</span>
</p>

<a href="https://github.com/invertase/melos"><img src="https://img.shields.io/badge/maintained%20with-melos-f700ff.svg?style=flat-square" alt="Melos" /></a>
<a href="https://docs.page"><img src="https://img.shields.io/badge/powered%20by-docs.page-34C4AC.svg?style=flat-square" alt="docs.page" /></a>

<a href="https://github.com/invertase/spec/blob/main/LICENSE">License</a>

`dart_test_adapter` revolves two functions:

```dart
dartTest();
flutterTest();
```

These functions respectively execute `dart test` or `flutter test`.

Both functions return a `Stream` of events representing the [Dart Test protocol](https://github.com/dart-lang/test/blob/master/pkgs/test/doc/json_reporter.md).

As such, it is possible to write code like:

```dart
dartTest()
    .where((e) => e is TestEventTestStart)
    .cast<TestEventTestStart>()
    .forEach((start) => print(start.test.name));
```

This code will run the tests of a project and print their names as they start.

---

<p align="center">
  <a href="https://invertase.io/?utm_source=readme&utm_medium=footer&utm_campaign=spec">
    <img width="75px" src="https://static.invertase.io/assets/invertase/invertase-rounded-avatar.png">
  </a>
  <p align="center">
    Built and maintained by <a href="https://invertase.io/?utm_source=readme&utm_medium=footer&utm_campaign=spec">Invertase</a>.
  </p>
</p>
