// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_example/ads/ads.dart';
import 'package:flutter_news_example/analytics/analytics.dart';
import 'package:flutter_news_example/app/app.dart';
import 'package:flutter_news_example/article/article.dart';
import 'package:flutter_news_example/login/login.dart';
import 'package:flutter_news_example/subscriptions/subscriptions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart' as ads;
import 'package:in_app_purchase_repository/in_app_purchase_repository.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:user_repository/user_repository.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../helpers/helpers.dart';

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

class MockArticleBloc extends MockBloc<ArticleEvent, ArticleState>
    implements ArticleBloc {}

class MockUser extends Mock implements User {}

class MockAdWithoutView extends Mock implements ads.AdWithoutView {}

class MockRewardItem extends Mock implements ads.RewardItem {}

class MockAnalyticsBloc extends MockBloc<AnalyticsEvent, AnalyticsState>
    implements AnalyticsBloc {}

class MockFullScreenAdsBloc
    extends MockBloc<FullScreenAdsEvent, FullScreenAdsState>
    implements FullScreenAdsBloc {}

void main() {
  late AppBloc appBloc;
  late User user;
  late AnalyticsBloc analyticsBloc;
  late ArticleBloc articleBloc;

  const subscribeButtonKey =
      Key('subscribeWithArticleLimitModal_subscribeButton');
  const logInButtonKey = Key('subscribeWithArticleLimitModal_logInButton');
  const watchVideoButton =
      Key('subscribeWithArticleLimitModal_watchVideoButton');

  setUp(() {
    user = MockUser();
    appBloc = MockAppBloc();
    analyticsBloc = MockAnalyticsBloc();
    articleBloc = MockArticleBloc();

    when(() => appBloc.state).thenReturn(AppState.unauthenticated());

    when(() => articleBloc.state).thenReturn(
      ArticleState(status: ArticleStatus.initial, title: 'title'),
    );

    VisibilityDetectorController.instance.updateInterval = Duration.zero;
  });

  group('SubscribeWithArticleLimitModal', () {
    group('renders', () {
      testWidgets(
          'subscribe and watch video buttons '
          'when user is authenticated', (tester) async {
        when(() => appBloc.state).thenReturn(AppState.authenticated(user));
        await tester.pumpApp(
          analyticsBloc: analyticsBloc,
          appBloc: appBloc,
          BlocProvider.value(
            value: articleBloc,
            child: SubscribeWithArticleLimitModal(),
          ),
        );
        expect(find.byKey(subscribeButtonKey), findsOneWidget);
        expect(find.byKey(watchVideoButton), findsOneWidget);
        expect(find.byKey(logInButtonKey), findsNothing);
      });

      testWidgets(
          'subscribe log in and watch video buttons '
          'when user is unauthenticated', (tester) async {
        when(() => appBloc.state).thenReturn(AppState.unauthenticated());
        await tester.pumpApp(
          analyticsBloc: analyticsBloc,
          appBloc: appBloc,
          BlocProvider.value(
            value: articleBloc,
            child: SubscribeWithArticleLimitModal(),
          ),
        );
        expect(find.byKey(subscribeButtonKey), findsOneWidget);
        expect(find.byKey(logInButtonKey), findsOneWidget);
        expect(find.byKey(watchVideoButton), findsOneWidget);
      });
    });

    group('opens PurchaseSubscriptionDialog', () {
      late InAppPurchaseRepository inAppPurchaseRepository;
      late AnalyticsBloc analyticsBloc;

      setUp(() {
        inAppPurchaseRepository = MockInAppPurchaseRepository();
        analyticsBloc = MockAnalyticsBloc();

        when(() => inAppPurchaseRepository.purchaseUpdate).thenAnswer(
          (_) => const Stream.empty(),
        );

        when(inAppPurchaseRepository.fetchSubscriptions).thenAnswer(
          (_) async => [],
        );

        when(() => articleBloc.state).thenReturn(
          ArticleState(status: ArticleStatus.initial, title: 'title'),
        );
      });

      testWidgets(
          'when tapped on subscribe button '
          'adding PaywallPromptEvent.click to AnalyticsBloc', (tester) async {
        await tester.pumpApp(
          analyticsBloc: analyticsBloc,
          appBloc: appBloc,
          inAppPurchaseRepository: inAppPurchaseRepository,
          BlocProvider.value(
            value: articleBloc,
            child: SubscribeWithArticleLimitModal(),
          ),
        );
        await tester.tap(find.byKey(subscribeButtonKey));
        await tester.pump();
        expect(find.byType(PurchaseSubscriptionDialog), findsOneWidget);

        verify(
          () => analyticsBloc.add(
            TrackAnalyticsEvent(
              PaywallPromptEvent.click(
                articleTitle: 'title',
              ),
            ),
          ),
        ).called(1);
      });
    });

    testWidgets(
        'shows LoginModal '
        'when tapped on log in button', (tester) async {
      whenListen(
        appBloc,
        Stream.value(AppState.unauthenticated()),
        initialState: AppState.unauthenticated(),
      );

      await tester.pumpApp(
        analyticsBloc: analyticsBloc,
        appBloc: appBloc,
        BlocProvider.value(
          value: articleBloc,
          child: SubscribeWithArticleLimitModal(),
        ),
      );

      await tester.tap(find.byKey(logInButtonKey));
      await tester.pumpAndSettle();

      expect(find.byType(LoginModal), findsOneWidget);
    });

    testWidgets(
        'adds ShowRewardedAdRequested to FullScreenAdsBloc '
        'when tapped on watch video button', (tester) async {
      final fullScreenAdsBloc = MockFullScreenAdsBloc();

      await tester.pumpApp(
        analyticsBloc: analyticsBloc,
        appBloc: appBloc,
        fullScreenAdsBloc: fullScreenAdsBloc,
        BlocProvider.value(
          value: articleBloc,
          child: SubscribeWithArticleLimitModal(),
        ),
      );
      await tester.tap(find.byKey(watchVideoButton));
      await tester.pump();

      verify(() => fullScreenAdsBloc.add(ShowRewardedAdRequested())).called(1);
    });

    testWidgets(
        'adds TrackAnalyticsEvent to AnalyticsBloc '
        'with PaywallPromptEvent.impression rewarded '
        'when shown', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: articleBloc,
          child: SubscribeWithArticleLimitModal(),
        ),
        analyticsBloc: analyticsBloc,
        appBloc: appBloc,
      );

      verify(
        () => analyticsBloc.add(
          TrackAnalyticsEvent(
            PaywallPromptEvent.impression(
              articleTitle: 'title',
              impression: PaywallPromptImpression.rewarded,
            ),
          ),
        ),
      ).called(1);
    });
  });
}
