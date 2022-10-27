# Contributing to Flutter News Example

👍🎉 First off, thanks for taking the time to contribute! 🎉👍

The following is a set of guidelines for contributing to Flutter News Example.
These are mostly guidelines, not rules. Use your best judgment,
and feel free to propose changes to this document in a pull request.

## Commits

We're using [conventional commits](https://www.conventionalcommits.org/en/v1.0.0/), so use following prefixes for your commits:

- **feat**: A new feature
- **fix**: A bug fix
- **chore**: A change that is related to dependencies, imports, format changes - not worth any other prefix
- **build**: Changes that affect the build system or external dependencies
- **ci**: Changes to our CI configuration files and scripts
- **docs**: Documentation only changes
- **perf**: A code change that improves performance
- **refactor**: A code change that neither fixes a bug nor adds a feature
- **style**: Changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc)
- **test**: Adding missing tests or correcting existing tests

## Proposing a Change

If you intend to add a feature, or make any non-trivial changes
to the implementation, we recommend filing an issue.
This lets us reach an agreement on your proposal before you put significant
effort into it.

If you’re only fixing a bug, it’s fine to submit a pull request right away
but we still recommend to file an issue detailing what you’re fixing.
This is helpful in case we don’t accept that specific fix but want to keep
track of the issue.

## Creating a Pull Request

Before creating a pull request please:

1. Fork the repository and create your branch from `main`.
1. Install all dependencies (`flutter packages get` or `pub get`).
1. Squash your commits and ensure you have a meaningful commit message.
1. If you’ve fixed a bug or added code that should be tested, add tests!
   Pull Requests without 100% test coverage will not be approved.
1. Ensure the test suite passes (see `tool/coverage.sh`)
1. If you've changed the public API, make sure to update/add documentation.
1. Format your code (`flutter format --set-exit-if-changed lib test`).
1. Analyze your code (`flutter analyze lib test`).
1. Create the Pull Request and fill the description.
1. Verify that all status checks are passing.

While the prerequisites above must be satisfied prior to having your
pull request reviewed, the reviewer(s) may ask you to complete additional
design work, tests, or other changes before your pull request can be ultimately
accepted.
