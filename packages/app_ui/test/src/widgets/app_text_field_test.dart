// ignore_for_file: prefer_const_constructors

import 'package:app_ui/app_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/helpers.dart';

void main() {
  const appTextFieldSuffixIconKey = Key('appTextField_suffixIcon');

  group('AppTextField', () {
    const hintText = 'Hint';

    testWidgets('has autocorrect set to true', (tester) async {
      await tester.pumpApp(
        AppTextField(),
      );

      final field = tester.widget<AppTextField>(find.byType(AppTextField));
      expect(field.autocorrect, true);
    });

    testWidgets('has hint text', (tester) async {
      await tester.pumpApp(
        AppTextField(
          hintText: hintText,
        ),
      );
      expect(find.text(hintText), findsOneWidget);
    });

    testWidgets('suffix icon is hidden by default', (tester) async {
      await tester.pumpApp(
        AppTextField(),
      );
      final suffixIcon = tester.widget<Visibility>(
        find.descendant(
          of: find.byKey(appTextFieldSuffixIconKey),
          matching: find.byType(Visibility),
        ),
      );
      expect(suffixIcon.visible, isFalse);
    });
  });
}
