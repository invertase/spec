<p align="center">
  <h1>✅ Spec</h1>
  <span>A streamlined testing framework for Dart & Flutter.</span>
</p>

<a href="https://github.com/invertase/melos"><img src="https://img.shields.io/badge/maintained%20with-melos-f700ff.svg?style=flat-square" alt="Melos" /></a>
<a href="https://docs.page"><img src="https://img.shields.io/badge/powered%20by-docs.page-34C4AC.svg?style=flat-square" alt="docs.page" /></a>

Spec builds on-top of existing Dart & Flutter testing tools to provide a streamlined & elegant testing environment. Spec provides both a CLI tool
and Dart package.

- [Documentation](https://docs.page/invertase/spec)

### CLI

The Spec CLI allows you to run the `spec` command from your CLI environment and run your tests:

- Intuitive testing output interface, inspired by [Jest](https://jestjs.io/).
- Interactive CLI; automatically re-run tests when source code changes & rerunning of only failed tests.
- Run both Dart & Flutter tests in parallel with a single command.
- Run tests from multiple packages at the same time using [Melos](https://github.com/invertase/melos).

### Package

The `spec` package provides a different take on how to write tests. Designed with type-safety and IDE autocompletion in mind, spec alters the way you
write your tests to be more declarative, less error prone and force good habits.

```dart
test('dart test example', () async {
  int value = 42;

  // Without spec - not type safe
  expect(value, equals(42));
  await expectLater(Future.value(42), completion(equals(42)));

  // With spec - type safe
  expect(value).toEqual(42);
  await expect(Future.value(42)).completion.toEqual(42);
});
```

---

[LICENSE](/LICENSE)

<p align="center">
  <a href="https://invertase.io/?utm_source=readme&utm_medium=footer&utm_campaign=spec">
    <img width="75px" src="https://static.invertase.io/assets/invertase/invertase-rounded-avatar.png">
  </a>
  <p align="center">
    Built and maintained by <a href="https://invertase.io/?utm_source=readme&utm_medium=footer&utm_campaign=spec">Invertase</a>.
  </p>
</p>
