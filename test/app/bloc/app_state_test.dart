// ignore_for_file: must_be_immutable, prefer_const_constructors
import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/app/app.dart';
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
    });

    group('onboardingRequired', () {
      test('has correct status', () {
        final user = MockUser();
        final state = AppState.onboardingRequired(user);
        expect(state.status, AppStatus.onboardingRequired);
        expect(state.user, user);
      });
    });
  });
}
