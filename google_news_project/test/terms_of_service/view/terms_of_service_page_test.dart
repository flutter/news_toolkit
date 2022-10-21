// ignore_for_file: prefer_const_constructors

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/terms_of_service/terms_of_service.dart';

import '../../helpers/helpers.dart';

void main() {
  const tapMeText = 'Tap Me';

  group('TermsOfServicePage', () {
    group('route', () {
      test('has a route', () {
        expect(TermsOfServicePage.route(), isA<MaterialPageRoute<void>>());
      });

      testWidgets('router returns a valid navigation route', (tester) async {
        await tester.pumpApp(
          Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push<void>(TermsOfServicePage.route());
                  },
                  child: const Text(tapMeText),
                );
              },
            ),
          ),
        );
        await tester.tap(find.text(tapMeText));
        await tester.pumpAndSettle();

        expect(find.byType(TermsOfServicePage), findsOneWidget);
      });
    });

    group('renders', () {
      testWidgets('terms of service page header', (tester) async {
        await tester.pumpApp(TermsOfServicePage());
        expect(find.byType(TermsOfServiceHeader), findsOneWidget);
      });

      testWidgets('terms of service body', (tester) async {
        await tester.pumpApp(TermsOfServicePage());
        expect(find.byType(TermsOfServiceBody), findsOneWidget);
      });
    });

    group('navigates', () {
      testWidgets('back when tapped on back icon', (tester) async {
        await tester.pumpApp(TermsOfServicePage());

        await tester.tap(find.byType(AppBackButton));
        await tester.pumpAndSettle();

        expect(find.byType(TermsOfServicePage), findsNothing);
      });
    });
  });
}
