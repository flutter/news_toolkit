// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_news_template/analytics/analytics.dart';
import 'package:flutter_news_template/app/app.dart';
import 'package:flutter_news_template/article/article.dart';
import 'package:flutter_news_template/login/login.dart';
import 'package:flutter_news_template/subscriptions/subscriptions.dart';
import 'package:in_app_purchase_repository/in_app_purchase_repository.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:user_repository/user_repository.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../helpers/helpers.dart';

class MockArticleBloc extends MockBloc<ArticleEvent, ArticleState>
    implements ArticleBloc {}

class MockAnalyticsBloc extends MockBloc<AnalyticsEvent, AnalyticsState>
    implements AnalyticsBloc {}

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

class MockUser extends Mock implements User {}

void main() {
  late AppBloc appBloc;
  late User user;
  late AnalyticsBloc analyticsBloc;
  late ArticleBloc articleBloc;

  const subscribeButtonKey = Key('subscribeModal_subscribeButton');
  const logInButtonKey = Key('subscribeModal_logInButton');

  setUp(() {
    user = MockUser();
    appBloc = MockAppBloc();
    analyticsBloc = MockAnalyticsBloc();
    articleBloc = MockArticleBloc();

    when(() => articleBloc.state).thenReturn(
      ArticleState(status: ArticleStatus.initial, title: 'title'),
    );
    when(() => appBloc.state).thenReturn(AppState.unauthenticated());

    VisibilityDetectorController.instance.updateInterval = Duration.zero;
  });

  group('SubscribeModal', () {
    group('renders', () {
      testWidgets('subscribe button when user is authenticated',
          (tester) async {
        when(() => appBloc.state).thenReturn(AppState.authenticated(user));
        await tester.pumpApp(
          BlocProvider.value(
            value: articleBloc,
            child: SubscribeModal(),
          ),
          appBloc: appBloc,
        );
        expect(find.byKey(subscribeButtonKey), findsOneWidget);
        expect(find.byKey(logInButtonKey), findsNothing);
      });

      testWidgets('subscribe and log in buttons when user is unauthenticated',
          (tester) async {
        when(() => appBloc.state).thenReturn(AppState.unauthenticated());
        await tester.pumpApp(
          BlocProvider.value(
            value: articleBloc,
            child: SubscribeModal(),
          ),
          appBloc: appBloc,
        );
        expect(find.byKey(subscribeButtonKey), findsOneWidget);
        expect(find.byKey(logInButtonKey), findsOneWidget);
      });
    });

    group('opens PurchaseSubscriptionDialog', () {
      late InAppPurchaseRepository inAppPurchaseRepository;
      late ArticleBloc articleBloc;

      setUp(() {
        inAppPurchaseRepository = MockInAppPurchaseRepository();
        articleBloc = MockArticleBloc();

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
        final analyticsBloc = MockAnalyticsBloc();

        await tester.pumpApp(
          BlocProvider.value(
            value: articleBloc,
            child: SubscribeModal(),
          ),
          inAppPurchaseRepository: inAppPurchaseRepository,
          analyticsBloc: analyticsBloc,
        );
        await tester.tap(find.byKey(subscribeButtonKey));
        await tester.pump();
        expect(find.byType(PurchaseSubscriptionDialog), findsOneWidget);

        verify(
          () => analyticsBloc.add(
            TrackAnalyticsEvent(
              PaywallPromptEvent.click(articleTitle: 'title'),
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
        BlocProvider.value(
          value: articleBloc,
          child: SubscribeModal(),
        ),
        appBloc: appBloc,
      );

      await tester.tap(find.byKey(logInButtonKey));
      await tester.pumpAndSettle();

      expect(find.byType(LoginModal), findsOneWidget);
    });

    testWidgets(
        'adds TrackAnalyticsEvent to AnalyticsBloc '
        'with PaywallPromptEvent.impression subscription '
        'when shown', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: articleBloc,
          child: SubscribeModal(),
        ),
        analyticsBloc: analyticsBloc,
        appBloc: appBloc,
      );

      verify(
        () => analyticsBloc.add(
          TrackAnalyticsEvent(
            PaywallPromptEvent.impression(
              articleTitle: 'title',
              impression: PaywallPromptImpression.subscription,
            ),
          ),
        ),
      ).called(1);
    });
  });
}
