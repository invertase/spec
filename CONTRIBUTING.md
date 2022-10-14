# Contribution Guidelines

**Note:** If these contribution guidelines are not followed your issue or PR might be closed, so
please read these instructions carefully.

_See also: [Invertases's code of conduct](https://github.com/invertase/meta/blob/main/CODE_OF_CONDUCT.md)_

## About

Spec is a streamlined testing framework for Dart & Flutter

## Contribution types

### Bug Report

- If you find a bug, please first report it using [GitHub issues](https://github.com/invertase/spec/issues/new).
  - First check if there is not already an issue for it; duplicated issues will be closed.

### Bug Fix

- If you'd like to submit a fix for a bug, please read the [How To](#how-to-contribute) for how to send a pull request.
- Indicate on the open issue that you are working on fixing the bug and the issue will be assigned to you.
- Write `Fix #xxxx` in your PR text, where xxxx is the issue number (if there is one).
- Include a test that isolates the bug and verifies that it was fixed.

### New Features

- If you'd like to add a feature to the library that doesn't already exist, feel free to describe the feature in a new [GitHub issue](https://github.com/invertase/spec/issues/new).
- If you'd like to implement the new feature, please wait for feedback from the project maintainers before spending too much time writing the code. In some cases, enhancements may not align well with the project future development direction.
- If applicable, implement the code for the new feature and please read the [How To](#how-to-contribute).

### Documentation & Miscellaneous

- If you have suggestions for improvements to the documentation or examples (or something else), we would love to hear about it.
- As always first file a [GitHub issue](https://github.com/invertase/spec/issues/new).
- Implement the changes to the documentation, please read the [How To](#how-to-contribute).

## How To Contribute

### Requirements

- Linux, Mac OS X, or Windows.
- [Git](https://git-scm.com) (used for source version control).
- An IDE such as [Android Studio](https://developer.android.com/studio) or [Visual Studio Code](https://code.visualstudio.com/).

### Forking & cloning the repository

- Ensure all the dependencies described in the previous section are installed.
- Fork `https://github.com/invertase/spec` into your own GitHub account. If
  you already have a fork, and are now installing a development environment on
  a new machine, make sure you've updated your fork so that you don't use stale
  configuration options from long ago.
- `git clone git@github.com:<your_name_here>/spec.git`
- `git remote add upstream git@github.com:invertase/spec.git` (So that you
  fetch from the main repository, not your clone, when running `git fetch` or `git pull`

### Local development setup

To setup and use this spec repo locally for the purposes of contributing, clone it and run the following commands from the root of the repository:

#### Installation

```bash
# Install spec_cli if it's not already installed:
dart pub global activate spec_cli
```


#### Usage

**Run tests**:

```bash
spec
```

**Run tests in interactive mode**:

```bash
spec --watch
```

Interactive mode supports a number of keyboard shortcuts:

```
Watch Usage:
 › Press f to run only failed tests.
 › Press t to filter by a test name regex pattern.
 › Press q to quit watch mode.
 › Press Enter to trigger a test run.
```

### Performing changes

- Create a new local branch from `main` (e.g. `git checkout -b my-new-feature`)
- Make your changes (try to split them up with one PR per feature/fix).
- When committing your changes, make sure that each commit message is clear
 (e.g. `git commit -m 'docs: Add CONTRIBUTING.md'`).
- Push your new branch to your own fork into the same remote branch
 (e.g. `git push origin my-username.my-new-feature`, replace `origin` if you use another remote.)

### Open a pull request

To send us a pull request:

- Go to `https://github.com/invertase/spec` and click the
  "Compare & pull request" button

Please make sure all your check-ins have detailed commit messages explaining the patch.

When naming the title of your pull request, please follow the [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0-beta.4/)
guide. 

Please also enable **“Allow edits by maintainers”**, this will help to speed-up the review process as well.
