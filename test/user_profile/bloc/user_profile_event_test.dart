// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/user_profile/user_profile.dart';
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
  });
}
