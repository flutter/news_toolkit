// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/ads/ads.dart';
import 'package:google_news_template/app/app.dart';
import 'package:google_news_template/article/article.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:news_blocks_ui/news_blocks_ui.dart';
import 'package:in_app_purchase_repository/in_app_purchase_repository.dart';
import 'package:user_repository/user_repository.dart';

import '../../helpers/helpers.dart';

class MockArticleBloc extends MockBloc<ArticleEvent, ArticleState>
    implements ArticleBloc {}

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

void main() {
  group('ArticlePage', () {
    test('has a route', () {
      expect(ArticlePage.route(id: 'id'), isA<MaterialPageRoute>());
    });

    testWidgets('renders ArticleView', (tester) async {
      await tester.pumpApp(
        ArticlePage(
          id: 'id',
          isVideoArticle: false,
        ),
      );
      expect(find.byType(ArticleView), findsOneWidget);
    });

    testWidgets('provides ArticleBloc', (tester) async {
      await tester.pumpApp(
        ArticlePage(
          id: 'id',
          isVideoArticle: false,
        ),
      );
      final BuildContext viewContext = tester.element(find.byType(ArticleView));
      expect(viewContext.read<ArticleBloc>(), isNotNull);
    });
  });

  group('ArticleView', () {
    late ArticleBloc articleBloc;

    setUp(() {
      articleBloc = MockArticleBloc();

      when(() => articleBloc.state).thenReturn(ArticleState.initial());
    });

    testWidgets('renders AppBar', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: articleBloc,
          child: ArticleView(isVideoArticle: false),
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

      testWidgets('does nothing when tapped', (tester) async {
        await tester.pumpApp(
          Row(
            children: [ArticleSubscribeButton()],
          ),
        );
        await tester.tap(find.byType(ArticleSubscribeButton));
      });
    });

    testWidgets('renders InterstitialAd', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: articleBloc,
          child: ArticleView(isVideoArticle: false),
        ),
      );
      expect(find.byType(InterstitialAd), findsOneWidget);
    });

    testWidgets('renders ArticleContent in ArticleThemeOverride',
        (tester) async {
      await tester.pumpApp(
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
        BlocProvider.value(
          value: articleBloc,
          child: ArticleView(isVideoArticle: false),
        ),
      );

      final subscribeButton = tester
          .widget<ArticleSubscribeButton>(find.byType(ArticleSubscribeButton));

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
          ),
          userSubscriptionPlan: SubscriptionPlan.premium,
        ),
      );

      when(() => articleBloc.state).thenReturn(
        ArticleState.initial().copyWith(uri: Uri(path: 'notEmptyUrl')),
      );

      await tester.pumpApp(
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
  });
}
