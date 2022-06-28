// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart' as ads;
import 'package:google_news_template/ads/ads.dart';
import 'package:google_news_template/app/app.dart';
import 'package:google_news_template/article/article.dart';
import 'package:google_news_template/login/login.dart';
import 'package:google_news_template/subscriptions/subscriptions.dart';
import 'package:in_app_purchase_repository/in_app_purchase_repository.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:user_repository/user_repository.dart';

import '../../helpers/helpers.dart';

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

class MockArticleBloc extends MockBloc<ArticleEvent, ArticleState>
    implements ArticleBloc {}

class MockUser extends Mock implements User {}

class MockAdWithoutView extends Mock implements ads.AdWithoutView {}

class MockRewardItem extends Mock implements ads.RewardItem {}

void main() {
  late AppBloc appBloc;
  late User user;

  const subscribeButtonKey =
      Key('subscribeWithArticleLimitModal_subscribeButton');
  const logInButtonKey = Key('subscribeWithArticleLimitModal_logInButton');
  const watchVideoButton =
      Key('subscribeWithArticleLimitModal_watchVideoButton');

  setUp(() {
    user = MockUser();
    appBloc = MockAppBloc();
    when(() => appBloc.state).thenReturn(AppState.unauthenticated());
  });

  group('SubscribeWithArticleLimitModal', () {
    group('renders', () {
      testWidgets(
          'subscribe and watch video buttons '
          'when user is authenticated', (tester) async {
        when(() => appBloc.state).thenReturn(AppState.authenticated(user));
        await tester.pumpApp(
          SubscribeWithArticleLimitModal(),
          appBloc: appBloc,
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
          SubscribeWithArticleLimitModal(),
          appBloc: appBloc,
        );
        expect(find.byKey(subscribeButtonKey), findsOneWidget);
        expect(find.byKey(logInButtonKey), findsOneWidget);
        expect(find.byKey(watchVideoButton), findsOneWidget);
      });
    });

    group('opens PurchaseSubscriptionDialog', () {
      late InAppPurchaseRepository inAppPurchaseRepository;

      setUp(() {
        inAppPurchaseRepository = MockInAppPurchaseRepository();

        when(
          () => inAppPurchaseRepository.currentSubscriptionPlan,
        ).thenAnswer(
          (_) => Stream.fromIterable([
            SubscriptionPlan.none,
          ]),
        );

        when(() => inAppPurchaseRepository.purchaseUpdateStream).thenAnswer(
          (_) => const Stream.empty(),
        );

        when(inAppPurchaseRepository.fetchSubscriptions).thenAnswer(
          (_) async => [],
        );
      });

      testWidgets('when tapped on subscribe button', (tester) async {
        await tester.pumpApp(
          SubscribeWithArticleLimitModal(),
          inAppPurchaseRepository: inAppPurchaseRepository,
        );
        await tester.tap(find.byKey(subscribeButtonKey));
        await tester.pump();
        expect(find.byType(PurchaseSubscriptionDialog), findsOneWidget);
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
        SubscribeWithArticleLimitModal(),
        appBloc: appBloc,
      );

      await tester.tap(find.byKey(logInButtonKey));
      await tester.pumpAndSettle();

      expect(find.byType(LoginModal), findsOneWidget);
    });

    testWidgets(
        'renders RewardedAd '
        'when tapped on watch video button', (tester) async {
      await tester.pumpApp(SubscribeWithArticleLimitModal());
      await tester.tap(find.byKey(watchVideoButton));
      await tester.pump();
      expect(find.byType(RewardedAd), findsOneWidget);
    });

    testWidgets(
        'adds ArticleRewardedAdWatched to ArticleBloc '
        'when onUserEarnedReward is called on RewardedAd', (tester) async {
      final ArticleBloc articleBloc = MockArticleBloc();

      await tester.pumpApp(
        BlocProvider.value(
          value: articleBloc,
          child: SubscribeWithArticleLimitModal(),
        ),
      );
      await tester.tap(find.byKey(watchVideoButton));
      await tester.pump();

      final rewardedAd = tester.widget<RewardedAd>(find.byType(RewardedAd));
      rewardedAd.onUserEarnedReward(MockAdWithoutView(), MockRewardItem());

      verify(() => articleBloc.add(ArticleRewardedAdWatched())).called(1);
    });

    testWidgets(
        'hides RewardedAd '
        'when onDismissed is called on RewardedAd', (tester) async {
      final ArticleBloc articleBloc = MockArticleBloc();

      await tester.pumpApp(
        BlocProvider.value(
          value: articleBloc,
          child: SubscribeWithArticleLimitModal(),
        ),
      );
      await tester.tap(find.byKey(watchVideoButton));
      await tester.pump();

      final rewardedAd = tester.widget<RewardedAd>(find.byType(RewardedAd));
      rewardedAd.onDismissed!();

      await tester.pump();

      expect(find.byType(RewardedAd), findsNothing);
    });

    testWidgets(
        'hides RewardedAd '
        'when onFailedToLoad is called on RewardedAd', (tester) async {
      final ArticleBloc articleBloc = MockArticleBloc();

      await tester.pumpApp(
        BlocProvider.value(
          value: articleBloc,
          child: SubscribeWithArticleLimitModal(),
        ),
      );
      await tester.tap(find.byKey(watchVideoButton));
      await tester.pump();

      final rewardedAd = tester.widget<RewardedAd>(find.byType(RewardedAd));
      rewardedAd.onFailedToLoad!();

      await tester.pump();

      expect(find.byType(RewardedAd), findsNothing);
    });
  });
}
