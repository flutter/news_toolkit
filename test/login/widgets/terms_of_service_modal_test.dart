// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/login/login.dart';
import 'package:mockingjay/mockingjay.dart';

import '../../helpers/helpers.dart';

void main() {
  const tosModalHeaderTitleKey = Key('tos_modal_header_title');
  const tosModalCloseButtonKey = Key('tos_modal_close_button');
  const tosModalBodyKey = Key('tos_modal_body_key');

  group('TermsOfServiceModal', () {
    group('renders', () {
      testWidgets('terms of service modal header', (tester) async {
        await tester.pumpApp(TermsOfServiceModal());
        expect(find.byType(TermsOfServiceModalHeader), findsOneWidget);
      });

      testWidgets('terms of service modal close button', (tester) async {
        await tester.pumpApp(TermsOfServiceModal());
        final closeButton = find.byKey(tosModalCloseButtonKey);
        expect(closeButton, findsOneWidget);
      });

      testWidgets('terms of service modal body', (tester) async {
        await tester.pumpApp(TermsOfServiceModal());
        expect(find.byType(TermsOfServiceModalBody), findsOneWidget);
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
        await tester.tap(find.byKey(tosModalCloseButtonKey));
        await tester.pumpAndSettle();
        verify(navigator.pop).called(1);
      });
    });
  });
}
