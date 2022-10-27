import 'package:flutter_news_example/notification_preferences/notification_preferences.dart';
// ignore: lines_longer_than_80_chars
// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:news_blocks/news_blocks.dart';

void main() {
  group('NotificationPreferencesState', () {
    test('initial has correct status', () {
      final initialState = NotificationPreferencesState.initial();

      expect(
        initialState,
        equals(
          NotificationPreferencesState(
            selectedCategories: {},
            status: NotificationPreferencesStatus.initial,
            categories: {},
          ),
        ),
      );
    });

    test('supports value comparison', () {
      expect(
        NotificationPreferencesState.initial(),
        equals(
          NotificationPreferencesState.initial(),
        ),
      );
    });

    group('copyWith ', () {
      test(
          'returns same object '
          'when no parameters changed', () {
        expect(
          NotificationPreferencesState.initial().copyWith(),
          equals(NotificationPreferencesState.initial()),
        );
      });

      test(
          'returns object with updated categories '
          'when categories changed', () {
        expect(
          NotificationPreferencesState.initial().copyWith(
            categories: {Category.business},
          ),
          equals(
            NotificationPreferencesState(
              categories: {Category.business},
              selectedCategories: {},
              status: NotificationPreferencesStatus.initial,
            ),
          ),
        );
      });
      test(
          'returns object with updated status '
          'when status changed', () {
        expect(
          NotificationPreferencesState.initial().copyWith(
            status: NotificationPreferencesStatus.success,
          ),
          equals(
            NotificationPreferencesState(
              categories: {},
              status: NotificationPreferencesStatus.success,
              selectedCategories: {},
            ),
          ),
        );
      });

      test(
          'returns object with updated selectedCategories '
          'when selectedCategories changed', () {
        expect(
          NotificationPreferencesState.initial().copyWith(
            selectedCategories: {Category.business},
          ),
          equals(
            NotificationPreferencesState(
              categories: {},
              status: NotificationPreferencesStatus.initial,
              selectedCategories: {Category.business},
            ),
          ),
        );
      });
    });
  });
}
