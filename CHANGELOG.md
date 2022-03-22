# Change Log

All notable changes to this project will be documented in this file.
See [Conventional Commits](https://conventionalcommits.org) for commit guidelines.

## 2022-03-22

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`spec` - `v0.2.1`](#spec---v021)
 - [`spec_cli` - `v0.1.2+2`](#spec_cli---v0122)

---

#### `spec` - `v0.2.1`

 - **FEAT**: Add support for --coverage (#15). ([f41b0692](https://github.com/invertase/spec/commit/f41b0692de74fba162db2c1dac5d8f8a84dd6524))

#### `spec_cli` - `v0.1.2+2`

 - **REFACTOR**: switch to use built-in string extension methods in `ansi_styles` package (#16). ([695e9692](https://github.com/invertase/spec/commit/695e9692325ec8cd47e09216b8ea7e16f2e26187))
 - **FIX**: set the default column when there is no terminal (#20). ([e6049cba](https://github.com/invertase/spec/commit/e6049cba060ec61d452496c93c2f0cb347b41a9e))


## 2022-02-11

### Changes

---

Packages with breaking changes:

- There are no breaking changes in this release.

Packages with other changes:

- [`spec_cli` - `v0.1.1+1`](#spec_cli---v0111)

---

#### `spec_cli` - `v0.1.1+1`

 - **FIX**: fixes an issue where path to folders ended up not running tests.


## 2022-02-10

### Changes

#### `spec` - `v0.2.0`

- Fixed compilation errors when trying to perform expectations on the failure
  of a Future.

- Added support for `expect(value).isA<MyClass>()`

## 2022-02-03

### Changes

---

Packages with breaking changes:

- There are no breaking changes in this release.

Packages with other changes:

- [`spec_cli` - `v0.1.0+1`](#spec_cli---v0101)

---

#### `spec_cli` - `v0.1.0+1`

 - **FIX**: Add missing newline.

