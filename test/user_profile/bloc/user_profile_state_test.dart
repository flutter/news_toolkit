// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/user_profile/user_profile.dart';
import 'package:user_repository/user_repository.dart';

void main() {
  group('UserProfileState', () {
    group('UserProfileInitial', () {
      test('supports value comparisons', () {
        final userProfileInitial = UserProfileInitial();
        final userProfileInitial2 = UserProfileInitial();

        expect(userProfileInitial, equals(userProfileInitial2));
      });
    });

    group('UserProfilePopulated', () {
      test('supports value comparisons', () {
        const user = User.anonymous;

        final userProfilePopulated = UserProfilePopulated(user);
        final userProfilePopulated2 = UserProfilePopulated(user);

        expect(userProfilePopulated, equals(userProfilePopulated2));
      });
    });
  });
}
