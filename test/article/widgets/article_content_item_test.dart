// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart' hide Spacer, Image;
import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/article/article.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_blocks_ui/news_blocks_ui.dart';

import '../../helpers/helpers.dart';

void main() {
  group('ArticleContentItem', () {
    testWidgets(
        'renders DividerHorizontal '
        'for DividerHorizontalBlock', (tester) async {
      const block = DividerHorizontalBlock();
      await tester.pumpApp(ArticleContentItem(block: block));
      expect(
        find.byWidgetPredicate(
          (widget) => widget is DividerHorizontal && widget.block == block,
        ),
        findsOneWidget,
      );
    });

    testWidgets(
        'renders Spacer '
        'for SpacerBlock', (tester) async {
      const block = SpacerBlock(spacing: Spacing.large);
      await tester.pumpApp(ArticleContentItem(block: block));
      expect(
        find.byWidgetPredicate(
          (widget) => widget is Spacer && widget.block == block,
        ),
        findsOneWidget,
      );
    });

    testWidgets(
        'renders Image '
        'for ImageBlock', (tester) async {
      const block = ImageBlock(imageUrl: 'imageUrl');
      await tester.pumpApp(ArticleContentItem(block: block));
      expect(
        find.byWidgetPredicate(
          (widget) => widget is Image && widget.block == block,
        ),
        findsOneWidget,
      );
    });

    testWidgets(
        'renders TextCaption '
        'for TextCaptionBlock', (tester) async {
      const block = TextCaptionBlock(
        text: 'text',
        color: TextCaptionColor.normal,
      );
      await tester.pumpApp(ArticleContentItem(block: block));
      expect(
        find.byWidgetPredicate(
          (widget) => widget is TextCaption && widget.block == block,
        ),
        findsOneWidget,
      );
    });

    testWidgets(
        'renders TextHeadline '
        'for TextHeadlineBlock', (tester) async {
      const block = TextHeadlineBlock(text: 'text');
      await tester.pumpApp(ArticleContentItem(block: block));
      expect(
        find.byWidgetPredicate(
          (widget) => widget is TextHeadline && widget.block == block,
        ),
        findsOneWidget,
      );
    });

    testWidgets(
        'renders TextLeadParagraph '
        'for TextLeadParagraphBlock', (tester) async {
      const block = TextLeadParagraphBlock(text: 'text');
      await tester.pumpApp(ArticleContentItem(block: block));
      expect(
        find.byWidgetPredicate(
          (widget) => widget is TextLeadParagraph && widget.block == block,
        ),
        findsOneWidget,
      );
    });

    testWidgets(
        'renders TextParagraph '
        'for TextParagraphBlock', (tester) async {
      const block = TextParagraphBlock(text: 'text');
      await tester.pumpApp(ArticleContentItem(block: block));
      expect(
        find.byWidgetPredicate(
          (widget) => widget is TextParagraph && widget.block == block,
        ),
        findsOneWidget,
      );
    });

    testWidgets(
        'renders Video '
        'for VideoBlock', (tester) async {
      const block = VideoBlock(videoUrl: 'videoUrl');
      await tester.pumpApp(ArticleContentItem(block: block));
      expect(
        find.byWidgetPredicate(
          (widget) => widget is Video && widget.block == block,
        ),
        findsOneWidget,
      );
    });

    testWidgets(
        'renders ArticleIntroduction '
        'for ArticleIntroductionBlock', (tester) async {
      final block = ArticleIntroductionBlock(
        category: PostCategory.technology,
        author: 'author',
        publishedAt: DateTime(2022, 3, 9),
        imageUrl: 'imageUrl',
        title: 'title',
      );
      await tester.pumpApp(
        ListView(
          children: [
            ArticleContentItem(block: block),
          ],
        ),
      );
      expect(
        find.byWidgetPredicate(
          (widget) => widget is ArticleIntroduction && widget.block == block,
        ),
        findsOneWidget,
      );
    });

    testWidgets(
        'renders SizedBox '
        'for unsupported block', (tester) async {
      final block = UnknownBlock();
      await tester.pumpApp(ArticleContentItem(block: block));
      expect(find.byType(SizedBox), findsOneWidget);
    });
  });
}
