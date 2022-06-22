import 'package:analytics_repository/analytics_repository.dart';
import 'package:article_repository/article_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/app/app.dart';
import 'package:google_news_template/l10n/l10n.dart';
import 'package:google_news_template/theme_selector/theme_selector.dart';
import 'package:mockingjay/mockingjay.dart'
    show MockNavigatorProvider, MockNavigator;
import 'package:mocktail/mocktail.dart';
import 'package:news_repository/news_repository.dart';
import 'package:notifications_repository/notifications_repository.dart';
import 'package:subscriptions_repository/subscriptions_repository.dart';
import 'package:user_repository/user_repository.dart';

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {
  @override
  AppState get state => const AppState.unauthenticated();
}

class MockThemeModeBloc extends MockBloc<ThemeModeEvent, ThemeMode>
    implements ThemeModeBloc {
  @override
  ThemeMode get state => ThemeMode.system;
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

class MockSubscriptionsRepository extends Mock
    implements SubscriptionsRepository {}

class MockAnalyticsRepository extends Mock implements AnalyticsRepository {}

extension AppTester on WidgetTester {
  Future<void> pumpApp(
    Widget widgetUnderTest, {
    AppBloc? appBloc,
    UserRepository? userRepository,
    NewsRepository? newsRepository,
    NotificationsRepository? notificationRepository,
    ArticleRepository? articleRepository,
    SubscriptionsRepository? subscriptionsRepository,
    AnalyticsRepository? analyticsRepository,
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
            value: subscriptionsRepository ?? MockSubscriptionsRepository(),
          ),
          RepositoryProvider.value(
            value: analyticsRepository ?? MockAnalyticsRepository(),
          ),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider.value(value: appBloc ?? MockAppBloc()),
            BlocProvider.value(value: themeModeBloc ?? MockThemeModeBloc()),
          ],
          child: MaterialApp(
            title: 'Google News Template',
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
