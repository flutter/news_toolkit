import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/app/app.dart';
import 'package:google_news_template/home/home.dart';
import 'package:google_news_template/onboarding/onboarding.dart';
import 'package:mocktail/mocktail.dart';
import 'package:user_repository/user_repository.dart';

import '../../helpers/helpers.dart';

// ignore: must_be_immutable
class MockUser extends Mock implements User {}

class MockUserRepository extends Mock implements UserRepository {}

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

void main() {
  group('App', () {
    late UserRepository userRepository;
    late User user;

    setUp(() {
      userRepository = MockUserRepository();
      when(() => userRepository.user).thenAnswer(
        (_) => const Stream.empty(),
      );
      user = User.anonymous;
    });

    testWidgets('renders AppView', (tester) async {
      await mockHydratedStorage(() async {
        await tester.pumpWidget(
          App(
            userRepository: userRepository,
            user: user,
          ),
        );
      });
      await tester.pump();
      expect(find.byType(AppView), findsOneWidget);
    });
  });

  group('AppView', () {
    late AppBloc appBloc;
    late UserRepository userRepository;

    setUp(() {
      appBloc = MockAppBloc();
      userRepository = MockUserRepository();
    });

    testWidgets('navigates to OnboardingPage when onboardingRequired',
        (tester) async {
      final user = MockUser();
      when(() => appBloc.state).thenReturn(AppState.onboardingRequired(user));
      await tester.pumpApp(
        const AppView(),
        appBloc: appBloc,
        userRepository: userRepository,
      );
      await tester.pumpAndSettle();
      expect(find.byType(OnboardingPage), findsOneWidget);
    });

    testWidgets('navigates to HomePage when unauthenticated', (tester) async {
      when(() => appBloc.state).thenReturn(const AppState.unauthenticated());
      await tester.pumpApp(
        const AppView(),
        appBloc: appBloc,
        userRepository: userRepository,
      );
      await tester.pumpAndSettle();
      expect(find.byType(HomePage), findsOneWidget);
    });

    testWidgets('navigates to HomePage when authenticated', (tester) async {
      final user = MockUser();
      when(() => user.isAnonymous).thenReturn(false);
      when(() => appBloc.state).thenReturn(AppState.authenticated(user));
      await tester.pumpApp(
        const AppView(),
        appBloc: appBloc,
        userRepository: userRepository,
      );
      await tester.pumpAndSettle();
      expect(find.byType(HomePage), findsOneWidget);
    });
  });
}
