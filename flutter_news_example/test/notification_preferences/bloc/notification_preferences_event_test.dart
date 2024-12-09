// ignore_for_file: prefer_const_constructors

import 'package:flutter_news_example/notification_preferences/notification_preferences.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_blocks/news_blocks.dart';

void main() {
  final healthCategory = Category(id: 'health', name: 'Health');

  group('NotificationPreferencesEvent', () {
    group('CategoriesPreferenceToggled', () {
      test('supports value comparisons', () {
        final event1 = CategoriesPreferenceToggled(category: healthCategory);
        final event2 = CategoriesPreferenceToggled(category: healthCategory);

        expect(event1, equals(event2));
      });
    });

    group('InitialCategoriesPreferencesRequested', () {
      test('supports value comparisons', () {
        final event1 = InitialCategoriesPreferencesRequested();
        final event2 = InitialCategoriesPreferencesRequested();

        expect(event1, equals(event2));
      });
    });
  });
}
