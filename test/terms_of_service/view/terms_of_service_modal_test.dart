// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/terms_of_service/terms_of_service.dart';
import 'package:mockingjay/mockingjay.dart';

import '../../helpers/helpers.dart';

void main() {
  const termsOfServiceModalCloseButtonKey =
      Key('termsOfServiceModal_closeButton');

  group('TermsOfServiceModal', () {
    group('renders', () {
      testWidgets('terms of service modal header', (tester) async {
        await tester.pumpApp(TermsOfServiceModal());
        expect(find.byType(TermsOfServiceModalHeader), findsOneWidget);
      });

      testWidgets('terms of service modal close button', (tester) async {
        await tester.pumpApp(TermsOfServiceModal());
        final closeButton = find.byKey(termsOfServiceModalCloseButtonKey);
        expect(closeButton, findsOneWidget);
      });

      testWidgets('terms of service body', (tester) async {
        await tester.pumpApp(TermsOfServiceModal());
        expect(find.byType(TermsOfServiceBody), findsOneWidget);
      });
    });

    group('closes terms of service modal', () {
      testWidgets('when the close icon button is pressed', (tester) async {
        final navigator = MockNavigator();
        when(navigator.pop).thenAnswer((_) async {});
        await tester.pumpApp(
          TermsOfServiceModal(),
          navigator: navigator,
        );
        await tester.tap(find.byKey(termsOfServiceModalCloseButtonKey));
        await tester.pumpAndSettle();
        verify(navigator.pop).called(1);
      });
    });
  });
}
