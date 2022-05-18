import 'package:equatable/equatable.dart';
import 'package:news_blocks/news_blocks.dart';

/// {@template post_block}
/// An abstract block which represents a post block.
/// {@endtemplate}
abstract class PostBlock with EquatableMixin implements NewsBlock {
  /// {@macro post_block}
  const PostBlock({
    required this.id,
    required this.category,
    required this.author,
    required this.publishedAt,
    required this.title,
    required this.type,
    this.imageUrl,
    this.description,
    this.action,
    this.isPremium = false,
    this.isContentOverlaid = false,
  });

  /// The medium post block type identifier.
  static const identifier = '__post_medium__';

  /// The identifier of this post.
  final String id;

  /// The category of this post.
  final PostCategory category;

  /// The author of this post.
  final String author;

  /// The date when this post was published.
  final DateTime publishedAt;

  /// The image URL of this post.
  final String? imageUrl;

  /// The title of this post.
  final String title;

  /// The optional description of this post.
  final String? description;

  /// An optional action which occurs upon interaction.
  @BlockActionConverter()
  final BlockAction? action;

  /// Whether this post requires a premium subscription to access.
  ///
  /// Defaults to false.
  final bool isPremium;

  /// Whether the content of this post is overlaid on the image.
  ///
  /// Defaults to false.
  final bool isContentOverlaid;

  @override
  final String type;

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
        isContentOverlaid,
        type,
      ];
}

/// The extension on [PostBlock] that provides information about actions.
extension PostBlockActions on PostBlock {
  /// Whether the action of this post is navigation.
  bool get hasNavigationAction =>
      action?.actionType == BlockActionType.navigation;
}
