import 'package:app_ui/app_ui.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppTheme', () {
    group('themeData', () {
      test('primary color is blue', () {
        expect(
          const AppTheme().themeData.primaryColor,
          AppColors.blue,
        );
      });

      test('secondary color is lightBlue.shade300', () {
        expect(
          const AppTheme().themeData.colorScheme.secondary,
          AppColors.lightBlue.shade300,
        );
      });
    });
  });

  group('AppDarkTheme', () {
    group('themeData', () {
      test('primary color is blue', () {
        expect(
          const AppDarkTheme().themeData.primaryColor,
          AppColors.blue,
        );
      });

      test('secondary color is lightBlue.shade300', () {
        expect(
          const AppDarkTheme().themeData.colorScheme.secondary,
          AppColors.lightBlue.shade300,
        );
      });

      test('background color is grey.shade900', () {
        expect(
          const AppDarkTheme().themeData.backgroundColor,
          AppColors.grey.shade900,
        );
      });
    });
  });
}
