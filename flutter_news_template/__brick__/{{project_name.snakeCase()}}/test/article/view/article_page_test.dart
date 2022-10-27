// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart' as ads;
import 'package:{{project_name.snakeCase()}}/ads/ads.dart';
import 'package:{{project_name.snakeCase()}}/app/app.dart';
import 'package:{{project_name.snakeCase()}}/article/article.dart';
import 'package:{{project_name.snakeCase()}}/subscriptions/subscriptions.dart';
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

void main() {
  group('ArticlePage', () {
    late FullScreenAdsBloc fullScreenAdsBloc;

    setUp(() {
      fullScreenAdsBloc = MockFullScreenAdsBloc();
      whenListen(
        fullScreenAdsBloc,
        Stream.value(FullScreenAdsState.initial()),
        initialState: FullScreenAdsState.initial(),
      );
    });

    test('has a route', () {
      expect(ArticlePage.route(id: 'id'), isA<MaterialPageRoute>());
    });

    testWidgets('renders ArticleView', (tester) async {
      await mockHydratedStorage(
        () => tester.pumpApp(
          fullScreenAdsBloc: fullScreenAdsBloc,
          ArticlePage(
            id: 'id',
            isVideoArticle: false,
          ),
        ),
      );
      expect(find.byType(ArticleView), findsOneWidget);
    });

    testWidgets('provides ArticleBloc', (tester) async {
      await mockHydratedStorage(
        () => tester.pumpApp(
          fullScreenAdsBloc: fullScreenAdsBloc,
          ArticlePage(
            id: 'id',
            isVideoArticle: false,
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
        await mockHydratedStorage(
          () => tester.pumpApp(
            fullScreenAdsBloc: fullScreenAdsBloc,
            BlocProvider.value(
              value: articleBloc,
              child: ArticleView(isVideoArticle: false),
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
              child: ArticleView(isVideoArticle: false),
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
              child: ArticleView(isVideoArticle: false),
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
              child: ArticleView(isVideoArticle: false),
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
            child: ArticleView(isVideoArticle: false),
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
            child: ArticleView(isVideoArticle: false),
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
            child: ArticleView(isVideoArticle: false),
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
            child: ArticleView(isVideoArticle: false),
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
        final appBloc = MockAppBloc();
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
            child: ArticleView(isVideoArticle: false),
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
          when(navigator.pop).thenAnswer((_) async {});
          await tester.pumpApp(
            fullScreenAdsBloc: fullScreenAdsBloc,
            BlocProvider.value(
              value: articleBloc,
              child: ArticleView(isVideoArticle: false),
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
            child: ArticleView(isVideoArticle: false),
          ),
        );
        verify(() => articleBloc.add(ArticleRequested()));
      });

      testWidgets(
          'adds ShowInterstitialAdRequested to FullScreenAdsBloc '
          'when shown', (tester) async {
        await tester.pumpApp(
          fullScreenAdsBloc: fullScreenAdsBloc,
          BlocProvider.value(
            value: articleBloc,
            child: ArticleView(isVideoArticle: false),
          ),
        );
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
            child: ArticleView(isVideoArticle: false),
          ),
        );

        verify(() => articleBloc.add(ArticleRewardedAdWatched())).called(1);
      });
    });
  });
}
