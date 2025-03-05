import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_example/login/login.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockingjay/mockingjay.dart';

import '../../helpers/helpers.dart';

class _MockGoRouterState extends Mock implements GoRouterState {}

class _MockBuildContext extends Mock implements BuildContext {}

void main() {
  const closeIcon = Key('loginWithEmailPage_closeIcon');
  late GoRouterState goRouterState;
  late BuildContext context;

  setUp(() {
    goRouterState = _MockGoRouterState();
    context = _MockBuildContext();
  });

  group('LoginWithEmailPage', () {
    testWidgets('routeBuilder builds a LoginWithEmailPage', (tester) async {
      final page = LoginWithEmailPage.routeBuilder(context, goRouterState);

      expect(page, isA<LoginWithEmailPage>());
    });

    testWidgets('renders LoginWithEmailForm', (tester) async {
      await tester.pumpApp(const LoginWithEmailPage());
      expect(find.byType(LoginWithEmailForm), findsOneWidget);
    });

    group('navigates', () {
      testWidgets('back when left cross icon is pressed', (tester) async {
        final navigator = MockNavigator();
        when(navigator.canPop).thenAnswer((_) => true);
        when(navigator.pop).thenAnswer((_) async {});
        await tester.pumpApp(
          const LoginWithEmailPage(),
          navigator: navigator,
        );
        await tester.tap(find.byKey(closeIcon));
        await tester.pumpAndSettle();
        verify(navigator.pop).called(1);
      });

      testWidgets('back when leading button is pressed', (tester) async {
        final navigator = MockNavigator();
        when(navigator.canPop).thenAnswer((_) => true);
        when(navigator.pop).thenAnswer((_) async {});
        await tester.pumpApp(
          const LoginWithEmailPage(),
          navigator: navigator,
        );
        await tester.tap(find.byType(AppBackButton));
        await tester.pumpAndSettle();
        verify(navigator.pop).called(1);
      });
    });
  });
}
