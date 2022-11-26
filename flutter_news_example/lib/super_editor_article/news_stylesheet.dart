import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_example/article/widgets/article_theme_override.dart';
import 'package:flutter_news_example/super_editor_article/banner_ad.dart';
import 'package:flutter_news_example/super_editor_article/divider.dart';
import 'package:flutter_news_example/super_editor_article/newsletter.dart';
import 'package:flutter_news_example/super_editor_article/slideshow.dart';
import 'package:flutter_news_example/super_editor_article/trending_story.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:super_editor/super_editor.dart';

import 'news_document.dart';
import 'share.dart';

Stylesheet createNewsStylesheet(BuildContext context) {
  return Stylesheet(
    documentPadding: EdgeInsets.zero,
    inlineTextStyler: defaultInlineTextStyler,
    rules: [
      StyleRule(
        BlockSelector.all,
        (doc, docNode) {
          return {
            "maxWidth": double.infinity,
            "padding": const CascadingPadding.symmetric(horizontal: AppSpacing.lg),
            "textStyle": Theme.of(context).textTheme.bodyText1,
          };
        },
      ),
      StyleRule(
        const BlockSelector("image").atIndex(0),
        (doc, docNode) {
          return {
            "padding": const CascadingPadding.only(left: 0, right: 0, bottom: 16),
          };
        },
      ),
      StyleRule(
        BlockSelector(shareBlock.name),
        (doc, docNode) {
          return {
            "padding": const CascadingPadding.all(0),
          };
        },
      ),
      StyleRule(
        BlockSelector(header1Attribution.name),
        (doc, docNode) {
          return {
            "textStyle": Theme.of(context).textTheme.headline2,
          };
        },
      ),
      StyleRule(
        const BlockSelector(TextLeadParagraphBlock.identifier),
        (doc, docNode) {
          return {
            "textStyle": Theme.of(context).textTheme.headline6,
          };
        },
      ),
      StyleRule(
        const BlockSelector("paragraph"),
        (doc, docNode) {
          return {
            "textStyle": Theme.of(context).textTheme.bodyText1,
          };
        },
      ),
      StyleRule(
        BlockSelector(categoryBlock.name),
        (doc, docNode) {
          return {
            "padding": const CascadingPadding.only(bottom: 8),
            "textStyle": Theme.of(context).textTheme.overline!.copyWith(
                  color: AppColors.secondary,
                ),
          };
        },
      ),
      StyleRule(
        BlockSelector(titleBlock.name),
        (doc, docNode) {
          return {
            "padding": const CascadingPadding.only(bottom: 12),
            "textStyle": Theme.of(context).textTheme.headline3,
          };
        },
      ),
      StyleRule(
        BlockSelector(byLineBlock.name),
        (doc, docNode) {
          return {
            "padding": const CascadingPadding.only(bottom: 32),
            "textStyle": Theme.of(context).textTheme.caption,
          };
        },
      ),
      StyleRule(
        BlockSelector(normalCaptionBlock.name),
        (doc, docNode) {
          return {
            "textStyle": Theme.of(context).textTheme.caption?.apply(
                  color:
                      Theme.of(context).extension<ArticleThemeColors>()?.captionNormal ?? AppColors.highEmphasisSurface,
                ),
          };
        },
      ),
      StyleRule(
        BlockSelector(lightCaptionBlock.name),
        (doc, docNode) {
          return {
            "textStyle": Theme.of(context).textTheme.caption?.apply(
                  color:
                      Theme.of(context).extension<ArticleThemeColors>()?.captionLight ?? AppColors.highEmphasisSurface,
                ),
          };
        },
      ),
      StyleRule(
        BlockSelector(slideshowBlock.name),
        (doc, docNode) {
          return {
            "padding": const CascadingPadding.symmetric(horizontal: AppSpacing.lg),
          };
        },
      ),
      StyleRule(
        BlockSelector(newsletterBlock.name),
        (doc, docNode) {
          return {
            "padding": const CascadingPadding.all(0),
          };
        },
      ),
      StyleRule(
        BlockSelector(bannerAdBlock.name),
        (doc, docNode) {
          return {
            "padding": const CascadingPadding.all(0),
          };
        },
      ),
      StyleRule(
        BlockSelector(trendingStoryBlock.name),
        (doc, docNode) {
          return {
            "padding": const CascadingPadding.all(0),
          };
        },
      ),
      StyleRule(
        BlockSelector(dividerBlock.name),
        (doc, docNode) {
          return {
            "padding": const CascadingPadding.all(0),
          };
        },
      ),
    ],
  );
}
