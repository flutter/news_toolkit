---
sidebar_position: 3
description: Learn how to write and run tests for your API.
---

# Testing

The Flutter News Toolkit server comes with 100% test coverage out-of-the-box. Tests are located in a parallel file structure relative to your server source code, residing in the `api/test` directory which mirrors the `api/lib` and `api/routes` directories. Tests are automatically run on your server codebase using [Very Good Workflows](https://github.com/VeryGoodOpenSource/very_good_workflows).

Server tests are written in pure Dart and do not test any Flutter functionality. These tests will evaluate the routes, middleware, and any additional classes and functions implemented in the `api/lib` folder.

Changes you make to your server such as [implementing an API data source](connecting_your_data_source) may reduce test coverage or cause existing tests to fail. We recommend maintaining 100% test coverage within your server in order to support stability and scalability.

To support 100% test coverage in your server, make sure that your tests capture any changes you make to the server behavior. For example, if you implement a new data source `your_data_source.dart`, create a corresponding `your_data_source_test.dart` file which properly tests your new data source's behavior.

:::info
See the [Dart Frog testing documentation](https://dartfrog.vgv.dev/docs/basics/testing) for information on testing Dart Frog servers.
:::
