import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/helpers.dart';

void main() {
  group('ContentThemeOverrideBuilder', () {
    final theme = const AppTheme().themeData;

    testWidgets('overrides the text theme to AppTheme.contentTextTheme',
        (tester) async {
      late BuildContext capturedContext;

      await tester.pumpApp(
        Builder(
          builder: (context) {
            capturedContext = context;
            return const SizedBox();
          },
        ),
        theme: theme,
      );

      expect(
        Theme.of(capturedContext).textTheme.labelLarge,
        equals(
          theme.textTheme.labelLarge!.copyWith(
            inherit: false,
            leadingDistribution: TextLeadingDistribution.even,
          ),
        ),
      );

      await tester.pumpApp(
        ContentThemeOverrideBuilder(
          builder: (context) {
            capturedContext = context;
            return const SizedBox();
          },
        ),
        theme: theme,
      );

      expect(
        Theme.of(capturedContext).textTheme.labelLarge,
        equals(
          AppTheme.contentTextTheme.labelLarge!.copyWith(
            inherit: false,
            leadingDistribution: TextLeadingDistribution.even,
          ),
        ),
      );
    });
  });
}
