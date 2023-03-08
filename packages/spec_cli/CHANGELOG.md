## Unreleased minor

- Added support for `--update-goldens` flag (thanks to @trejdych)

## 0.1.4

- feat: Allow running spec_cli with `dart pub global run spec_cli` (#22)
- upgrade dependencies

## 0.1.3

Upgrade Riverpod dependency

## 0.1.2+2

 - **REFACTOR**: switch to use built-in string extension methods in `ansi_styles` package (#16). ([695e9692](https://github.com/invertase/spec/commit/695e9692325ec8cd47e09216b8ea7e16f2e26187))
 - **FIX**: set the default column when there is no terminal (#20). ([e6049cba](https://github.com/invertase/spec/commit/e6049cba060ec61d452496c93c2f0cb347b41a9e))

## 0.1.2+1

Fixed the minimum Dart version required to match what spec_cli uses (>= 2.16.0)

## 0.1.2

- Added support for `--coverage` to generate a `coverage/lcov.info`
  file in both Dart and Flutter projects.

- Fixed an issue where in `--watch` mode, the elapsed time indicator
  never stopped even after all tests had finished.
 
## 0.1.1+2

 - Update Riverpod dependency

## 0.1.1+1

 - **FIX**: fixes an issue where path to folders ended up not running tests. ([050b3d8a](https://github.com/invertase/spec/commit/050b3d8a413d9b328110b7d2e9efadb8a2201a4a))

## 0.1.1

- **FEAT**: List all errors when the tests complete

## 0.1.0+1

 - **FIX**: Add missing newline. ([14a3b985](https://github.com/invertase/spec/commit/14a3b985b7ee2586ca3b5f1528ef05d22670f75c))

# 0.1.0

- Initial release.