// ignore_for_file: prefer_const_constructors

import 'package:flutter_news_example/user_profile/user_profile.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:user_repository/user_repository.dart';

void main() {
  group('UserProfileEvent', () {
    group('UserProfileUpdated', () {
      test('supports value comparisons', () {
        const user = User.anonymous;
        final userProfileUpdated = UserProfileUpdated(user);
        final userProfileUpdated2 = UserProfileUpdated(user);

        expect(userProfileUpdated, equals(userProfileUpdated2));
      });
    });

    group('FetchNotificationsEnabled', () {
      test('supports value comparisons', () {
        final event1 = FetchNotificationsEnabled();
        final event2 = FetchNotificationsEnabled();

        expect(event1, equals(event2));
      });
    });

    group('ToggleNotifications', () {
      test('supports value comparisons', () {
        final event1 = ToggleNotifications();
        final event2 = ToggleNotifications();

        expect(event1, equals(event2));
      });
    });
  });
}
