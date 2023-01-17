---
sidebar_position: 3
description: Learn how to write and run tests in your application.
---

# Testing

Flutter News Toolkit applications come with 100% test coverage out of the box. Tests are located in a parallel file structure relative to your source code, residing in a `test` directory that mirrors the source code `lib` directory. Tests are automatically run on your app using [Very Good Workflows](https://github.com/VeryGoodOpenSource/very_good_workflows).

Changes made to your source code, such as [removing advertisements](/project_configuration/ads#removing-ads), might reduce test coverage or cause existing tests to fail. We recommend maintaining 100% test coverage within your application to support stability and scalability, but your application functionality won't be compromised if you forgo 100% test coverage.

To support 100% test coverage in your application, ensure that your tests capture any changes you make to the app behavior. For example, if you implement a new widget, `your_widget.dart`, create a corresponding `your_widget_test.dart` file that properly tests the new widget's behavior.

Your Flutter app's test suite contains [bloc, unit, and widget tests](https://docs.flutter.dev/testing).

:::info
The Flutter community offers [excellent testing resources](https://verygood.ventures/blog/flutter-testing-resources) to guide you in developing effective tests for your application.
:::

## Unit tests

Unit tests evaluate a single method, function, or class within your codebase. You should test that your unit behaves appropriately under all conditions under which it might be executed.

For example, `news_repository_test.dart` tests whether the `NewsRepository` class can be instantiated, handle error cases correctly, and correctly execute its behavior under both success and error conditions.

:::info
Flutter's [Introduction to unit testing](https://docs.flutter.dev/cookbook/testing/unit/introduction) recipe provides further information on unit testing.
:::

## Widget tests

Widget tests verify that a single widget behaves correctly within the Flutter framework using a testing environment that enables UI interactions and behaviors.

For example the following test from `bottom_nav_bar_test.dart` checks that the proper behavior is executed when the user interacts with the `BottomNavBar` widget:

```dart
testWidgets('calls onTap when navigation bar item is tapped', (tester) async {
    final completer = Completer<void>();

    await tester.pumpApp(
        Scaffold(
        body: Container(),
        bottomNavigationBar: BottomNavBar(
            currentIndex: 0,
            onTap: (value) => completer.complete(),
        ),
        ),
    );
    await tester.ensureVisible(find.byType(BottomNavigationBar));
    await tester.tap(find.byIcon(Icons.home_outlined));
    expect(completer.isCompleted, isTrue);
});
```

:::info
Flutter's [Introduction to widget testing](https://docs.flutter.dev/cookbook/testing/widget/introduction) recipe provides further information on widget testing.
:::

## Bloc tests

Bloc tests verify that your app's [bloc state management library](https://bloclibrary.dev) behaves as expected under a variety of conditions.

A bloc test sets up the test's initial conditions, instantiates the block, and tests whether the bloc behaves as expected. The following test from `analytics_bloc_test.dart` checks whether the `AnalyticsBloc` responds appropriately to user authentication:

```dart
blocTest<AnalyticsBloc, AnalyticsState>(
    'calls AnalyticsRepository.setUserId '
    'with user id when user is authenticated',
    setUp: () => when(() => userRepository.user)
        .thenAnswer((_) => Stream.value(user)),
    build: () => AnalyticsBloc(
        analyticsRepository: analyticsRepository,
        userRepository: userRepository,
    ),
    verify: (_) {
        verify(() => analyticsRepository.setUserId(user.id)).called(1);
    },
);
```

The test above verifies that a mocked repository is called correctly. Depending on what bloc behavior you are testing, bloc tests can also verify that an error is thrown or that the bloc's state is correct.

:::info
The [bloc library testing documentation](https://bloclibrary.dev/#/testing) provides a thorough introduction to testing blocs.
:::
