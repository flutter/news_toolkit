import 'package:json_annotation/json_annotation.dart';
import 'package:news_blocks/news_blocks.dart';

part 'post_large_block.g.dart';

/// {@template post_large_block}
/// A block which represents a large post block.
/// https://www.figma.com/file/RajSN6YbRqTuqvdKYtij3b/Google-News-Template-App-v3?node-id=391%3A18585
/// {@endtemplate}
@JsonSerializable()
class PostLargeBlock extends PostBlock {
  /// {@macro post_large_block}
  const PostLargeBlock({
    required String id,
    required PostCategory category,
    required String author,
    required DateTime publishedAt,
    required String imageUrl,
    required String title,
    String? description,
    BlockAction? action,
    String type = PostLargeBlock.identifier,
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

  /// Converts a `Map<String, dynamic>` into a [PostLargeBlock] instance.
  factory PostLargeBlock.fromJson(Map<String, dynamic> json) =>
      _$PostLargeBlockFromJson(json);

  /// The large post block type identifier.
  static const identifier = '__post_large__';

  @override
  Map<String, dynamic> toJson() => _$PostLargeBlockToJson(this);
}
