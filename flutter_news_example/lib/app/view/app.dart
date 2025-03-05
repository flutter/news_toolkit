import 'package:ads_consent_client/ads_consent_client.dart';
import 'package:analytics_repository/analytics_repository.dart';
import 'package:app_ui/app_ui.dart';
import 'package:article_repository/article_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_example/ads/ads.dart';
import 'package:flutter_news_example/analytics/analytics.dart';
import 'package:flutter_news_example/app/app.dart';
import 'package:flutter_news_example/categories/categories.dart';
import 'package:flutter_news_example/l10n/l10n.dart';
import 'package:flutter_news_example/login/login.dart' hide LoginEvent;
import 'package:flutter_news_example/theme_selector/theme_selector.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart' as ads;
import 'package:in_app_purchase_repository/in_app_purchase_repository.dart';
import 'package:news_blocks_ui/news_blocks_ui.dart';
import 'package:news_repository/news_repository.dart';
import 'package:notifications_repository/notifications_repository.dart';
import 'package:platform/platform.dart';
import 'package:user_repository/user_repository.dart';

class App extends StatelessWidget {
  const App({
    required UserRepository userRepository,
    required NewsRepository newsRepository,
    required NotificationsRepository notificationsRepository,
    required ArticleRepository articleRepository,
    required InAppPurchaseRepository inAppPurchaseRepository,
    required AnalyticsRepository analyticsRepository,
    required AdsConsentClient adsConsentClient,
    required User user,
    super.key,
  })  : _userRepository = userRepository,
        _newsRepository = newsRepository,
        _notificationsRepository = notificationsRepository,
        _articleRepository = articleRepository,
        _inAppPurchaseRepository = inAppPurchaseRepository,
        _analyticsRepository = analyticsRepository,
        _adsConsentClient = adsConsentClient,
        _user = user;

  final UserRepository _userRepository;
  final NewsRepository _newsRepository;
  final NotificationsRepository _notificationsRepository;
  final ArticleRepository _articleRepository;
  final InAppPurchaseRepository _inAppPurchaseRepository;
  final AnalyticsRepository _analyticsRepository;
  final AdsConsentClient _adsConsentClient;
  final User _user;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: _userRepository),
        RepositoryProvider.value(value: _newsRepository),
        RepositoryProvider.value(value: _notificationsRepository),
        RepositoryProvider.value(value: _articleRepository),
        RepositoryProvider.value(value: _analyticsRepository),
        RepositoryProvider.value(value: _inAppPurchaseRepository),
        RepositoryProvider.value(value: _adsConsentClient),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => AppBloc(
              userRepository: _userRepository,
              notificationsRepository: _notificationsRepository,
              user: _user,
            )..add(const AppOpened()),
          ),
          BlocProvider(create: (_) => ThemeModeBloc()),
          BlocProvider(
            create: (_) => LoginWithEmailLinkBloc(
              userRepository: _userRepository,
            ),
            lazy: false,
          ),
          BlocProvider(
            create: (context) => AnalyticsBloc(
              analyticsRepository: _analyticsRepository,
              userRepository: _userRepository,
            ),
            lazy: false,
          ),
          BlocProvider(
            create: (context) => FullScreenAdsBloc(
              interstitialAdLoader: ads.InterstitialAd.load,
              rewardedAdLoader: ads.RewardedAd.load,
              adsRetryPolicy: const AdsRetryPolicy(),
              localPlatform: const LocalPlatform(),
            )
              ..add(const LoadInterstitialAdRequested())
              ..add(const LoadRewardedAdRequested()),
            lazy: false,
          ),
          BlocProvider(
            create: (context) => CategoriesBloc(
              newsRepository: context.read<NewsRepository>(),
            )..add(const CategoriesRequested()),
          ),
        ],
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      themeMode: ThemeMode.light,
      theme: const AppTheme().themeData,
      darkTheme: const AppDarkTheme().themeData,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, router) {
        return AuthenticatedUserListener(
          child: router ?? const SizedBox(),
        );
      },
    );
  }
}
