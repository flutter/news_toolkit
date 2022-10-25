import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/login/login.dart';
import 'package:mockingjay/mockingjay.dart';

import '../../helpers/helpers.dart';

void main() {
  const closeIcon = Key('loginWithEmailPage_closeIcon');

  group('LoginWithEmailPage', () {
    test('has a route', () {
      expect(LoginWithEmailPage.route(), isA<MaterialPageRoute<void>>());
    });

    testWidgets('renders LoginWithEmailForm', (tester) async {
      await tester.pumpApp(const LoginWithEmailPage());
      expect(find.byType(LoginWithEmailForm), findsOneWidget);
    });

    group('navigates', () {
      testWidgets('back when left cross icon is pressed', (tester) async {
        final navigator = MockNavigator();
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
