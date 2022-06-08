// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/ads/ads.dart';
import 'package:google_news_template/article/article.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:news_blocks_ui/news_blocks_ui.dart';

import '../../helpers/helpers.dart';

class MockArticleBloc extends MockBloc<ArticleEvent, ArticleState>
    implements ArticleBloc {}

void main() {
  group('ArticlePage', () {
    test('has a route', () {
      expect(ArticlePage.route(id: 'id'), isA<MaterialPageRoute>());
    });

    testWidgets('renders ArticleView', (tester) async {
      await tester.pumpApp(ArticlePage(id: 'id'));
      expect(find.byType(ArticleView), findsOneWidget);
    });

    testWidgets('provides ArticleBloc', (tester) async {
      await tester.pumpApp(ArticlePage(id: 'id'));
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
          child: ArticleView(),
        ),
      );
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('renders ShareButton', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: articleBloc,
          child: ArticleView(),
        ),
      );
      expect(find.byType(ShareButton), findsOneWidget);
    });

    testWidgets('renders ArticleSubscribeButton', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: articleBloc,
          child: ArticleView(),
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
          child: ArticleView(),
        ),
      );
      expect(find.byType(InterstitialAd), findsOneWidget);
    });

    testWidgets('renders ArticleContent', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: articleBloc,
          child: ArticleView(),
        ),
      );
      expect(find.byType(ArticleContent), findsOneWidget);
    });

    testWidgets(
        'renders AppBar with ShareButton title and '
        'ArticleSubscribeButton action when user is not a subscriber',
        (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: articleBloc,
          child: ArticleView(),
        ),
      );

      final subscribeButton = tester
          .widget<ArticleSubscribeButton>(find.byType(ArticleSubscribeButton));

      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is AppBar &&
              widget.title is ShareButton &&
              widget.actions!.isNotEmpty &&
              widget.actions!.contains(subscribeButton),
        ),
        findsOneWidget,
      );
    });

    testWidgets(
        'renders AppBar with empty title and ShareButton '
        'action when user is a subscriber', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: articleBloc,
          child: ArticleView(isSubscriber: true),
        ),
      );

      final shareButton = tester.widget<Padding>(
        find.byWidgetPredicate(
          (widget) =>
              widget.key == Key('articlePage_shareButton') &&
              widget is Padding &&
              widget.child is ShareButton,
        ),
      );

      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is AppBar &&
              widget.title is SizedBox &&
              widget.actions!.isNotEmpty &&
              widget.actions!.contains(shareButton),
        ),
        findsOneWidget,
      );
    });

    group('navigates', () {
      testWidgets('back when back button is pressed', (tester) async {
        final navigator = MockNavigator();
        when(navigator.pop).thenAnswer((_) async {});
        await tester.pumpApp(
          BlocProvider.value(
            value: articleBloc,
            child: ArticleView(),
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
