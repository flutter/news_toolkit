// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_example/ads/ads.dart';
import 'package:flutter_news_example/app/app.dart';
import 'package:flutter_news_example/article/article.dart';
import 'package:flutter_news_example/subscriptions/subscriptions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart' as ads;
import 'package:in_app_purchase_repository/in_app_purchase_repository.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:news_blocks_ui/news_blocks_ui.dart';
import 'package:user_repository/user_repository.dart';

import '../../helpers/helpers.dart';

class MockArticleBloc extends MockBloc<ArticleEvent, ArticleState>
    implements ArticleBloc {}

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

class MockFullScreenAdsBloc
    extends MockBloc<FullScreenAdsEvent, FullScreenAdsState>
    implements FullScreenAdsBloc {}

class MockRewardItem extends Mock implements ads.RewardItem {}

class MockGoRouter extends Mock implements GoRouter {}

class _MockGoRouterState extends Mock implements GoRouterState {}

class _MockBuildContext extends Mock implements BuildContext {}

void main() {
  initMockHydratedStorage();
  late GoRouterState goRouterState;
  late BuildContext context;

  group('ArticlePage', () {
    late GoRouter goRouter;
    late FullScreenAdsBloc fullScreenAdsBloc;
    late AppBloc appBloc;

    setUp(() {
      goRouter = MockGoRouter();
      fullScreenAdsBloc = MockFullScreenAdsBloc();
      appBloc = MockAppBloc();
      whenListen(
        fullScreenAdsBloc,
        Stream.value(FullScreenAdsState.initial()),
        initialState: FullScreenAdsState.initial(),
      );
      goRouterState = _MockGoRouterState();
      context = _MockBuildContext();
    });

    testWidgets('routeBuilder builds a ArticlePage', (tester) async {
      when(() => goRouterState.pathParameters).thenReturn({'id': 'id'});
      when(() => goRouterState.uri)
          .thenReturn(Uri(queryParameters: {'isVideoArticle': 'true'}));

      final page = ArticlePage.routeBuilder(context, goRouterState);

      expect(page, isA<ArticlePage>());
    });

    testWidgets('renders ArticleView', (tester) async {
      await tester.pumpApp(
        fullScreenAdsBloc: fullScreenAdsBloc,
        InheritedGoRouter(
          goRouter: goRouter,
          child: ArticlePage(
            id: 'id',
            isVideoArticle: false,
            interstitialAdBehavior: InterstitialAdBehavior.onOpen,
          ),
        ),
      );
      expect(find.byType(ArticleView), findsOneWidget);
    });

    testWidgets('provides ArticleBloc', (tester) async {
      await tester.pumpApp(
        fullScreenAdsBloc: fullScreenAdsBloc,
        InheritedGoRouter(
          goRouter: goRouter,
          child: ArticlePage(
            id: 'id',
            isVideoArticle: false,
            interstitialAdBehavior: InterstitialAdBehavior.onOpen,
          ),
        ),
      );
      final BuildContext viewContext = tester.element(find.byType(ArticleView));
      expect(viewContext.read<ArticleBloc>(), isNotNull);
    });

    group('ArticleView', () {
      late ArticleBloc articleBloc;

      setUp(() {
        articleBloc = MockArticleBloc();
        when(() => articleBloc.state).thenReturn(ArticleState.initial());
      });

      testWidgets('renders AppBar', (tester) async {
        await tester.pumpApp(
          fullScreenAdsBloc: fullScreenAdsBloc,
          BlocProvider.value(
            value: articleBloc,
            child: ArticleView(
              isVideoArticle: false,
              interstitialAdBehavior: InterstitialAdBehavior.onOpen,
            ),
          ),
        );
        expect(find.byType(AppBar), findsOneWidget);
      });

      group('renders ShareButton ', () {
        testWidgets('when url is not empty', (tester) async {
          when(() => articleBloc.state).thenReturn(
            ArticleState.initial().copyWith(uri: Uri(path: 'notEmptyUrl')),
          );
          await tester.pumpApp(
            fullScreenAdsBloc: fullScreenAdsBloc,
            BlocProvider.value(
              value: articleBloc,
              child: ArticleView(
                isVideoArticle: false,
                interstitialAdBehavior: InterstitialAdBehavior.onOpen,
              ),
            ),
          );
          expect(find.byType(ShareButton), findsOneWidget);
        });

        testWidgets('that adds ShareRequested on ShareButton tap',
            (tester) async {
          when(() => articleBloc.state).thenReturn(
            ArticleState.initial().copyWith(
              uri: Uri(path: 'notEmptyUrl'),
            ),
          );
          await tester.pumpApp(
            fullScreenAdsBloc: fullScreenAdsBloc,
            BlocProvider.value(
              value: articleBloc,
              child: ArticleView(
                isVideoArticle: false,
                interstitialAdBehavior: InterstitialAdBehavior.onOpen,
              ),
            ),
          );

          await tester.tap(find.byType(ShareButton));

          verify(
            () => articleBloc.add(
              ShareRequested(
                uri: Uri(path: 'notEmptyUrl'),
              ),
            ),
          ).called(1);
        });
      });

      group('does not render ShareButton', () {
        testWidgets('when url is empty', (tester) async {
          await tester.pumpApp(
            fullScreenAdsBloc: fullScreenAdsBloc,
            BlocProvider.value(
              value: articleBloc,
              child: ArticleView(
                isVideoArticle: false,
                interstitialAdBehavior: InterstitialAdBehavior.onOpen,
              ),
            ),
          );
          expect(find.byType(ShareButton), findsNothing);
        });
      });

      testWidgets('renders ArticleSubscribeButton', (tester) async {
        await tester.pumpApp(
          fullScreenAdsBloc: fullScreenAdsBloc,
          BlocProvider.value(
            value: articleBloc,
            child: ArticleView(
              isVideoArticle: false,
              interstitialAdBehavior: InterstitialAdBehavior.onOpen,
            ),
          ),
        );
        expect(find.byType(ArticleSubscribeButton), findsOneWidget);
      });

      group('ArticleSubscribeButton', () {
        testWidgets('renders AppButton', (tester) async {
          await tester.pumpApp(
            Row(
              children: [ArticleSubscribeButton()],
            ),
          );
          expect(find.byType(AppButton), findsOneWidget);
        });

        group('opens PurchaseSubscriptionDialog', () {
          late InAppPurchaseRepository inAppPurchaseRepository;

          setUp(() {
            inAppPurchaseRepository = MockInAppPurchaseRepository();

            when(() => inAppPurchaseRepository.purchaseUpdate).thenAnswer(
              (_) => const Stream.empty(),
            );

            when(inAppPurchaseRepository.fetchSubscriptions).thenAnswer(
              (_) async => [],
            );
          });

          testWidgets('when tapped', (tester) async {
            await tester.pumpApp(
              Row(children: [ArticleSubscribeButton()]),
              inAppPurchaseRepository: inAppPurchaseRepository,
            );
            await tester.tap(find.byType(ArticleSubscribeButton));
            await tester.pump();
            expect(find.byType(PurchaseSubscriptionDialog), findsOneWidget);
          });
        });

        testWidgets('does nothing when tapped', (tester) async {
          await tester.pumpApp(
            Row(
              children: [ArticleSubscribeButton()],
            ),
          );
          await tester.tap(find.byType(ArticleSubscribeButton));
        });
      });

      testWidgets('renders ArticleContent in ArticleThemeOverride',
          (tester) async {
        await tester.pumpApp(
          fullScreenAdsBloc: fullScreenAdsBloc,
          BlocProvider.value(
            value: articleBloc,
            child: ArticleView(
              isVideoArticle: false,
              interstitialAdBehavior: InterstitialAdBehavior.onOpen,
            ),
          ),
        );
        expect(
          find.descendant(
            of: find.byType(ArticleThemeOverride),
            matching: find.byType(ArticleContent),
          ),
          findsOneWidget,
        );
      });

      testWidgets(
          'renders AppBar with ShareButton and '
          'ArticleSubscribeButton action '
          'when user is not a subscriber '
          'and uri is provided', (tester) async {
        when(() => articleBloc.state).thenReturn(
          ArticleState.initial().copyWith(
            uri: Uri(path: 'notEmptyUrl'),
          ),
        );
        await tester.pumpApp(
          fullScreenAdsBloc: fullScreenAdsBloc,
          BlocProvider.value(
            value: articleBloc,
            child: ArticleView(
              isVideoArticle: false,
              interstitialAdBehavior: InterstitialAdBehavior.onOpen,
            ),
          ),
        );

        final articleSubscribeButton = find.byType(ArticleSubscribeButton);
        final shareButton = find.byKey(Key('articlePage_shareButton'));

        expect(articleSubscribeButton, findsOneWidget);
        expect(shareButton, findsOneWidget);

        final appBar = find.byType(AppBar).first;

        expect(
          tester.widget<AppBar>(appBar).actions,
          containsAll(
            <Widget>[
              tester.widget<ArticleSubscribeButton>(articleSubscribeButton),
              tester.widget(shareButton),
            ],
          ),
        );
      });

      testWidgets(
          'renders AppBar without ShareButton '
          'when user is not a subscriber '
          'and uri is not provided', (tester) async {
        await tester.pumpApp(
          fullScreenAdsBloc: fullScreenAdsBloc,
          BlocProvider.value(
            value: articleBloc,
            child: ArticleView(
              isVideoArticle: false,
              interstitialAdBehavior: InterstitialAdBehavior.onOpen,
            ),
          ),
        );

        final subscribeButton = tester.widget<ArticleSubscribeButton>(
          find.byType(ArticleSubscribeButton),
        );

        expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is AppBar &&
                widget.actions!.isNotEmpty &&
                widget.actions!.contains(subscribeButton),
          ),
          findsOneWidget,
        );
        expect(find.byType(ShareButton), findsNothing);
      });

      testWidgets(
          'renders AppBar with ShareButton '
          'action when user is a subscriber '
          'and url is not empty', (tester) async {
        when(() => appBloc.state).thenReturn(
          AppState.authenticated(
            User(
              id: 'id',
              name: 'name',
              email: 'email',
              subscriptionPlan: SubscriptionPlan.premium,
            ),
          ),
        );

        when(() => articleBloc.state).thenReturn(
          ArticleState.initial().copyWith(uri: Uri(path: 'notEmptyUrl')),
        );

        await tester.pumpApp(
          fullScreenAdsBloc: fullScreenAdsBloc,
          appBloc: appBloc,
          BlocProvider.value(
            value: articleBloc,
            child: ArticleView(
              isVideoArticle: false,
              interstitialAdBehavior: InterstitialAdBehavior.onOpen,
            ),
          ),
        );

        final shareButton = find.byKey(Key('articlePage_shareButton'));

        expect(shareButton, findsOneWidget);

        final appBar = find.byType(AppBar).first;

        expect(
          tester.widget<AppBar>(appBar).actions,
          containsAll(
            <Widget>[
              tester.widget(shareButton),
            ],
          ),
        );
      });

      group('navigates', () {
        testWidgets('back when back button is pressed', (tester) async {
          final navigator = MockNavigator();
          when(navigator.canPop).thenAnswer((_) => true);
          when(navigator.pop).thenAnswer((_) async {});
          await tester.pumpApp(
            fullScreenAdsBloc: fullScreenAdsBloc,
            BlocProvider.value(
              value: articleBloc,
              child: ArticleView(
                isVideoArticle: false,
                interstitialAdBehavior: InterstitialAdBehavior.onOpen,
              ),
            ),
            navigator: navigator,
          );
          await tester.tap(find.byType(AppBackButton));
          await tester.pump();
          verify(navigator.pop).called(1);
        });
      });

      testWidgets(
          'adds ArticleRequested to ArticleBloc '
          'when hasReachedArticleViewsLimit changes to false', (tester) async {
        whenListen(
          articleBloc,
          Stream.fromIterable(
            [
              ArticleState.initial()
                  .copyWith(hasReachedArticleViewsLimit: true),
              ArticleState.initial()
                  .copyWith(hasReachedArticleViewsLimit: false),
            ],
          ),
        );
        await tester.pumpApp(
          fullScreenAdsBloc: fullScreenAdsBloc,
          BlocProvider.value(
            value: articleBloc,
            child: ArticleView(
              isVideoArticle: false,
              interstitialAdBehavior: InterstitialAdBehavior.onOpen,
            ),
          ),
        );
        verify(() => articleBloc.add(ArticleRequested()));
      });

      testWidgets(
          'adds ShowInterstitialAdRequested to FullScreenAdsBloc '
          'when interstitialAdBehavior is onOpen and '
          'showInterstitialAd is true', (tester) async {
        whenListen(
          articleBloc,
          Stream.fromIterable(
            [
              ArticleState.initial().copyWith(showInterstitialAd: false),
              ArticleState.initial().copyWith(showInterstitialAd: true),
            ],
          ),
        );

        await tester.pumpApp(
          fullScreenAdsBloc: fullScreenAdsBloc,
          BlocProvider.value(
            value: articleBloc,
            child: ArticleView(
              isVideoArticle: false,
              interstitialAdBehavior: InterstitialAdBehavior.onOpen,
            ),
          ),
        );
        verify(() => fullScreenAdsBloc.add(ShowInterstitialAdRequested()))
            .called(1);
      });

      testWidgets(
          'verify ShowInterstitialAdRequested is not '
          'added to FullScreenAdsBloc when interstitialAdBehavior is onOpen '
          'and showInterstitialAd is false', (tester) async {
        whenListen(
          articleBloc,
          Stream.fromIterable(
            [
              ArticleState.initial().copyWith(showInterstitialAd: false),
            ],
          ),
        );

        await tester.pumpApp(
          fullScreenAdsBloc: fullScreenAdsBloc,
          BlocProvider.value(
            value: articleBloc,
            child: ArticleView(
              isVideoArticle: false,
              interstitialAdBehavior: InterstitialAdBehavior.onOpen,
            ),
          ),
        );

        verifyNever(() => fullScreenAdsBloc.add(ShowInterstitialAdRequested()));
      });

      testWidgets(
          'adds ShowInterstitialAdRequested to FullScreenAdsBloc '
          'when interstitialAdBehavior in onClose and '
          'showInterstitialAd is true', (tester) async {
        when(() => articleBloc.state).thenReturn(
          ArticleState.initial().copyWith(showInterstitialAd: true),
        );

        await tester.pumpApp(
          fullScreenAdsBloc: fullScreenAdsBloc,
          BlocProvider.value(
            value: articleBloc,
            child: ArticleView(
              isVideoArticle: false,
              interstitialAdBehavior: InterstitialAdBehavior.onClose,
            ),
          ),
        );

        await tester.tap(find.byType(AppBackButton));

        verify(() => fullScreenAdsBloc.add(ShowInterstitialAdRequested()))
            .called(1);
      });

      testWidgets(
          'verify ShowInterstitialAdRequested is not '
          'added to FullScreenAdsBloc when interstitialAdBehavior is onClose '
          'showInterstitialAd is false ', (tester) async {
        when(() => articleBloc.state).thenReturn(ArticleState.initial());

        await tester.pumpApp(
          fullScreenAdsBloc: fullScreenAdsBloc,
          BlocProvider.value(
            value: articleBloc,
            child: ArticleView(
              isVideoArticle: false,
              interstitialAdBehavior: InterstitialAdBehavior.onClose,
            ),
          ),
        );

        await tester.tap(find.byType(AppBackButton));

        verifyNever(() => fullScreenAdsBloc.add(ShowInterstitialAdRequested()));
      });

      testWidgets(
          'adds ShowInterstitialAdRequested to FullScreenAdsBloc '
          'with video article '
          'when interstitialAdBehavior in onClose and '
          'showInterstitialAd is true', (tester) async {
        when(() => articleBloc.state).thenReturn(
          ArticleState.initial().copyWith(showInterstitialAd: true),
        );

        await tester.pumpApp(
          fullScreenAdsBloc: fullScreenAdsBloc,
          BlocProvider.value(
            value: articleBloc,
            child: ArticleView(
              isVideoArticle: true,
              interstitialAdBehavior: InterstitialAdBehavior.onClose,
            ),
          ),
        );

        await tester.tap(find.byType(AppBackButton));

        verify(() => fullScreenAdsBloc.add(ShowInterstitialAdRequested()))
            .called(1);
      });

      testWidgets(
          'adds ArticleRewardedAdWatched to ArticleBloc '
          'when earnedReward is not null', (tester) async {
        whenListen(
          fullScreenAdsBloc,
          Stream.fromIterable([
            FullScreenAdsState.initial().copyWith(
              earnedReward: MockRewardItem(),
            ),
          ]),
          initialState: FullScreenAdsState.initial(),
        );

        await tester.pumpApp(
          fullScreenAdsBloc: fullScreenAdsBloc,
          BlocProvider.value(
            value: articleBloc,
            child: ArticleView(
              isVideoArticle: false,
              interstitialAdBehavior: InterstitialAdBehavior.onOpen,
            ),
          ),
        );

        verify(() => articleBloc.add(ArticleRewardedAdWatched())).called(1);
      });
    });
  });
}
