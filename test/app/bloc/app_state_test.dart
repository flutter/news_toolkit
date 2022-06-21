// ignore_for_file: must_be_immutable, prefer_const_constructors
import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/app/app.dart';
import 'package:in_app_purchase_repository/in_app_purchase_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:user_repository/user_repository.dart';

class MockUser extends Mock implements User {}

void main() {
  group('AppState', () {
    group('unauthenticated', () {
      test('has correct status', () {
        final state = AppState.unauthenticated();
        expect(state.status, AppStatus.unauthenticated);
        expect(state.user, User.anonymous);
      });
    });

    group('authenticated', () {
      test('has correct status', () {
        final user = MockUser();
        final state = AppState.authenticated(user);
        expect(state.status, AppStatus.authenticated);
        expect(state.user, user);
      });

      test('has correct userSubscriptionPlan', () {
        const userSubscriptionPlan = SubscriptionPlan.premium;
        final state = AppState.authenticated(
          MockUser(),
          userSubscriptionPlan: userSubscriptionPlan,
        );
        expect(state.status, AppStatus.authenticated);
        expect(state.userSubscriptionPlan, userSubscriptionPlan);
      });
    });

    group('onboardingRequired', () {
      test('has correct status', () {
        final user = MockUser();
        final state = AppState.onboardingRequired(user);
        expect(state.status, AppStatus.onboardingRequired);
        expect(state.user, user);
      });
    });

    group('isUserSubscribed', () {
      test('returns true when userSubscriptionPlan is not null and not none',
          () {
        expect(
          AppState.authenticated(
            MockUser(),
            userSubscriptionPlan: SubscriptionPlan.premium,
          ).isUserSubscribed,
          isTrue,
        );
      });

      test('returns false when userSubscriptionPlan is null', () {
        expect(
          AppState.authenticated(MockUser()).isUserSubscribed,
          isFalse,
        );
      });

      test('returns false when userSubscriptionPlan is none', () {
        expect(
          AppState.authenticated(
            MockUser(),
            userSubscriptionPlan: SubscriptionPlan.none,
          ).isUserSubscribed,
          isFalse,
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
        final user = MockUser();
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

      test(
          'returns object with updated userSubscriptionPlan '
          'when userSubscriptionPlan is passed', () {
        const userSubscriptionPlan = SubscriptionPlan.premium;
        expect(
          AppState.unauthenticated().copyWith(
            userSubscriptionPlan: userSubscriptionPlan,
          ),
          equals(
            AppState(
              status: AppStatus.unauthenticated,
              userSubscriptionPlan: userSubscriptionPlan,
            ),
          ),
        );
      });
    });
  });
}
