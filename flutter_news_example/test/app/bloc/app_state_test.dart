// ignore_for_file: must_be_immutable, prefer_const_constructors
import 'package:flutter_news_example/app/app.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_purchase_repository/in_app_purchase_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:user_repository/user_repository.dart';

class MockUser extends Mock implements User {}

void main() {
  group('AppState', () {
    late User user;

    setUp(() {
      user = MockUser();
      when(() => user.subscriptionPlan).thenReturn(SubscriptionPlan.none);
    });

    group('unauthenticated', () {
      test('has correct status', () {
        final state = AppState.unauthenticated();
        expect(state.status, AppStatus.unauthenticated);
        expect(state.user, User.anonymous);
      });
    });

    group('authenticated', () {
      test('has correct status', () {
        final state = AppState.authenticated(user);
        expect(state.status, AppStatus.authenticated);
        expect(state.user, user);
      });
    });

    group('onboardingRequired', () {
      test('has correct status', () {
        final state = AppState.onboardingRequired(user);
        expect(state.status, AppStatus.onboardingRequired);
        expect(state.user, user);
      });
    });

    group('isUserSubscribed', () {
      test('returns true when userSubscriptionPlan is not null and not none',
          () {
        when(() => user.subscriptionPlan).thenReturn(SubscriptionPlan.premium);
        expect(
          AppState.authenticated(user).isUserSubscribed,
          isTrue,
        );
      });

      test('returns false when userSubscriptionPlan is none', () {
        expect(
          AppState.authenticated(user).isUserSubscribed,
          isFalse,
        );
      });
    });

    group('AppStatus', () {
      test(
          'authenticated and onboardingRequired are the only statuses '
          'where loggedIn is true', () {
        expect(
          AppStatus.values.where((e) => e.isLoggedIn).toList(),
          equals(
            [
              AppStatus.onboardingRequired,
              AppStatus.authenticated,
            ],
          ),
        );
      });
    });

    group('copyWith', () {
      test(
          'returns same object '
          'when no properties are passed', () {
        expect(
          AppState.unauthenticated().copyWith(),
          equals(AppState.unauthenticated()),
        );
      });

      test(
          'returns object with updated status '
          'when status is passed', () {
        expect(
          AppState.unauthenticated().copyWith(
            status: AppStatus.onboardingRequired,
          ),
          equals(
            AppState(
              status: AppStatus.onboardingRequired,
            ),
          ),
        );
      });

      test(
          'returns object with updated user '
          'when user is passed', () {
        expect(
          AppState.unauthenticated().copyWith(
            user: user,
          ),
          equals(
            AppState(
              status: AppStatus.unauthenticated,
              user: user,
            ),
          ),
        );
      });
    });
  });
}
