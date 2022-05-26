// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/notification_preferences/notification_preferences.dart';
import 'package:news_blocks/news_blocks.dart';

void main() {
  group('NotificationPreferencesEvent', () {
    test('supports value comparison', () {
      final event1 =
          NotificationPreferencesToggled(category: Category.business);
      final event2 =
          NotificationPreferencesToggled(category: Category.business);

      expect(event1, equals(event2));
    });
  });
}
