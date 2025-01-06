// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_news_example/network_error/network_error.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/helpers.dart';

class MockGoRouter extends Mock implements GoRouter {}

void main() {
  const tapMeText = 'Tap Me';
  late GoRouter goRouter;

  setUpAll(() {
    goRouter = MockGoRouter();
    when(() => goRouter.goNamed(NetworkErrorPage.routePath)).thenAnswer((_) {});
  });

  group('NetworkError', () {
    testWidgets('renders correctly', (tester) async {
      await tester.pumpApp(NetworkError());

      expect(find.byType(NetworkError), findsOneWidget);
    });

    testWidgets('navigates to network error page routePath', (tester) async {
      await tester.pumpApp(
        InheritedGoRouter(
          goRouter: goRouter,
          child: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    context.goNamed(NetworkErrorPage.routePath);
                  },
                  child: const Text(tapMeText),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text(tapMeText));

      verify(() => goRouter.goNamed(NetworkErrorPage.routePath)).called(1);
    });
  });

  testWidgets('calls onRetry function when button pressed', (tester) async {
    var retryPressed = false;
    await tester.pumpApp(
      NetworkError(
        onRetry: () {
          retryPressed = true;
        },
      ),
    );

    await tester.tap(find.byType(ElevatedButton));

    expect(retryPressed, isTrue);
  });
}
