<p align="center">
  <h1>✅ Spec CLI</h1>
  <span>A command line inspired from Jest for executing Dart/Flutter tests</span>
</p>

<a href="https://github.com/invertase/melos"><img src="https://img.shields.io/badge/maintained%20with-melos-f700ff.svg?style=flat-square" alt="Melos" /></a>
<a href="https://docs.page"><img src="https://img.shields.io/badge/powered%20by-docs.page-34C4AC.svg?style=flat-square" alt="docs.page" /></a>

<a href="https://github.com/invertase/spec/blob/main/LICENSE">License</a>

---

`Spec` is a command-line built on top of the official `dart test`/`flutter test`
to add new features such as:

- an improved interface inspired from [Jest](https://jestjs.io/)
- a `--watch` flag, for re-executing test whenever the sources changes
- during watch mode, offer a way to re-execute only failing tests
- supporting both Dart and Flutter projects using the same command
- support for running tests of multiple packages at the same time by using [Melos](https://github.com/invertase/melos)

![Spec gif example](https://raw.githubusercontent.com/invertase/spec/main/packages/spec_cli/resources/render.gif)

## Installation

To install `spec`, run:

```sh
dart pub global activate spec_cli
```

You should now be able to run:

```dart
spec --help
```

## Usage

To run tests in a Dart/Flutter project, simply run:

```sh
spec
```

You can optionally filter tests by name using `--name`:

```sh
spec --name "My test"
```

Alternatively, you can execute specific tests by specifying their path:

```sh
spec test/my_test.dart
```

## Watch mode

By specifying `--watch`, spec will enter in watch mode and will listen to file
changes.  
In this mode, Spec will re-run the tests whenever a file change in the project
is detected.

While in watch mode, it is possible to perform extraneous operations during tests:

- By pressing "enter", this will manually stop/restart the tests
- By pressing `f`, Spec will filter tests to execute only failing tests, skipping
  tests that were passing in the previous run.
- When typing `t`, it is possible to update the `--name` filter flag without
  having to restart Spec.

---

<p align="center">
  <a href="https://invertase.io/?utm_source=readme&utm_medium=footer&utm_campaign=spec">
    <img width="75px" src="https://static.invertase.io/assets/invertase/invertase-rounded-avatar.png">
  </a>
  <p align="center">
    Built and maintained by <a href="https://invertase.io/?utm_source=readme&utm_medium=footer&utm_campaign=spec">Invertase</a>.
  </p>
</p>
