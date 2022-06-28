import 'package:flutter/material.dart' hide Spacer, Image;
import 'package:google_news_template/article/article.dart';
import 'package:google_news_template/l10n/l10n.dart';
import 'package:google_news_template/newsletter/newsletter.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_blocks_ui/news_blocks_ui.dart';

class ArticleContentItem extends StatelessWidget {
  const ArticleContentItem({
    super.key,
    required this.block,
    this.onSharePressed,
  });

  /// The associated [NewsBlock] instance.
  final NewsBlock block;

  /// An optional callback which is invoked when the share button is pressed.
  final VoidCallback? onSharePressed;

  @override
  Widget build(BuildContext context) {
    final newsBlock = block;

    if (newsBlock is DividerHorizontalBlock) {
      return DividerHorizontal(block: newsBlock);
    } else if (newsBlock is SpacerBlock) {
      return Spacer(block: newsBlock);
    } else if (newsBlock is ImageBlock) {
      return Image(block: newsBlock);
    } else if (newsBlock is VideoBlock) {
      return Video(block: newsBlock);
    } else if (newsBlock is TextCaptionBlock) {
      final articleThemeColors =
          Theme.of(context).extension<ArticleThemeColors>()!;
      return TextCaption(
        block: newsBlock,
        colorValues: {
          TextCaptionColor.normal: articleThemeColors.captionNormal,
          TextCaptionColor.light: articleThemeColors.captionLight,
        },
      );
    } else if (newsBlock is TextHeadlineBlock) {
      return TextHeadline(block: newsBlock);
    } else if (newsBlock is TextLeadParagraphBlock) {
      return TextLeadParagraph(block: newsBlock);
    } else if (newsBlock is TextParagraphBlock) {
      return TextParagraph(block: newsBlock);
    } else if (newsBlock is ArticleIntroductionBlock) {
      return ArticleIntroduction(
        block: newsBlock,
        shareText: context.l10n.shareText,
        premiumText: context.l10n.newsBlockPremiumText,
        onSharePressed: onSharePressed,
      );
    } else if (newsBlock is VideoIntroductionBlock) {
      return VideoIntroduction(block: newsBlock);
    } else if (newsBlock is BannerAdBlock) {
      return BannerAd(block: newsBlock);
    } else if (newsBlock is NewsletterBlock) {
      return const Newsletter();
    } else if (newsBlock is HtmlBlock) {
      return Html(block: newsBlock);
    } else if (newsBlock is TrendingStoryBlock) {
      return TrendingStory(
        block: newsBlock,
        title: context.l10n.trendingStoryTitle,
      );
    } else if (newsBlock is SlideshowIntroductionBlock) {
      return SlideshowIntroduction(
        block: newsBlock,
        slideshowText: context.l10n.slideshow,
      );
    } else {
      // Render an empty widget for the unsupported block type.
      return const SizedBox();
    }
  }
}
