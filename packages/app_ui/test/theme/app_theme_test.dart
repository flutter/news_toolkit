import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
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

      group('switchTheme', () {
        group('thumbColor', () {
          test('returns darkAqua when selected', () {
            expect(
              const AppTheme()
                  .themeData
                  .switchTheme
                  .thumbColor
                  ?.resolve({MaterialState.selected}),
              equals(AppColors.darkAqua),
            );
          });

          test('returns eerieBlack when not selected', () {
            expect(
              const AppTheme().themeData.switchTheme.thumbColor?.resolve({}),
              equals(AppColors.eerieBlack),
            );
          });
        });

        group('trackColor', () {
          test('returns primaryContainer when selected', () {
            expect(
              const AppTheme()
                  .themeData
                  .switchTheme
                  .trackColor
                  ?.resolve({MaterialState.selected}),
              equals(AppColors.primaryContainer),
            );
          });

          test('returns paleSky when not selected', () {
            expect(
              const AppTheme().themeData.switchTheme.trackColor?.resolve({}),
              equals(AppColors.paleSky),
            );
          });
        });
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
