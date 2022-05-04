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

  group('AppTOSModal', () {
    group('renders', () {
      testWidgets('app tos modal title', (tester) async {
        await tester.pumpApp(
          AppTOSModal(),
        );
        final headerText = find.byKey(tosModalHeaderTitleKey);
        expect(headerText, findsOneWidget);
      });

      testWidgets('app tos modal close button', (tester) async {
        await tester.pumpApp(
          AppTOSModal(),
        );
        final closeButton = find.byKey(tosModalCloseButtonKey);
        expect(closeButton, findsOneWidget);
      });

      testWidgets('app tos modal body', (tester) async {
        await tester.pumpApp(
          AppTOSModal(),
        );
        final body = find.byKey(tosModalBodyKey);
        expect(body, findsOneWidget);
      });
    });
    group('close app tos modal', () {
      testWidgets('when the close icon button is pressed', (tester) async {
        final navigator = MockNavigator();
        when(navigator.pop).thenAnswer((_) async {});
        await tester.pumpApp(
          AppTOSModal(),
          navigator: navigator,
        );
        await tester.tap(find.byKey(tosModalCloseButtonKey));
        await tester.pumpAndSettle();
        verify(navigator.pop).called(1);
      });
    });
  });
}
