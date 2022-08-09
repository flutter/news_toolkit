// ignore_for_file: prefer_const_constructors

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/helpers.dart';

void main() {
  group('AppEmailTextField', () {
    const hintText = 'Hint';

    group('email', () {
      testWidgets('has keyboardType set to emailAddress', (tester) async {
        await tester.pumpApp(
          AppEmailTextField(),
        );

        final field = tester.widget<AppTextField>(find.byType(AppTextField));
        expect(field.keyboardType, TextInputType.emailAddress);
      });

      testWidgets('has autocorrect set to false', (tester) async {
        await tester.pumpApp(
          AppEmailTextField(),
        );

        final field = tester.widget<AppTextField>(find.byType(AppTextField));
        expect(field.autocorrect, false);
      });
    });

    group('renders', () {
      testWidgets('hint text', (tester) async {
        await tester.pumpApp(
          AppEmailTextField(
            hintText: hintText,
          ),
        );
        expect(find.text(hintText), findsOneWidget);
      });
    });
  });
}
