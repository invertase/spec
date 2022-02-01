<p align="center">
  <h1>✅ Spec</h1>
  <span>A Dart & Flutter testing framework inspired from Jest.</span>
</p>

<a href="https://github.com/invertase/melos"><img src="https://img.shields.io/badge/maintained%20with-melos-f700ff.svg?style=flat-square" alt="Melos" /></a>
<a href="https://docs.page"><img src="https://img.shields.io/badge/powered%20by-docs.page-34C4AC.svg?style=flat-square" alt="docs.page" /></a>

<a href="https://github.com/invertase/spec/blob/main/LICENSE">License</a>

Welcome to Spec!  
Spec is a different take on how to write tests,
designed with type-safety and IDE auto-completion in mind.

Long story short, Spec changes the syntax for writing expectations in Dart.  
Normally, you would write:

```dart
test('my test', () {
  int value = ...;

  expect(value, equals(42));
});
```

But with Spec, `expect` works differently. We would instead write:

```dart
test('my test', () {
  int value = ...;

  expect(value).toEqual(42);
});
```

The benefits are multiple:

- matchers are now type-safe. As such, if we tried to do:

  ```dart
  test('my test', () {
    expect(0).toEqual('string');
  });
  ```

  then we will get a compilation error, as this test does not make sense.

- it is no-longer necessary to differentiate `expect` and `expectLater`.
  If an expectation is asynchronous, it will return a `Future` which we can await:

  ```dart
  test('my test', () async {
    // Verify that the future emits the value "42"
    await expect(Future.value(42)).completion.toEqual(42);
  });
  ```

- the IDE auto-completion is empowered, as it will suggests us matchers
  that make the most sense for the value we're trying to test:

  ![Auto-complete example](https://raw.githubusercontent.com/invertase/spec/main/packages/spec/resources/auto-complete.png)
