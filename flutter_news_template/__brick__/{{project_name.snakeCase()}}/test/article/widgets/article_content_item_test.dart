// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart' hide Image, Spacer;
import 'package:{{project_name.snakeCase()}}/article/article.dart';
import 'package:{{project_name.snakeCase()}}/newsletter/newsletter.dart';
import 'package:{{project_name.snakeCase()}}/slideshow/slideshow.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_blocks_ui/news_blocks_ui.dart';
import 'package:video_player_platform_interface/video_player_platform_interface.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../helpers/helpers.dart';
import '../helpers/helpers.dart';

void main() {
  initMockHydratedStorage();

  void setUpVideoPlayerPlatform() {
    final fakeVideoPlayerPlatform = FakeVideoPlayerPlatform();
    VideoPlayerPlatform.instance = fakeVideoPlayerPlatform;
  }

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
        'with colorValues from ArticleThemeColors '
        'for TextCaptionBlock', (tester) async {
      const block = TextCaptionBlock(
        text: 'text',
        color: TextCaptionColor.normal,
      );

      late ArticleThemeColors colors;
      await tester.pumpApp(
        ArticleThemeOverride(
          isVideoArticle: false,
          child: Builder(
            builder: (context) {
              colors = Theme.of(context).extension<ArticleThemeColors>()!;
              return ArticleContentItem(block: block);
            },
          ),
        ),
      );

      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is TextCaption &&
              widget.block == block &&
              widget.colorValues[TextCaptionColor.normal] ==
                  colors.captionNormal &&
              widget.colorValues[TextCaptionColor.light] == colors.captionLight,
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
      setUpVideoPlayerPlatform();
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
      const category = Category(id: 'technology', name: 'Technology');
      final block = ArticleIntroductionBlock(
        categoryId: category.id,
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
        'renders VideoIntroduction '
        'for VideoIntroductionBlock', (tester) async {
      setUpVideoPlayerPlatform();
      const category = Category(id: 'technology', name: 'Technology');
      final block = VideoIntroductionBlock(
        categoryId: category.id,
        title: 'title',
        videoUrl: 'videoUrl',
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
          (widget) => widget is VideoIntroduction && widget.block == block,
        ),
        findsOneWidget,
      );
    });

    testWidgets(
        'renders BannerAd '
        'for BannerAdBlock', (tester) async {
      final block = BannerAdBlock(size: BannerAdSize.normal);
      await tester.pumpApp(ArticleContentItem(block: block));
      expect(find.byType(BannerAd), findsOneWidget);
    });

    testWidgets(
        'renders Newsletter '
        'for NewsletterBlock', (tester) async {
      VisibilityDetectorController.instance.updateInterval = Duration.zero;
      final block = NewsletterBlock();
      await tester.pumpApp(ArticleContentItem(block: block));
      expect(find.byType(Newsletter), findsOneWidget);
    });

    testWidgets(
        'renders Html '
        'for HtmlBlock', (tester) async {
      final block = HtmlBlock(content: '<p>Lorem</p>');
      await tester.pumpApp(ArticleContentItem(block: block));
      expect(find.byType(Html), findsOneWidget);
    });

    testWidgets(
        'renders SlideshowIntroduction '
        'for SlideshowIntroductionBlock', (tester) async {
      final block = SlideshowIntroductionBlock(
        title: 'title',
        coverImageUrl: 'coverImageUrl',
        action: NavigateToSlideshowAction(
          slideshow: SlideshowBlock(
            slides: [],
            title: 'title',
          ),
          articleId: 'articleId',
        ),
      );
      await tester.pumpApp(
        ListView(
          children: [
            ArticleContentItem(block: block),
          ],
        ),
      );

      await tester.ensureVisible(find.byType(SlideshowIntroduction));
      await tester.tap(find.byType(SlideshowIntroduction));
      await tester.pumpAndSettle();
      expect(
        find.byType(SlideshowPage),
        findsOneWidget,
      );
    });
  });

  testWidgets(
      'renders SizedBox '
      'for unsupported block', (tester) async {
    final block = UnknownBlock();
    await tester.pumpApp(ArticleContentItem(block: block));
    expect(find.byType(SizedBox), findsOneWidget);
  });

  testWidgets(
      'renders TrendingStory '
      'for TrendingStoryBlock', (tester) async {
    const category = Category(id: 'health', name: 'Health');
    final content = PostSmallBlock(
      id: 'id',
      categoryId: category.id,
      author: 'author',
      publishedAt: DateTime(2022, 3, 11),
      imageUrl: 'imageUrl',
      title: 'title',
    );
    final block = TrendingStoryBlock(content: content);
    await tester.pumpApp(ArticleContentItem(block: block));
    expect(find.byType(TrendingStory), findsOneWidget);
  });
}
