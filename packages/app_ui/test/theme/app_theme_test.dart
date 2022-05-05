import 'package:app_ui/app_ui.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppTheme', () {
    group('themeData', () {
      group('color', () {
        test('primary is blue', () {
          expect(
            const AppTheme().themeData.primaryColor,
            AppColors.blue,
          );
        });

        test('secondary is lightBlue.shade300', () {
          expect(
            const AppTheme().themeData.colorScheme.secondary,
            AppColors.lightBlue.shade300,
          );
        });
      });

      group('divider', () {
        test('horizontal padding is AppSpacing.lg', () {
          expect(
            const AppTheme().themeData.dividerTheme.indent,
            AppSpacing.lg,
          );
          expect(
            const AppTheme().themeData.dividerTheme.endIndent,
            AppSpacing.lg,
          );
        });

        test('space is AppSpacing.lg', () {
          expect(
            const AppTheme().themeData.dividerTheme.space,
            AppSpacing.lg,
          );
        });
      });
    });
  });

  group('AppDarkTheme', () {
    group('themeData', () {
      group('color', () {
        test('primary is blue', () {
          expect(
            const AppDarkTheme().themeData.primaryColor,
            AppColors.blue,
          );
        });

        test('secondary is lightBlue.shade300', () {
          expect(
            const AppDarkTheme().themeData.colorScheme.secondary,
            AppColors.lightBlue.shade300,
          );
        });

        test('background is grey.shade900', () {
          expect(
            const AppDarkTheme().themeData.backgroundColor,
            AppColors.grey.shade900,
          );
        });
      });

      group('divider', () {
        test('horizontal padding is AppSpacing.lg', () {
          expect(
            const AppTheme().themeData.dividerTheme.indent,
            AppSpacing.lg,
          );
          expect(
            const AppTheme().themeData.dividerTheme.endIndent,
            AppSpacing.lg,
          );
        });

        test('space is AppSpacing.lg', () {
          expect(
            const AppTheme().themeData.dividerTheme.space,
            AppSpacing.lg,
          );
        });
      });
    });
  });
}
