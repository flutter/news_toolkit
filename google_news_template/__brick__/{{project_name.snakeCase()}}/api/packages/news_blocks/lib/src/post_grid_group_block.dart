import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:news_blocks/news_blocks.dart';

part 'post_grid_group_block.g.dart';

/// {@template post_grid_group_block}
/// A block which represents a post grid group.
/// https://www.figma.com/file/RajSN6YbRqTuqvdKYtij3b/Google-News-Template-App-v3?node-id=391%3A18875
/// {@endtemplate}
@JsonSerializable()
class PostGridGroupBlock with EquatableMixin implements NewsBlock {
  /// {@macro post_grid_group_block}
  const PostGridGroupBlock({
    required this.category,
    required this.tiles,
    this.type = PostGridGroupBlock.identifier,
  });

  /// Converts a `Map<String, dynamic>` into a [PostGridGroupBlock] instance.
  factory PostGridGroupBlock.fromJson(Map<String, dynamic> json) =>
      _$PostGridGroupBlockFromJson(json);

  /// The post grid block type identifier.
  static const identifier = '__post_grid_group__';

  /// The category of this post grid group.
  final PostCategory category;

  /// The associated list of [PostGridTileBlock] tiles.
  @NewsBlocksConverter()
  final List<PostGridTileBlock> tiles;

  @override
  final String type;

  @override
  Map<String, dynamic> toJson() => _$PostGridGroupBlockToJson(this);

  @override
  List<Object?> get props => [category, tiles, type];
}
