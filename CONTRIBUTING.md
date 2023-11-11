# Contributing to TypeAheadField

## Create a new issue

The easiest way to get involved is to create a [new issue](https://github.com/AbdulRahmanAlHamali/flutter_typeahead/issues/new) when you spot a bug, if the documentation is incomplete or out of date, or if you identify an implementation problem.

## Modifying Code

If you plan to submit a PR please do the following:

- Fork the repository
- Create a feature branch from the **master** branch!
- Following the coding guidelines below
- Submit the PR against the **master** branch.
- Update both Material and Cupertino code if applicable

## General coding guidelines

If you'd like to add a feature or fix a bug, we're more than happy to accept pull requests! We only ask a few things:

- Ensure your code contains no analyzer errors, e.g.
  - Code is strong-mode compliant
  - Code is free of lint errors
- Format your code with `dartfmt`
- Write helpful documentation
- Write new tests that cover your code base changes
- Make sure all current tests pass
- If you would like to make a bigger / fundamental change to the codebase, please file a lightweight example PR / issue.
- Commit messages should follow [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/).

## Before Publishing

If you are about to publish the package to pub.dev, please make sure that you have done the following:

### Update the changelog.

This is easiest with [cider](https://pub.dev/packages/cider), which follows
the [Keep a Changelog format](https://keepachangelog.com/en/1.0.0/):

```bash
cider log <type> <message>
```

Where `<type>` is one of `added`, `changed`, `deprecated`, `removed`, `fixed`, `security`, and `<message>` is a short description of the change.

### Update the version.

This is easiest with [cider](https://pub.dev/packages/cider) which follows [Semantic Versioning](https://semver.org/):

```bash
cider bump <version>
```

Where `<version>` is one of `major`, `minor`, `patch`, `build`, or a specific version number.

As a reminder:

- patch: backwards-compatible bug fixes
- minor: backwards-compatible new features
- major: backwards-incompatible changes

### Finalize the changelog:

```bash
cider release
```

### Upload the package

Commit your changes for the versio, then upload the package to pub.dev:

```bash
dart pub publish
```
