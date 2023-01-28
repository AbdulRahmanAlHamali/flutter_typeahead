# Contributing to TypeAheadField

## Create a new issue

The easiest way to get involved is to create a [new issue](https://github.com/AbdulRahmanAlHamali/flutter_typeahead/issues/new) when you spot a bug, if the documentation is incomplete or out of date, or if you identify an implementation problem.

## Modifying Code

If you plan to submit a PR please do the following:

- Fork the repository
- Create a feature branch from the **master** branch!
- Following the coding guidlines below
- Submit the PR against the **master** branch.
- Update both Material and Cupertino code if applicable

## General coding guidlines

If you'd like to add a feature or fix a bug, we're more than happy to accept pull requests! We only ask a few things:

- Ensure your code contains no analyzer errors, e.g.
  - Code is strong-mode compliant
  - Code is free of lint errors
- Format your code with `dartfmt`
- Write helpful documentation
- Write new tests that cover your code base changes
- Make sure all current tests pass
- If you would like to make a bigger / fundamental change to the codebase, please file a lightweight example PR / issue.

## Before Uploading

If you are an uploader here are some additional steps before publishing.

- Update the version:
  - if it is only a bug fix, increase the last digit.
  - if it provides a new feature, increase the middle digit.
  - if it has breaking changes, you should increase the first digit.
- Then, mention all the changes in the CHANGELOG.md.
- Merge into master.
- Upload to Pub Dart.
