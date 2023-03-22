import 'package:ads_consent_client/ads_consent_client.dart';
import 'package:article_repository/article_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_news_example/ads/ads.dart';
import 'package:flutter_news_example/analytics/analytics.dart';
import 'package:flutter_news_example/app/app.dart';
import 'package:flutter_news_example/l10n/l10n.dart';
import 'package:flutter_news_example/theme_selector/theme_selector.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_purchase_repository/in_app_purchase_repository.dart';
import 'package:mockingjay/mockingjay.dart'
    show MockNavigator, MockNavigatorProvider;
import 'package:mocktail/mocktail.dart';
import 'package:news_repository/news_repository.dart';
import 'package:notifications_repository/notifications_repository.dart';
import 'package:user_repository/user_repository.dart';

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {
  @override
  AppState get state => const AppState.unauthenticated();
}

class MockAnalyticsBloc extends MockBloc<AnalyticsEvent, AnalyticsState>
    implements AnalyticsBloc {}

class MockThemeModeBloc extends MockBloc<ThemeModeEvent, ThemeMode>
    implements ThemeModeBloc {
  @override
  ThemeMode get state => ThemeMode.system;
}

class MockFullScreenAdsBloc
    extends MockBloc<FullScreenAdsEvent, FullScreenAdsState>
    implements FullScreenAdsBloc {
  @override
  FullScreenAdsState get state => const FullScreenAdsState.initial();
}

class MockUserRepository extends Mock implements UserRepository {
  @override
  Stream<Uri> get incomingEmailLinks => const Stream.empty();

  @override
  Stream<User> get user => const Stream.empty();
}

class MockNewsRepository extends Mock implements NewsRepository {}

class MockNotificationsRepository extends Mock
    implements NotificationsRepository {}

class MockArticleRepository extends Mock implements ArticleRepository {
  @override
  Future<ArticleViews> fetchArticleViews() async => ArticleViews(0, null);

  @override
  Future<void> incrementArticleViews() async {}

  @override
  Future<void> resetArticleViews() async {}
}

class MockInAppPurchaseRepository extends Mock
    implements InAppPurchaseRepository {}

class MockAdsConsentClient extends Mock implements AdsConsentClient {}

extension AppTester on WidgetTester {
  Future<void> pumpApp(
    Widget widgetUnderTest, {
    AppBloc? appBloc,
    AnalyticsBloc? analyticsBloc,
    FullScreenAdsBloc? fullScreenAdsBloc,
    UserRepository? userRepository,
    NewsRepository? newsRepository,
    NotificationsRepository? notificationRepository,
    ArticleRepository? articleRepository,
    InAppPurchaseRepository? inAppPurchaseRepository,
    AdsConsentClient? adsConsentClient,
    TargetPlatform? platform,
    ThemeModeBloc? themeModeBloc,
    NavigatorObserver? navigatorObserver,
    MockNavigator? navigator,
  }) async {
    await pumpWidget(
      MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(
            value: userRepository ?? MockUserRepository(),
          ),
          RepositoryProvider.value(
            value: newsRepository ?? MockNewsRepository(),
          ),
          RepositoryProvider.value(
            value: notificationRepository ?? MockNotificationsRepository(),
          ),
          RepositoryProvider.value(
            value: articleRepository ?? MockArticleRepository(),
          ),
          RepositoryProvider.value(
            value: inAppPurchaseRepository ?? MockInAppPurchaseRepository(),
          ),
          RepositoryProvider.value(
            value: adsConsentClient ?? MockAdsConsentClient(),
          ),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider.value(value: appBloc ?? MockAppBloc()),
            BlocProvider.value(value: analyticsBloc ?? MockAnalyticsBloc()),
            BlocProvider.value(value: themeModeBloc ?? MockThemeModeBloc()),
            BlocProvider.value(
              value: fullScreenAdsBloc ?? MockFullScreenAdsBloc(),
            ),
          ],
          child: MaterialApp(
            title: 'Flutter News Example',
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: Theme(
              data: ThemeData(platform: platform),
              child: navigator == null
                  ? Scaffold(body: widgetUnderTest)
                  : MockNavigatorProvider(
                      navigator: navigator,
                      child: Scaffold(body: widgetUnderTest),
                    ),
            ),
            navigatorObservers: [
              if (navigatorObserver != null) navigatorObserver
            ],
          ),
        ),
      ),
    );
    await pump();
  }
}
