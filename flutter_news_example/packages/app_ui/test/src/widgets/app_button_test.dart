// ignore_for_file: prefer_const_literals_to_create_immutables
// ignore_for_file: prefer_const_constructors
// ignore_for_file: avoid_redundant_argument_values

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/helpers.dart';

void main() {
  group('AppButton', () {
    final theme = AppTheme().themeData;
    final buttonTextTheme = theme.textTheme.labelLarge!.copyWith(
      inherit: false,
      leadingDistribution: TextLeadingDistribution.even,
    );

    testWidgets('renders button', (tester) async {
      final buttonText = Text('buttonText');

      await tester.pumpApp(
        Column(
          children: [
            AppButton.black(
              child: buttonText,
            ),
            AppButton.smallOutlineTransparent(
              child: buttonText,
            ),
            AppButton.redWine(
              child: buttonText,
            ),
            AppButton.blueDress(
              child: buttonText,
            ),
          ],
        ),
      );
      expect(find.byType(AppButton), findsNWidgets(4));
      expect(find.text('buttonText'), findsNWidgets(4));
    });

    testWidgets(
        'renders black button '
        'when `AppButton.black()` called', (tester) async {
      final buttonText = Text('buttonText');

      await tester.pumpApp(
        AppButton.black(
          child: buttonText,
          onPressed: () {},
        ),
        theme: theme,
      );

      final finder = find.byType(ElevatedButton);
      final widget = tester.widget(finder) as ElevatedButton;

      expect(
        widget.style?.backgroundColor?.resolve({}),
        AppColors.black,
      );
      expect(
        widget.style?.textStyle?.resolve({}),
        buttonTextTheme,
      );
      expect(
        widget.style?.maximumSize?.resolve({}),
        Size(double.infinity, 56),
      );
      expect(
        widget.style?.minimumSize?.resolve({}),
        Size(double.infinity, 56),
      );
    });

    testWidgets(
        'renders blueDress button '
        'when `AppButton.blueDress()` called', (tester) async {
      final buttonText = Text('buttonText');

      await tester.pumpApp(
        AppButton.blueDress(
          child: buttonText,
          onPressed: () {},
        ),
        theme: theme,
      );

      final finder = find.byType(ElevatedButton);
      final widget = tester.widget(finder) as ElevatedButton;

      expect(
        widget.style?.backgroundColor?.resolve({}),
        AppColors.blueDress,
      );
      expect(
        widget.style?.textStyle?.resolve({}),
        buttonTextTheme,
      );
      expect(
        widget.style?.maximumSize?.resolve({}),
        Size(double.infinity, 56),
      );
      expect(
        widget.style?.minimumSize?.resolve({}),
        Size(double.infinity, 56),
      );
    });

    testWidgets(
        'renders crystalBlue button '
        'when `AppButton.crystalBlue()` called', (tester) async {
      final buttonText = Text('buttonText');

      await tester.pumpApp(
        AppButton.crystalBlue(
          child: buttonText,
          onPressed: () {},
        ),
        theme: theme,
      );

      final finder = find.byType(ElevatedButton);
      final widget = tester.widget(finder) as ElevatedButton;

      expect(
        widget.style?.backgroundColor?.resolve({}),
        AppColors.crystalBlue,
      );
      expect(
        widget.style?.textStyle?.resolve({}),
        buttonTextTheme,
      );
      expect(
        widget.style?.maximumSize?.resolve({}),
        Size(double.infinity, 56),
      );
      expect(
        widget.style?.minimumSize?.resolve({}),
        Size(double.infinity, 56),
      );
    });

    testWidgets(
        'renders redWine button '
        'when `AppButton.redWine()` called', (tester) async {
      final buttonText = Text('buttonText');

      await tester.pumpApp(
        AppButton.redWine(
          child: buttonText,
          onPressed: () {},
        ),
        theme: theme,
      );

      final finder = find.byType(ElevatedButton);
      final widget = tester.widget(finder) as ElevatedButton;

      expect(
        widget.style?.backgroundColor?.resolve({}),
        AppColors.redWine,
      );
      expect(
        widget.style?.textStyle?.resolve({}),
        buttonTextTheme,
      );
      expect(
        widget.style?.maximumSize?.resolve({}),
        Size(double.infinity, 56),
      );
      expect(
        widget.style?.minimumSize?.resolve({}),
        Size(double.infinity, 56),
      );
    });

    testWidgets(
        'renders secondary button '
        'when `AppButton.secondary()` called', (tester) async {
      final buttonText = Text('buttonText');

      await tester.pumpApp(
        AppButton.secondary(
          child: buttonText,
          onPressed: () {},
        ),
        theme: theme,
      );

      final finder = find.byType(ElevatedButton);
      final widget = tester.widget(finder) as ElevatedButton;

      expect(
        widget.style?.backgroundColor?.resolve({}),
        AppColors.secondary,
      );
      expect(
        widget.style?.textStyle?.resolve({}),
        buttonTextTheme,
      );
      expect(
        widget.style?.maximumSize?.resolve({}),
        Size(double.infinity, 40),
      );
      expect(
        widget.style?.minimumSize?.resolve({}),
        Size(0, 40),
      );
    });

    testWidgets(
        'renders darkAqua button '
        'when `AppButton.darkAqua()` called', (tester) async {
      final buttonText = Text('buttonText');

      await tester.pumpApp(
        AppButton.darkAqua(
          child: buttonText,
          onPressed: () {},
        ),
        theme: theme,
      );

      final finder = find.byType(ElevatedButton);
      final widget = tester.widget(finder) as ElevatedButton;

      expect(
        widget.style?.backgroundColor?.resolve({}),
        AppColors.darkAqua,
      );
      expect(
        widget.style?.textStyle?.resolve({}),
        buttonTextTheme,
      );
      expect(
        widget.style?.maximumSize?.resolve({}),
        Size(double.infinity, 56),
      );
      expect(
        widget.style?.minimumSize?.resolve({}),
        Size(double.infinity, 56),
      );
    });

    testWidgets(
        'renders outlinedWhite button '
        'when `AppButton.outlinedWhite()` called', (tester) async {
      final buttonText = Text('buttonText');

      await tester.pumpApp(
        AppButton.outlinedWhite(
          child: buttonText,
          onPressed: () {},
        ),
        theme: theme,
      );

      final finder = find.byType(ElevatedButton);
      final widget = tester.widget(finder) as ElevatedButton;

      expect(
        widget.style?.backgroundColor?.resolve({}),
        AppColors.white,
      );
      expect(
        widget.style?.textStyle?.resolve({}),
        buttonTextTheme,
      );
      expect(
        widget.style?.maximumSize?.resolve({}),
        Size(double.infinity, 56),
      );
      expect(
        widget.style?.minimumSize?.resolve({}),
        Size(double.infinity, 56),
      );
    });

    testWidgets(
        'renders outlinedTransparentDarkAqua button '
        'when `AppButton.outlinedTransparentDarkAqua()` called',
        (tester) async {
      final buttonText = Text('buttonText');

      await tester.pumpApp(
        AppButton.outlinedTransparentDarkAqua(
          child: buttonText,
          onPressed: () {},
        ),
        theme: theme,
      );

      final finder = find.byType(ElevatedButton);
      final widget = tester.widget(finder) as ElevatedButton;

      expect(
        widget.style?.backgroundColor?.resolve({}),
        AppColors.transparent,
      );
      expect(
        widget.style?.textStyle?.resolve({}),
        buttonTextTheme,
      );
      expect(
        widget.style?.maximumSize?.resolve({}),
        Size(double.infinity, 56),
      );
      expect(
        widget.style?.minimumSize?.resolve({}),
        Size(double.infinity, 56),
      );
    });

    testWidgets(
        'renders outlinedTransparentWhite button '
        'when `AppButton.outlinedTransparentWhite()` called', (tester) async {
      final buttonText = Text('buttonText');

      await tester.pumpApp(
        AppButton.outlinedTransparentWhite(
          onPressed: () {},
          child: buttonText,
        ),
        theme: theme,
      );

      final finder = find.byType(ElevatedButton);
      final widget = tester.widget(finder) as ElevatedButton;

      expect(
        widget.style?.backgroundColor?.resolve({}),
        AppColors.transparent,
      );
      expect(
        widget.style?.foregroundColor?.resolve({}),
        AppColors.white,
      );
      expect(
        widget.style?.textStyle?.resolve({}),
        buttonTextTheme,
      );
      expect(
        widget.style?.maximumSize?.resolve({}),
        Size(double.infinity, 56),
      );
      expect(
        widget.style?.minimumSize?.resolve({}),
        Size(double.infinity, 56),
      );
    });

    testWidgets(
        'renders smallRedWine button '
        'when `AppButton.smallRedWine()` called', (tester) async {
      final buttonText = Text('buttonText');

      await tester.pumpApp(
        AppButton.smallRedWine(
          child: buttonText,
          onPressed: () {},
        ),
        theme: theme,
      );

      final finder = find.byType(ElevatedButton);
      final widget = tester.widget(finder) as ElevatedButton;

      expect(
        widget.style?.backgroundColor?.resolve({}),
        AppColors.redWine,
      );
      expect(
        widget.style?.textStyle?.resolve({}),
        buttonTextTheme,
      );
      expect(
        widget.style?.maximumSize?.resolve({}),
        Size(double.infinity, 40),
      );
      expect(
        widget.style?.minimumSize?.resolve({}),
        Size(0, 40),
      );
    });

    testWidgets(
        'renders smallDarkAqua button '
        'when `AppButton.smallDarkAqua()` called', (tester) async {
      final buttonText = Text('buttonText');

      await tester.pumpApp(
        AppButton.smallDarkAqua(
          child: buttonText,
          onPressed: () {},
        ),
        theme: theme,
      );

      final finder = find.byType(ElevatedButton);
      final widget = tester.widget(finder) as ElevatedButton;

      expect(
        widget.style?.backgroundColor?.resolve({}),
        AppColors.darkAqua,
      );
      expect(
        widget.style?.textStyle?.resolve({}),
        buttonTextTheme,
      );
      expect(
        widget.style?.maximumSize?.resolve({}),
        Size(double.infinity, 40),
      );
      expect(
        widget.style?.minimumSize?.resolve({}),
        Size(0, 40),
      );
    });

    testWidgets(
        'renders smallTransparent button '
        'when `AppButton.smallTransparent()` called', (tester) async {
      final buttonText = Text('buttonText');

      await tester.pumpApp(
        AppButton.smallTransparent(
          child: buttonText,
          onPressed: () {},
        ),
        theme: theme,
      );

      final finder = find.byType(ElevatedButton);
      final widget = tester.widget(finder) as ElevatedButton;

      expect(
        widget.style?.backgroundColor?.resolve({}),
        AppColors.transparent,
      );
      expect(
        widget.style?.textStyle?.resolve({}),
        buttonTextTheme,
      );
      expect(
        widget.style?.maximumSize?.resolve({}),
        Size(double.infinity, 40),
      );
      expect(
        widget.style?.minimumSize?.resolve({}),
        Size(0, 40),
      );
    });

    testWidgets(
        'renders smallOutlineTransparent button '
        'when `AppButton.smallOutlineTransparent()` called', (tester) async {
      final buttonText = Text('buttonText');

      await tester.pumpApp(
        AppButton.smallOutlineTransparent(
          child: buttonText,
          onPressed: () {},
        ),
        theme: theme,
      );

      final finder = find.byType(ElevatedButton);
      final widget = tester.widget(finder) as ElevatedButton;

      expect(
        widget.style?.backgroundColor?.resolve({}),
        AppColors.transparent,
      );
      expect(
        widget.style?.textStyle?.resolve({}),
        buttonTextTheme,
      );
      expect(
        widget.style?.maximumSize?.resolve({}),
        Size(double.infinity, 40),
      );
      expect(
        widget.style?.minimumSize?.resolve({}),
        Size(0, 40),
      );
    });

    testWidgets(
        'renders transparentDarkAqua button '
        'when `AppButton.transparentDarkAqua()` called', (tester) async {
      final buttonText = Text('buttonText');

      await tester.pumpApp(
        AppButton.transparentDarkAqua(
          onPressed: () {},
          child: buttonText,
        ),
        theme: theme,
      );

      final finder = find.byType(ElevatedButton);
      final widget = tester.widget(finder) as ElevatedButton;

      expect(
        widget.style?.backgroundColor?.resolve({}),
        AppColors.transparent,
      );
      expect(
        widget.style?.foregroundColor?.resolve({}),
        AppColors.darkAqua,
      );
      expect(
        widget.style?.textStyle?.resolve({}),
        buttonTextTheme,
      );
      expect(
        widget.style?.maximumSize?.resolve({}),
        Size(double.infinity, 56),
      );
      expect(
        widget.style?.minimumSize?.resolve({}),
        Size(double.infinity, 56),
      );
    });

    testWidgets(
        'renders transparentWhite button '
        'when `AppButton.transparentWhite()` called', (tester) async {
      final buttonText = Text('buttonText');

      await tester.pumpApp(
        AppButton.transparentWhite(
          onPressed: () {},
          child: buttonText,
        ),
        theme: theme,
      );

      final finder = find.byType(ElevatedButton);
      final widget = tester.widget(finder) as ElevatedButton;

      expect(
        widget.style?.backgroundColor?.resolve({}),
        AppColors.transparent,
      );
      expect(
        widget.style?.foregroundColor?.resolve({}),
        AppColors.white,
      );
      expect(
        widget.style?.textStyle?.resolve({}),
        buttonTextTheme,
      );
      expect(
        widget.style?.maximumSize?.resolve({}),
        Size(double.infinity, 56),
      );
      expect(
        widget.style?.minimumSize?.resolve({}),
        Size(double.infinity, 56),
      );
    });

    testWidgets(
        'renders disabled transparentWhite button '
        'when `AppButton.transparentWhite()` called '
        'with onPressed equal to null', (tester) async {
      final buttonText = Text('buttonText');

      await tester.pumpApp(
        AppButton.transparentWhite(
          onPressed: null,
          child: buttonText,
        ),
        theme: theme,
      );

      final finder = find.byType(ElevatedButton);
      final widget = tester.widget(finder) as ElevatedButton;

      expect(
        widget.style?.backgroundColor?.resolve({}),
        AppColors.transparent,
      );
      expect(
        widget.style?.foregroundColor?.resolve({}),
        AppColors.white,
      );
      expect(
        widget.style?.textStyle?.resolve({}),
        buttonTextTheme,
      );
      expect(
        widget.style?.maximumSize?.resolve({}),
        Size(double.infinity, 56),
      );
      expect(
        widget.style?.minimumSize?.resolve({}),
        Size(double.infinity, 56),
      );
    });

    testWidgets(
        'changes background color to AppColors.black.withOpacity(.12)  '
        'when `onPressed` is null', (tester) async {
      final buttonText = Text('buttonText');

      await tester.pumpApp(
        AppButton.smallOutlineTransparent(
          child: buttonText,
        ),
        theme: theme,
      );

      final finder = find.byType(ElevatedButton);
      final widget = tester.widget(finder) as ElevatedButton;

      expect(
        widget.style?.backgroundColor?.resolve({}),
        AppColors.black.withOpacity(.12),
      );
    });
  });
}
