## 0.2.3 - 2023-03-08
- Deprecated some error matchers associated with a deprecated error.
- Introducing new matchers (thanks to @dtengeri):
  - toBeNull()
  - toBeFalsy()
  - toBeTruthy()
  - toContain()
  - toHaveLength()
  - containsKey()
  - toBeCloseTo()

## 0.2.2

- Added `contains`, `containsKey`, `containsPair` and `containsAll` matchers (thanks to @trejdych)

## 0.2.1

- **FEAT**: Add support for --coverage (#15). ([f41b0692](https://github.com/invertase/spec/commit/f41b0692de74fba162db2c1dac5d8f8a84dd6524))

## 0.2.0

- Fixed compilation errors when trying to perform expectations on the failure
  of a Future.

- Added support for `expect(value).isA<MyClass>()`

# 0.1.0

- Initial release.
