// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/article/article.dart';
import 'package:google_news_template/feed/feed.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_blocks/news_blocks.dart';

import '../../helpers/helpers.dart';

class MockArticleBloc extends MockBloc<ArticleEvent, ArticleState>
    implements ArticleBloc {}

void main() {
  final ArticleBloc bloc = MockArticleBloc();

  final postSmallBlock = PostSmallBlock(
    id: '36f4a017-d099-4fce-8727-1d9ca6a0398c',
    category: PostCategory.technology,
    author: 'Tom Phillips',
    publishedAt: DateTime(2022, 6, 2),
    imageUrl: 'https://assets.reedpopcdn.com/stray_XlfRQmc.jpg/BROK/thumbnail/'
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

  group('ArticleTrailingContent', () {
    testWidgets('renders relatedArticles', (tester) async {
      when(() => bloc.state).thenAnswer(
        (invocation) => ArticleState(
          content: const [
            TextCaptionBlock(text: 'text', color: TextCaptionColor.normal),
            TextParagraphBlock(text: 'text'),
          ],
          status: ArticleStatus.populated,
          hasMoreContent: false,
          relatedArticles: relatedArticles,
        ),
      );

      await tester.pumpApp(
        BlocProvider.value(
          value: bloc,
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
        'renders empty column when '
        'relatedArticles is empty', (tester) async {
      when(() => bloc.state).thenAnswer(
        (invocation) => ArticleState(
          content: const [
            TextCaptionBlock(text: 'text', color: TextCaptionColor.normal),
            TextParagraphBlock(text: 'text'),
          ],
          status: ArticleStatus.populated,
          hasMoreContent: false,
          relatedArticles: [],
        ),
      );

      await tester.pumpApp(
        BlocProvider.value(
          value: bloc,
          child: SingleChildScrollView(
            child: ArticleTrailingContent(),
          ),
        ),
      );

      final columnWidget = tester.widget<Column>(
        find.byKey(Key('articleTrailingContent_column')),
      );
      expect(columnWidget.children, isEmpty);
    });
  });
}
