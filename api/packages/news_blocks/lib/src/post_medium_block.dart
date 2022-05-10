import 'package:json_annotation/json_annotation.dart';
import 'package:news_blocks/news_blocks.dart';

part 'post_medium_block.g.dart';

/// {@template post_medium_block}
/// A block which represents a medium post block.
/// https://www.figma.com/file/RajSN6YbRqTuqvdKYtij3b/Google-News-Template-App-v3?node-id=391%3A18585
/// {@endtemplate}
@JsonSerializable()
class PostMediumBlock extends PostBlock {
  /// {@macro post_medium_block}
  const PostMediumBlock({
    required String id,
    required PostCategory category,
    required String author,
    required DateTime publishedAt,
    required String imageUrl,
    required String title,
    String? description,
    BlockAction? action,
    String type = PostMediumBlock.identifier,
    bool isPremium = false,
    bool isContentOverlaid = false,
  }) : super(
          id: id,
          category: category,
          author: author,
          publishedAt: publishedAt,
          imageUrl: imageUrl,
          title: title,
          type: type,
          description: description,
          action: action,
          isPremium: isPremium,
          isContentOverlaid: isContentOverlaid,
        );

  /// Converts a `Map<String, dynamic>` into a [PostMediumBlock] instance.
  factory PostMediumBlock.fromJson(Map<String, dynamic> json) =>
      _$PostMediumBlockFromJson(json);

  /// The medium post block type identifier.
  static const identifier = '__post_medium__';

  @override
  Map<String, dynamic> toJson() => _$PostMediumBlockToJson(this);
}
