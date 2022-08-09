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
    required super.id,
    required super.category,
    required super.author,
    required super.publishedAt,
    required String super.imageUrl,
    required super.title,
    super.description,
    super.action,
    super.type = PostLargeBlock.identifier,
    super.isPremium,
    super.isContentOverlaid,
  });

  /// Converts a `Map<String, dynamic>` into a [PostLargeBlock] instance.
  factory PostLargeBlock.fromJson(Map<String, dynamic> json) =>
      _$PostLargeBlockFromJson(json);

  /// The large post block type identifier.
  static const identifier = '__post_large__';

  @override
  Map<String, dynamic> toJson() => _$PostLargeBlockToJson(this);
}
