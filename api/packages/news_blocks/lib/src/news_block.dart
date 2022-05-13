import 'package:meta/meta.dart';
import 'package:news_blocks/news_blocks.dart';

/// {@template news_block}
/// A reusable news block which represents a content-based component.
/// {@endtemplate}
@immutable
abstract class NewsBlock {
  /// {@macro news_block}
  const NewsBlock({required this.type});

  /// The block type key used to identify the type of block/metadata.
  final String type;

  /// Converts the current instance to a `Map<String, dynamic>`.
  Map<String, dynamic> toJson();

  /// Deserialize [json] into a [NewsBlock] instance.
  /// Returns [UnknownBlock] when the [json] is not a recognized type.
  static NewsBlock fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String?;
    switch (type) {
      case SectionHeaderBlock.identifier:
        return SectionHeaderBlock.fromJson(json);
      case DividerHorizontalBlock.identifier:
        return DividerHorizontalBlock.fromJson(json);
      case SpacerBlock.identifier:
        return SpacerBlock.fromJson(json);
      case PostLargeBlock.identifier:
        return PostLargeBlock.fromJson(json);
      case PostMediumBlock.identifier:
        return PostMediumBlock.fromJson(json);
      case PostSmallBlock.identifier:
        return PostSmallBlock.fromJson(json);
      case PostGridGroupBlock.identifier:
        return PostGridGroupBlock.fromJson(json);
      case PostGridTileBlock.identifier:
        return PostGridTileBlock.fromJson(json);
      case TextCaptionBlock.identifier:
        return TextCaptionBlock.fromJson(json);
      case TextHeadlineBlock.identifier:
        return TextHeadlineBlock.fromJson(json);
      case TextLeadParagraphBlock.identifier:
        return TextLeadParagraphBlock.fromJson(json);
      case TextParagraphBlock.identifier:
        return TextParagraphBlock.fromJson(json);
      case ImageBlock.identifier:
        return ImageBlock.fromJson(json);
    }
    return const UnknownBlock();
  }
}
