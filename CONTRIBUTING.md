# Contributing

## Issues

If you have spotted a bug, found inconsistent documentation, or have a feature request, please create a [new issue](https://github.com/AbdulRahmanAlHamali/flutter_typeahead/issues/new).

Even if you would like to submit a PR, please create an issue first so that we can discuss the problem or feature.

## Contributing Code

If you'd like to add a feature or fix a bug, we're happy to accept pull requests!

Before starting to work on a PR, please make sure you have created a comprehensive issue. Additionally, please check existing documentation and code to make sure that your feature or bug is not already addressed.

We wish to avoid making the package too complicated.
Flutter offers many ways of configuring Widgets downstream through context, so please consider whether your feature can be implemented in a way that does not require changes to the package (e.g. through a Theme or other InheritedWidget).

We also prefer builders or callbacks over configuration objects. Objects which do not need to be strictly managed, should be created by the user and passed in (e.g TextFields, TextEditingControllers, etc).

Lastly, we try to follow general standards, so we do not wish to add very specific features or non-standard behavior for internally used widgets.

## Style

For new code, please ensure:

- code is formatted with `dartfmt`
- code has no linter warnings or errors
- code is well documented
- code is well tested (preferably at 100% coverage)
- all existing tests pass
- examples are updated if necessary
- changes work for both Material and Cupertino
- changes are added to the CHANGELOG.md file in Keep a Changelog format
  (You can use [cider](https://pub.dev/packages/cider) to help with this)
- commit messages follow [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/).

## Publishing

If you are about to publish the package to `pub.dev`, please make sure that you have done the following:

### Update the changelog.

This is easiest with [cider](https://pub.dev/packages/cider), which follows
the [Keep a Changelog format](https://keepachangelog.com/en/1.0.0/):

```bash
cider log <type> '<message>'
```

Where `<type>` is one of `added`, `changed`, `deprecated`, `removed`, `fixed`, `security`, and `<message>` is a short description of the change.

### Update the version

This is easiest with [cider](https://pub.dev/packages/cider) which follows [Semantic Versioning](https://semver.org/):

```bash
cider bump <version>
```

Where `<version>` is one of `major`, `minor`, `patch`, `build`, or a specific version number.

As a reminder:

- patch: backwards-compatible bug fixes
- minor: backwards-compatible new features
- major: backwards-incompatible changes

### Finalize the changelog

Update the changelog to change from Unreleased to the new version:

```bash
cider release
```

### Upload the package

Commit your changes for the versio, then upload the package to pub.dev:

```bash
dart pub publish
```
