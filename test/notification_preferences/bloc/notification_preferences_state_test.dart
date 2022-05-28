// ignore: lines_longer_than_80_chars
// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/notification_preferences/notification_preferences.dart';
import 'package:news_blocks/news_blocks.dart';

void main() {
  group('NotificationPreferencesState', () {
    test('initial has correct status', () {
      final initialState =
          NotificationPreferencesState.initial(categories: {Category.business});

      expect(
        initialState,
        equals(
          NotificationPreferencesState(
            selectedCategories: {Category.business},
            status: NotificationPreferencesStatus.initial,
            categories: {Category.business},
          ),
        ),
      );
    });

    test('supports value comparison', () {
      expect(
        NotificationPreferencesState.initial(categories: {Category.business}),
        equals(
          NotificationPreferencesState.initial(categories: {Category.business}),
        ),
      );
    });

    group('copyWith ', () {
      test(
          'returns same object '
          'when no parameters changed', () {
        expect(
          NotificationPreferencesState.initial(categories: {}).copyWith(),
          equals(NotificationPreferencesState.initial(categories: {})),
        );
      });

      test(
          'returns object with updated categories and togglesState '
          'when categories changed', () {
        expect(
          NotificationPreferencesState.initial(categories: {}).copyWith(
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
          NotificationPreferencesState.initial(categories: {}).copyWith(
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
          'returns object with updated toggleState '
          'when toggleState changed', () {
        expect(
          NotificationPreferencesState.initial(categories: {Category.business})
              .copyWith(
            selectedCategories: {Category.business},
          ),
          equals(
            NotificationPreferencesState(
              categories: {Category.business},
              status: NotificationPreferencesStatus.initial,
              selectedCategories: {Category.business},
            ),
          ),
        );
      });
    });
  });
}
