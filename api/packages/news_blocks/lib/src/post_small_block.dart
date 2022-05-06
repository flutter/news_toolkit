import 'package:json_annotation/json_annotation.dart';
import 'package:news_blocks/news_blocks.dart';

part 'post_small_block.g.dart';

/// {@template post_small_block}
/// A block which represents a small post block.
/// https://www.figma.com/file/RajSN6YbRqTuqvdKYtij3b/Google-News-Template-App-v3?node-id=391%3A18585
/// {@endtemplate}
@JsonSerializable()
class PostSmallBlock extends PostBlock {
  /// {@macro post_small_block}
  const PostSmallBlock({
    required String id,
    required PostCategory category,
    required String author,
    required DateTime publishedAt,
    required String title,
    String? imageUrl,
    String? description,
    BlockAction? action,
    String type = PostSmallBlock.identifier,
    bool isPremium = false,
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
        );

  /// Converts a `Map<String, dynamic>` into a [PostSmallBlock] instance.
  factory PostSmallBlock.fromJson(Map<String, dynamic> json) =>
      _$PostSmallBlockFromJson(json);

  /// The small post block type identifier.
  static const identifier = '__post_small__';

  @override
  Map<String, dynamic> toJson() => _$PostSmallBlockToJson(this);
}
