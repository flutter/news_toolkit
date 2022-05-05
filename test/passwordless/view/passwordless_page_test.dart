// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/passwordless/passwordless.dart';
import 'package:mockingjay/mockingjay.dart';

import '../../helpers/helpers.dart';

void main() {
  const testEmail = 'testEmail@gmail.com';
  const passwordlessCloseIconKey = Key('passwordless_closeIcon');

  group('PasswordLess Page', () {
    test('has a route', () {
      expect(
        PasswordlessPage.route(email: testEmail),
        isA<MaterialPageRoute>(),
      );
    });

    testWidgets('renders a PasswordlessView', (tester) async {
      await tester.pumpApp(
        const PasswordlessPage(email: testEmail),
      );
      expect(find.byType(PasswordlessView), findsOneWidget);
    });

    testWidgets('router returns a valid navigation route', (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .push<void>(PasswordlessPage.route(email: testEmail));
                },
                child: const Text('Tap me'),
              );
            },
          ),
        ),
      );
      await tester.tap(find.text('Tap me'));
      await tester.pumpAndSettle();

      expect(find.byType(PasswordlessPage), findsOneWidget);
    });

    group('navigates', () {
      testWidgets('when pressed on close icon', (tester) async {
        final navigator = MockNavigator();

        when(() => navigator.popUntil(any())).thenAnswer((_) async {});
        await tester.pumpApp(
          const PasswordlessPage(email: testEmail),
          navigator: navigator,
        );

        await tester.tap(find.byKey(passwordlessCloseIconKey));
        await tester.pumpAndSettle();
        verify(() => navigator.popUntil(any())).called(1);
      });
    });
  });
}
