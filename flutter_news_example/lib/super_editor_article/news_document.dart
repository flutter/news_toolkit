import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_news_example/l10n/l10n.dart';
import 'package:flutter_news_example/super_editor_article/banner_ad.dart';
import 'package:flutter_news_example/super_editor_article/divider.dart';
import 'package:flutter_news_example/super_editor_article/newsletter.dart';
import 'package:flutter_news_example/super_editor_article/share.dart';
import 'package:flutter_news_example/super_editor_article/slideshow.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:super_editor/super_editor.dart';

import 'spacer.dart';
import 'trending_story.dart';
import 'video.dart';

MutableDocument createNewsDocument(
  BuildContext context,
  List<NewsBlock> blocks, {
  VoidCallback? onSharePressed,
}) {
  print("Creating a document...");
  final document = MutableDocument();

  for (final block in blocks) {
    print(" - creating node for block: $block");
    switch (block.type) {
      case ArticleIntroductionBlock.identifier:
        print("    - ^ handled!");
        final intro = block as ArticleIntroductionBlock;

        if (intro.imageUrl != null) {
          document.add(
            ImageNode(
              id: DocumentEditor.createNodeId(),
              imageUrl: intro.imageUrl!,
              metadata: {
                "blockType": "headerImage",
              },
            ),
          );
        }

        document //
          ..add(
            ParagraphNode(
              id: DocumentEditor.createNodeId(),
              text: AttributedText(
                text: intro.category.name.toUpperCase(),
              ),
              metadata: {
                "blockType": categoryBlock,
              },
            ),
          )
          ..add(
            ParagraphNode(
              id: DocumentEditor.createNodeId(),
              text: AttributedText(
                text: intro.title,
              ),
              metadata: {
                "blockType": titleBlock,
              },
            ),
          )
          ..add(
            ParagraphNode(
              id: DocumentEditor.createNodeId(),
              text: AttributedText(
                text: "${intro.publishedAt.mDY} • ${intro.author}",
              ),
              metadata: {
                "blockType": byLineBlock,
              },
            ),
          )
          ..add(
            ShareNode(
              id: DocumentEditor.createNodeId(),
              shareText: context.l10n.shareText,
              onSharePressed: onSharePressed,
            ),
          );

        break;
      case ImageBlock.identifier:
        print("    - ^ handled!");
        document.add(
          ImageNode(
            id: DocumentEditor.createNodeId(),
            imageUrl: (block as ImageBlock).imageUrl,
          ),
        );
        break;
      case TextLeadParagraphBlock.identifier:
        print("    - ^ handled!");
        final textLeadBlock = block as TextLeadParagraphBlock;
        document.add(
          ParagraphNode(
            id: DocumentEditor.createNodeId(),
            text: AttributedText(
              text: textLeadBlock.text,
              spans: AttributedSpans(
                attributions: [
                  SpanMarker(attribution: boldAttribution, offset: 0, markerType: SpanMarkerType.start),
                  SpanMarker(
                      attribution: boldAttribution,
                      offset: textLeadBlock.text.length - 1,
                      markerType: SpanMarkerType.end),
                ],
              ),
            ),
            metadata: {
              "blockType": const NamedAttribution(TextLeadParagraphBlock.identifier),
            },
          ),
        );
        break;
      case TextHeadlineBlock.identifier:
        print("    - ^ handled!");
        final textLeadBlock = block as TextHeadlineBlock;
        document.add(
          ParagraphNode(
            id: DocumentEditor.createNodeId(),
            text: AttributedText(
              text: textLeadBlock.text,
            ),
            metadata: {
              "blockType": header1Attribution,
            },
          ),
        );
        break;
      case TextParagraphBlock.identifier:
        print("    - ^ handled!");
        final textLeadBlock = block as TextParagraphBlock;
        document.add(
          ParagraphNode(
            id: DocumentEditor.createNodeId(),
            text: AttributedText(
              text: textLeadBlock.text,
            ),
          ),
        );
        break;
      case TextCaptionBlock.identifier:
        print("    - ^ handled!");
        final caption = block as TextCaptionBlock;
        document.add(
          ParagraphNode(
            id: DocumentEditor.createNodeId(),
            text: AttributedText(
              text: caption.text,
            ),
            metadata: {
              "blockType": block.color == TextCaptionColor.normal //
                  ? normalCaptionBlock
                  : lightCaptionBlock,
            },
          ),
        );
        break;
      case VideoBlock.identifier:
        print("    - ^ handled!");
        final video = block as VideoBlock;
        document.add(
          VideoNode(id: DocumentEditor.createNodeId(), videoUrl: video.videoUrl),
        );
        break;
      case SlideshowIntroductionBlock.identifier:
        print("    - ^ handled!");
        final slideshow = block as SlideshowIntroductionBlock;
        document.add(
          SlideshowNode(
            id: DocumentEditor.createNodeId(),
            coverImageUrl: slideshow.coverImageUrl,
            slideshowText: context.l10n.slideshow,
            title: slideshow.title,
          ),
        );
        break;
      case BannerAdBlock.identifier:
        print("    - ^ handled!");
        final bannerAd = block as BannerAdBlock;
        document.add(
          BannerAdNode(
            id: DocumentEditor.createNodeId(),
            size: bannerAd.size,
            adFailedToLoadTitle: context.l10n.adLoadFailure,
          ),
        );
        break;
      case NewsletterBlock.identifier:
        print("    - ^ handled!");
        document.add(NewsletterNode(id: DocumentEditor.createNodeId()));
        break;
      case TrendingStoryBlock.identifier:
        print("    - ^ handled!");
        final trendingStory = block as TrendingStoryBlock;
        document.add(
          TrendingStoryNode(
            id: DocumentEditor.createNodeId(),
            title: context.l10n.trendingStoryTitle,
            content: trendingStory.content,
          ),
        );
        break;
      case DividerHorizontalBlock.identifier:
        print("    - ^ handled!");
        document.add(DividerNode(id: DocumentEditor.createNodeId()));
        break;
      case SpacerBlock.identifier:
        print("    - ^ handled!");
        final spacer = block as SpacerBlock;
        document.add(
          SpacerNode(
            id: DocumentEditor.createNodeId(),
            spacing: spacer.spacing,
          ),
        );
        break;
      default:
        break;
    }
  }
  print("Done creating document");

  return document;
}

const categoryBlock = NamedAttribution("category");
const titleBlock = NamedAttribution("title");
const byLineBlock = NamedAttribution("byLine");
const normalCaptionBlock = NamedAttribution("captionNormal");
const lightCaptionBlock = NamedAttribution("captionLight");
