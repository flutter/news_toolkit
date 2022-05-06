// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/terms_of_service/terms_of_service.dart';
import 'package:google_news_template/terms_of_service/view/terms_of_service_settings_page.dart';

import '../../helpers/helpers.dart';

void main() {
  group('TermsOfServiceSettingsPage', () {
    group('route', () {
      test('has a route', () {
        expect(TermsOfServiceSettingsPage.route(), isA<MaterialPageRoute>());
      });

      testWidgets('router returns a valid navigation route', (tester) async {
        await tester.pumpApp(
          Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push<void>(TermsOfServiceSettingsPage.route());
                  },
                  child: const Text('Tap me'),
                );
              },
            ),
          ),
        );
        await tester.tap(find.text('Tap me'));
        await tester.pumpAndSettle();

        expect(find.byType(TermsOfServiceSettingsPage), findsOneWidget);
      });
    });

    group('renders', () {
      testWidgets('terms of service settings page header', (tester) async {
        await tester.pumpApp(TermsOfServiceSettingsPage());
        expect(find.byType(TermsOfServiceSettingsHeader), findsOneWidget);
      });

      testWidgets('terms of service body', (tester) async {
        await tester.pumpApp(TermsOfServiceSettingsPage());
        expect(find.byType(TermsOfServiceBody), findsOneWidget);
      });
    });
  });
}
