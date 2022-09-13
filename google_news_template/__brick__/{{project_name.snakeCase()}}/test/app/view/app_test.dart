// ignore_for_file: prefer_const_constructors

{{#include_ads}}
import 'package:ads_consent_client/ads_consent_client.dart';
{{/include_ads}}
import 'package:analytics_repository/analytics_repository.dart';
import 'package:article_repository/article_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:{{project_name.snakeCase()}}/analytics/analytics.dart' as analytics;
import 'package:{{project_name.snakeCase()}}/app/app.dart';
import 'package:{{project_name.snakeCase()}}/home/home.dart';
import 'package:{{project_name.snakeCase()}}/onboarding/onboarding.dart';
import 'package:in_app_purchase_repository/in_app_purchase_repository.dart';
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

class MockArticleRepository extends Mock implements ArticleRepository {}

class MockInAppPurchaseRepository extends Mock
    implements InAppPurchaseRepository {}

class MockAnalyticsRepository extends Mock implements AnalyticsRepository {}

{{#include_ads}}
class MockAdsConsentClient extends Mock implements AdsConsentClient {}
{{/include_ads}}

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

class MockAnalyticsBloc
    extends MockBloc<analytics.AnalyticsEvent, analytics.AnalyticsState>
    implements analytics.AnalyticsBloc {}

void main() {
  group('App', () {
    late UserRepository userRepository;
    late NewsRepository newsRepository;
    late NotificationsRepository notificationsRepository;
    late ArticleRepository articleRepository;
    late InAppPurchaseRepository inAppPurchaseRepository;
    late AnalyticsRepository analyticsRepository;
{{#include_ads}}
    late AdsConsentClient adsConsentClient;
{{/include_ads}}
    late User user;

    setUp(() {
      userRepository = MockUserRepository();
      user = User.anonymous;
      newsRepository = MockNewsRepository();
      notificationsRepository = MockNotificationsRepository();
      articleRepository = MockArticleRepository();
      inAppPurchaseRepository = MockInAppPurchaseRepository();
      analyticsRepository = MockAnalyticsRepository();
{{#include_ads}}
      adsConsentClient = MockAdsConsentClient();
{{/include_ads}}

      when(() => userRepository.user).thenAnswer((_) => const Stream.empty());
      when(() => userRepository.incomingEmailLinks)
          .thenAnswer((_) => const Stream.empty());
      when(() => userRepository.fetchAppOpenedCount())
          .thenAnswer((_) async => 2);
      when(() => userRepository.incrementAppOpenedCount())
          .thenAnswer((_) async {});
    });

    testWidgets('renders AppView', (tester) async {
      await mockHydratedStorage(() async {
        await tester.pumpWidget(
          App(
            userRepository: userRepository,
            newsRepository: newsRepository,
            notificationsRepository: notificationsRepository,
            articleRepository: articleRepository,
            inAppPurchaseRepository: inAppPurchaseRepository,
            analyticsRepository: analyticsRepository,
{{#include_ads}}
            adsConsentClient: adsConsentClient,
{{/include_ads}}
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
    late analytics.AnalyticsBloc analyticsBloc;
    late UserRepository userRepository;

    setUp(() {
      appBloc = MockAppBloc();
      analyticsBloc = MockAnalyticsBloc();
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
      when(() => appBloc.state).thenReturn(AppState.unauthenticated());
      await mockHydratedStorage(
        () => tester.pumpApp(
          const AppView(),
          appBloc: appBloc,
          userRepository: userRepository,
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(HomePage), findsOneWidget);
    });

    testWidgets('navigates to HomePage when authenticated', (tester) async {
      final user = MockUser();
      when(() => user.isAnonymous).thenReturn(false);
      when(() => appBloc.state).thenReturn(AppState.authenticated(user));
      await mockHydratedStorage(
        () => tester.pumpApp(
          const AppView(),
          appBloc: appBloc,
          userRepository: userRepository,
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(HomePage), findsOneWidget);
    });

    group('adds TrackAnalyticsEvent to AnalyticsBloc', () {
      testWidgets(
          'with RegistrationEvent '
          'when user is authenticated and new', (tester) async {
        final user = MockUser();
        when(() => user.isAnonymous).thenReturn(false);
        when(() => user.isNewUser).thenReturn(true);

        whenListen(
          appBloc,
          Stream.fromIterable(
            [
              AppState.unauthenticated(),
              AppState.authenticated(user),
            ],
          ),
          initialState: AppState.unauthenticated(),
        );

        await mockHydratedStorage(
          () => tester.pumpApp(
            const AppView(),
            appBloc: appBloc,
            analyticsBloc: analyticsBloc,
            userRepository: userRepository,
          ),
        );

        verify(
          () => analyticsBloc.add(
            analytics.TrackAnalyticsEvent(analytics.RegistrationEvent()),
          ),
        ).called(1);
      });

      testWidgets(
          'with LoginEvent '
          'when user is authenticated and not new', (tester) async {
        final user = MockUser();
        when(() => user.isAnonymous).thenReturn(false);
        when(() => user.isNewUser).thenReturn(false);

        whenListen(
          appBloc,
          Stream.fromIterable(
            [
              AppState.unauthenticated(),
              AppState.authenticated(user),
            ],
          ),
          initialState: AppState.unauthenticated(),
        );

        await mockHydratedStorage(
          () => tester.pumpApp(
            const AppView(),
            appBloc: appBloc,
            analyticsBloc: analyticsBloc,
            userRepository: userRepository,
          ),
        );

        verify(
          () => analyticsBloc.add(
            analytics.TrackAnalyticsEvent(analytics.LoginEvent()),
          ),
        ).called(1);
      });
    });
  });
}
