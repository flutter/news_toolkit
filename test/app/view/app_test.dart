import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/app/app.dart';
import 'package:google_news_template/home/home.dart';
import 'package:google_news_template/onboarding/onboarding.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_repository/news_repository.dart';
import 'package:notifications_repository/notifications_repository.dart';
import 'package:user_repository/user_repository.dart';

import '../../helpers/helpers.dart';

// ignore: must_be_immutable
class MockUser extends Mock implements User {}

class MockUserRepository extends Mock implements UserRepository {}

class MockNewsRepository extends Mock implements NewsRepository {}

class MockNotificationsRepository extends Mock
    implements NotificationsRepository {}

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

void main() {
  group('App', () {
    late UserRepository userRepository;
    late NewsRepository newsRepository;
    late NotificationsRepository notificationsRepository;
    late User user;

    setUp(() {
      userRepository = MockUserRepository();
      when(() => userRepository.user).thenAnswer(
        (_) => const Stream.empty(),
      );
      when(() => userRepository.incomingEmailLinks).thenAnswer(
        (_) => const Stream.empty(),
      );
      user = User.anonymous;
      newsRepository = MockNewsRepository();
      notificationsRepository = MockNotificationsRepository();
    });

    testWidgets('renders AppView', (tester) async {
      await mockHydratedStorage(() async {
        await tester.pumpWidget(
          App(
            userRepository: userRepository,
            newsRepository: newsRepository,
            notificationsRepository: notificationsRepository,
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
