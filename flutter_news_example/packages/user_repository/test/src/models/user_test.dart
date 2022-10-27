// ignore_for_file: prefer_const_constructors

import 'package:authentication_client/authentication_client.dart';
import 'package:flutter_news_example_api/api.dart' hide User;
import 'package:test/test.dart';
import 'package:user_repository/user_repository.dart';

void main() {
  group('User', () {
    group('fromAuthenticationUser', () {
      test('initializes correctly', () {
        final authenticationUser = AuthenticationUser(id: 'id');
        const subscriptionPlan = SubscriptionPlan.premium;

        expect(
          User.fromAuthenticationUser(
            authenticationUser: authenticationUser,
            subscriptionPlan: subscriptionPlan,
          ),
          equals(
            User(
              id: 'id',
              subscriptionPlan: subscriptionPlan,
            ),
          ),
        );
      });
    });

    group('isAnonymous', () {
      test('sets isAnonymous correctly', () {
        const anonymousUser = User.anonymous;
        expect(anonymousUser.isAnonymous, isTrue);
      });
    });
  });
}
