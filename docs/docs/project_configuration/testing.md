---
sidebar_position: 9
description: Learn how to write and run tests in your application.
---

# Testing

Flutter News Toolkit applications come with 100% test coverage out-of-the-box. Tests are located in a parallel file structure relative to your source code, residing in a `test` directory which mirrors the source code `lib` directory.

Changes you make to your source code such as [implementing an API data source](server_development/connecting_your_data_source), [removing advertisements](/project_configuration/ads#removing-ads), or [changing block behavior](/server_development/blocks) may reduce test coverage or cause existing tests to fail. We recommend maintaining 100% test coverage within your application in order to support stability and scalability, but your application functionality will not be compromised if you forgo 100% test coverage.

To support 100% test coverage in your application, make sure that your tests capture any changes you make to the app behavior. For example, if you implement a new data source `your_data_source.dart`, create a corresponding `your_data_source_test.dart` file which properly tests your new data source's behavior. The Flutter community offers [excellent testing resources](https://verygood.ventures/blog/flutter-testing-resources) to guide you in developing effective tests for your application.
