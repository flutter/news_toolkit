import 'package:ads_consent_client/ads_consent_client.dart';
import 'package:analytics_repository/analytics_repository.dart';
import 'package:app_ui/app_ui.dart';
import 'package:article_repository/article_repository.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart' as ads;
import 'package:flutter_news_template/ads/ads.dart';
import 'package:flutter_news_template/analytics/analytics.dart';
import 'package:flutter_news_template/app/app.dart';
import 'package:flutter_news_template/l10n/l10n.dart';
import 'package:flutter_news_template/login/login.dart' hide LoginEvent;
import 'package:flutter_news_template/theme_selector/theme_selector.dart';
import 'package:in_app_purchase_repository/in_app_purchase_repository.dart';
import 'package:news_blocks_ui/news_blocks_ui.dart';
import 'package:news_repository/news_repository.dart';
import 'package:notifications_repository/notifications_repository.dart';
import 'package:platform/platform.dart';
import 'package:user_repository/user_repository.dart';

class App extends StatelessWidget {
  const App({
    super.key,
    required UserRepository userRepository,
    required NewsRepository newsRepository,
    required NotificationsRepository notificationsRepository,
    required ArticleRepository articleRepository,
    required InAppPurchaseRepository inAppPurchaseRepository,
    required AnalyticsRepository analyticsRepository,
    required AdsConsentClient adsConsentClient,
    required User user,
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
    return MaterialApp(
      themeMode: ThemeMode.light,
      theme: const AppTheme().themeData,
      darkTheme: const AppDarkTheme().themeData,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: AuthenticatedUserListener(
        child: FlowBuilder<AppStatus>(
          state: context.select((AppBloc bloc) => bloc.state.status),
          onGeneratePages: onGenerateAppViewPages,
        ),
      ),
    );
  }
}
