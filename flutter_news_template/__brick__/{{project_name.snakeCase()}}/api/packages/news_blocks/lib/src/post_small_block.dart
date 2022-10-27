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
    required super.id,
    required super.category,
    required super.author,
    required super.publishedAt,
    required super.title,
    super.imageUrl,
    super.description,
    super.action,
    super.type = PostSmallBlock.identifier,
    super.isPremium,
  });

  /// Converts a `Map<String, dynamic>` into a [PostSmallBlock] instance.
  factory PostSmallBlock.fromJson(Map<String, dynamic> json) =>
      _$PostSmallBlockFromJson(json);

  /// The small post block type identifier.
  static const identifier = '__post_small__';

  @override
  Map<String, dynamic> toJson() => _$PostSmallBlockToJson(this);
}
