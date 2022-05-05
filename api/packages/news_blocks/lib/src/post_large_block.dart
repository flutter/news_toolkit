import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:news_blocks/news_blocks.dart';

part 'post_large_block.g.dart';

/// {@template post_large_block}
/// A block which represents a large post block.
/// https://www.figma.com/file/RajSN6YbRqTuqvdKYtij3b/Google-News-Template-App-v3?node-id=391%3A18585
/// {@endtemplate}
@JsonSerializable()
class PostLargeBlock with EquatableMixin implements NewsBlock {
  /// {@macro post_large_block}
  const PostLargeBlock({
    required this.id,
    required this.category,
    required this.author,
    required this.publishedAt,
    required this.imageUrl,
    required this.title,
    this.description,
    this.action,
    this.type = PostLargeBlock.identifier,
    this.isPremium = false,
  });

  /// Converts a `Map<String, dynamic>` into a [BlockAction] instance.
  factory PostLargeBlock.fromJson(Map<String, dynamic> json) =>
      _$PostLargeBlockFromJson(json);

  /// The large post block type identifier.
  static const identifier = '__post_large__';

  /// The identifier of this post.
  final String id;

  /// The category of this post.
  final PostCategory category;

  /// The author of this post.
  final String author;

  /// The date when this post was published.
  final DateTime publishedAt;

  /// The image URL of this post.
  final String imageUrl;

  /// The title of this post.
  final String title;

  /// The optional description of this post.
  final String? description;

  /// An optional action which occurs upon interaction.
  final BlockAction? action;

  /// Whether this post requires a premium subscription to access.
  ///
  /// Defaults to false.
  final bool isPremium;

  @override
  final String type;

  @override
  Map<String, dynamic> toJson() => _$PostLargeBlockToJson(this);

  @override
  List<Object?> get props => [
        id,
        category,
        author,
        publishedAt,
        imageUrl,
        title,
        description,
        action,
        isPremium,
        type,
      ];
}
