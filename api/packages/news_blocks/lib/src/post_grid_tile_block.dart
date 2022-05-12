import 'package:json_annotation/json_annotation.dart';
import 'package:news_blocks/news_blocks.dart';

part 'post_grid_tile_block.g.dart';

/// {@template post_grid_tile_block}
/// A block which represents a post grid tile block.
///
/// Multiple [PostGridTileBlock] blocks form a [PostGridGroupBlock].
/// https://www.figma.com/file/RajSN6YbRqTuqvdKYtij3b/Google-News-Template-App-v3?node-id=391%3A18875
/// {@endtemplate}
@JsonSerializable()
class PostGridTileBlock extends PostBlock {
  /// {@macro post_grid_tile_block}
  const PostGridTileBlock({
    required String id,
    required PostCategory category,
    required String author,
    required DateTime publishedAt,
    required String imageUrl,
    required String title,
    String? description,
    BlockAction? action,
    String type = PostGridTileBlock.identifier,
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
          isContentOverlaid: true,
        );

  /// Converts a `Map<String, dynamic>` into a [PostGridTileBlock] instance.
  factory PostGridTileBlock.fromJson(Map<String, dynamic> json) =>
      _$PostGridTileBlockFromJson(json);

  /// The post grid tile block type identifier.
  static const identifier = '__post_grid_tile__';

  @override
  Map<String, dynamic> toJson() => _$PostGridTileBlockToJson(this);
}

/// {@template post_grid_tile_block_ext}
/// Converts [PostGridTileBlock] into a [PostBlock] instance.
/// {@endtemplate}
extension PostGridTileBlockExt on PostGridTileBlock {
  /// Converts [PostGridTileBlock] into a [PostLargeBlock] instance.
  PostLargeBlock toPostLargeBlock() => PostLargeBlock(
        id: id,
        category: category,
        author: author,
        publishedAt: publishedAt,
        imageUrl: imageUrl!,
        title: title,
        isContentOverlaid: true,
        description: description,
        action: action,
      );

  /// Converts [PostGridTileBlock] into a [PostMediumBlock] instance.
  PostMediumBlock toPostMediumBlock() => PostMediumBlock(
        id: id,
        category: category,
        author: author,
        publishedAt: publishedAt,
        imageUrl: imageUrl!,
        title: title,
        isContentOverlaid: true,
        description: description,
        action: action,
      );
}
