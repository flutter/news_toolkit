// ignore_for_file: prefer_const_constructors

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/helpers.dart';

void main() {
  group('AppTextField', () {
    const errorText = 'Error';
    const hintText = 'Hint';

    group('email', () {
      testWidgets('has keyboardType set to emailAddress', (tester) async {
        await tester.pumpApp(
          AppEmailField(),
        );

        final field = tester.widget<AppTextField>(find.byType(AppTextField));
        expect(field.keyboardType, TextInputType.emailAddress);
      });

      testWidgets('has autocorrect set to false', (tester) async {
        await tester.pumpApp(
          AppEmailField(),
        );

        final field = tester.widget<AppTextField>(find.byType(AppTextField));
        expect(field.autocorrect, false);
      });

      testWidgets('renders hint text', (tester) async {
        await tester.pumpApp(
          AppEmailField(
            hintText: hintText,
          ),
        );
        expect(find.text(hintText), findsOneWidget);
      });

      testWidgets('renders error text', (tester) async {
        await tester.pumpApp(
          AppEmailField(
            errorText: errorText,
          ),
        );
        expect(find.text(errorText), findsOneWidget);
      });
    });
  });
}
