// ignore_for_file: prefer_const_constructors, avoid_redundant_argument_values
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:{{project_name.snakeCase()}}/app/app.dart';
import 'package:{{project_name.snakeCase()}}/article/article.dart';
import 'package:{{project_name.snakeCase()}}/feed/feed.dart';
import 'package:{{project_name.snakeCase()}}/subscriptions/subscriptions.dart';
import 'package:{{project_name.snakeCase()}}_api/client.dart' hide User;
import 'package:mocktail/mocktail.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:user_repository/user_repository.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../helpers/helpers.dart';

class MockArticleBloc extends MockBloc<ArticleEvent, ArticleState>
    implements ArticleBloc {}

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

class MockUser extends Mock implements User {}

void main() {
  group('ArticleTrailingContent', () {
    late ArticleBloc articleBloc;
    late AppBloc appBloc;

    final postSmallBlock = PostSmallBlock(
      id: '36f4a017-d099-4fce-8727-1d9ca6a0398c',
      category: PostCategory.technology,
      author: 'Tom Phillips',
      publishedAt: DateTime(2022, 6, 2),
      imageUrl:
          'https://assets.reedpopcdn.com/stray_XlfRQmc.jpg/BROK/thumbnail/'
          '1600x900/format/jpg/quality/80/stray_XlfRQmc.jpg',
      title: 'Stray launches next month, included in pricier PlayStation '
          'Plus tiers on day one',
      description: "Stray, everyone's favorite upcoming cyberpunk cat game, "
          'launches for PC, PlayStation 4 and PS5 on 19th July.',
      action: const NavigateToArticleAction(
        articleId: '36f4a017-d099-4fce-8727-1d9ca6a0398c',
      ),
    );

    final relatedArticles = [
      postSmallBlock,
      PostSmallBlock.fromJson(postSmallBlock.toJson()..['id'] = 'newId'),
    ];

    setUp(() {
      articleBloc = MockArticleBloc();
      appBloc = MockAppBloc();
    });

    testWidgets(
        'renders relatedArticles '
        'when article is not preview', (tester) async {
      final user = MockUser();
      when(() => user.subscriptionPlan).thenReturn(SubscriptionPlan.premium);
      when(() => articleBloc.state).thenReturn(
        ArticleState(
          content: const [
            TextCaptionBlock(text: 'text', color: TextCaptionColor.normal),
            TextParagraphBlock(text: 'text'),
          ],
          status: ArticleStatus.populated,
          hasMoreContent: false,
          relatedArticles: relatedArticles,
          isPreview: false,
        ),
      );

      when(() => appBloc.state).thenReturn(
        AppState.authenticated(user),
      );

      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: articleBloc),
            BlocProvider.value(value: appBloc),
          ],
          child: SingleChildScrollView(
            child: ArticleTrailingContent(),
          ),
        ),
      );

      for (final article in relatedArticles) {
        expect(
          find.byWidgetPredicate(
            (widget) => widget is CategoryFeedItem && widget.block == article,
          ),
          findsOneWidget,
        );
      }
    });

    testWidgets(
        'renders only ArticleComments when '
        'relatedArticles is empty', (tester) async {
      when(() => articleBloc.state).thenAnswer(
        (invocation) => ArticleState(
          content: const [
            TextCaptionBlock(text: 'text', color: TextCaptionColor.normal),
            TextParagraphBlock(text: 'text'),
          ],
          status: ArticleStatus.populated,
          hasMoreContent: false,
          relatedArticles: [],
          hasReachedArticleViewsLimit: false,
        ),
      );

      await tester.pumpApp(
        BlocProvider.value(
          value: articleBloc,
          child: SingleChildScrollView(
            child: ArticleTrailingContent(),
          ),
        ),
      );

      expect(find.byType(CategoryFeedItem), findsNothing);
      expect(find.byType(ArticleComments), findsOneWidget);
    });

    group('when article is preview', () {
      setUp(() {
        final user = MockUser();
        when(() => user.subscriptionPlan).thenReturn(SubscriptionPlan.none);
        when(() => articleBloc.state).thenReturn(
          ArticleState(
            content: const [
              TextCaptionBlock(text: 'text', color: TextCaptionColor.normal),
              TextParagraphBlock(text: 'text'),
            ],
            status: ArticleStatus.populated,
            hasMoreContent: false,
            relatedArticles: relatedArticles,
            isPreview: true,
          ),
        );

        when(() => appBloc.state).thenReturn(AppState.authenticated(user));
      });

      testWidgets('does not render relatedArticles', (tester) async {
        await tester.pumpApp(
          MultiBlocProvider(
            providers: [
              BlocProvider.value(value: articleBloc),
              BlocProvider.value(value: appBloc),
            ],
            child: SingleChildScrollView(
              child: ArticleTrailingContent(),
            ),
          ),
        );

        expect(find.byType(CategoryFeedItem), findsNothing);
      });

      testWidgets('does not render ArticleComments', (tester) async {
        await tester.pumpApp(
          MultiBlocProvider(
            providers: [
              BlocProvider.value(value: articleBloc),
              BlocProvider.value(value: appBloc),
            ],
            child: SingleChildScrollView(
              child: ArticleTrailingContent(),
            ),
          ),
        );

        expect(find.byType(ArticleComments), findsNothing);
      });

      testWidgets('renders ArticleTrailingShadow', (tester) async {
        await tester.pumpApp(
          MultiBlocProvider(
            providers: [
              BlocProvider.value(value: articleBloc),
              BlocProvider.value(value: appBloc),
            ],
            child: SingleChildScrollView(
              child: ArticleTrailingContent(),
            ),
          ),
        );

        expect(find.byType(ArticleTrailingShadow), findsOneWidget);
      });

      testWidgets(
          'renders SubscribeModal '
          'when article is premium and user is not a subscriber',
          (tester) async {
        when(() => articleBloc.state).thenReturn(
          ArticleState(
            content: const [
              TextCaptionBlock(text: 'text', color: TextCaptionColor.normal),
              TextParagraphBlock(text: 'text'),
            ],
            status: ArticleStatus.populated,
            hasMoreContent: false,
            relatedArticles: relatedArticles,
            isPreview: true,
            isPremium: true,
          ),
        );
        VisibilityDetectorController.instance.updateInterval = Duration.zero;

        await tester.pumpApp(
          MultiBlocProvider(
            providers: [
              BlocProvider.value(value: articleBloc),
              BlocProvider.value(value: appBloc),
            ],
            child: SingleChildScrollView(
              child: ArticleTrailingContent(),
            ),
          ),
        );

        expect(find.byType(SubscribeModal), findsOneWidget);
        expect(find.byType(SubscribeWithArticleLimitModal), findsNothing);
      });

      testWidgets(
          'does not render SubscribeModal '
          'when article is premium and user is a subscriber', (tester) async {
        final user = MockUser();
        when(() => user.subscriptionPlan).thenReturn(SubscriptionPlan.premium);
        when(() => articleBloc.state).thenReturn(
          ArticleState(
            content: const [
              TextCaptionBlock(text: 'text', color: TextCaptionColor.normal),
              TextParagraphBlock(text: 'text'),
            ],
            status: ArticleStatus.populated,
            hasMoreContent: false,
            relatedArticles: relatedArticles,
            isPreview: true,
            isPremium: true,
          ),
        );

        when(() => appBloc.state).thenReturn(
          AppState.authenticated(
            user,
          ),
        );

        await tester.pumpApp(
          MultiBlocProvider(
            providers: [
              BlocProvider.value(value: articleBloc),
              BlocProvider.value(value: appBloc),
            ],
            child: SingleChildScrollView(
              child: ArticleTrailingContent(),
            ),
          ),
        );

        expect(find.byType(SubscribeModal), findsNothing);
        expect(find.byType(SubscribeWithArticleLimitModal), findsNothing);
      });

      testWidgets(
          'renders SubscribeWithArticleLimitModal '
          'when article is not premium '
          'and user has reached article views limit '
          'and user is not a subscriber', (tester) async {
        when(() => articleBloc.state).thenReturn(
          ArticleState(
            content: const [
              TextCaptionBlock(text: 'text', color: TextCaptionColor.normal),
              TextParagraphBlock(text: 'text'),
            ],
            status: ArticleStatus.populated,
            hasMoreContent: false,
            relatedArticles: relatedArticles,
            isPreview: true,
            hasReachedArticleViewsLimit: true,
          ),
        );

        await tester.pumpApp(
          MultiBlocProvider(
            providers: [
              BlocProvider.value(value: articleBloc),
              BlocProvider.value(value: appBloc),
            ],
            child: SingleChildScrollView(
              child: ArticleTrailingContent(),
            ),
          ),
        );

        expect(find.byType(SubscribeWithArticleLimitModal), findsOneWidget);
        expect(find.byType(SubscribeModal), findsNothing);
      });

      testWidgets(
          'does not render SubscribeWithArticleLimitModal '
          'when article is not premium '
          'and user has reached article views limit '
          'and user is a subscriber', (tester) async {
        final user = MockUser();
        when(() => user.subscriptionPlan).thenReturn(SubscriptionPlan.premium);
        when(() => articleBloc.state).thenReturn(
          ArticleState(
            content: const [
              TextCaptionBlock(text: 'text', color: TextCaptionColor.normal),
              TextParagraphBlock(text: 'text'),
            ],
            status: ArticleStatus.populated,
            hasMoreContent: false,
            relatedArticles: relatedArticles,
            isPreview: true,
            hasReachedArticleViewsLimit: true,
          ),
        );

        when(() => appBloc.state).thenReturn(
          AppState.authenticated(user),
        );

        await tester.pumpApp(
          MultiBlocProvider(
            providers: [
              BlocProvider.value(value: articleBloc),
              BlocProvider.value(value: appBloc),
            ],
            child: SingleChildScrollView(
              child: ArticleTrailingContent(),
            ),
          ),
        );

        expect(find.byType(SubscribeWithArticleLimitModal), findsNothing);
        expect(find.byType(SubscribeModal), findsNothing);
      });
    });
  });
}
