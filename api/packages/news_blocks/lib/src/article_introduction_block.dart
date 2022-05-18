import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:news_blocks/news_blocks.dart';

part 'article_introduction_block.g.dart';

/// {@template article_introduction_block}
/// A block which represents an article introduction block.
/// https://www.figma.com/file/RajSN6YbRqTuqvdKYtij3b/Google-News-Template-App-v3?node-id=1394%3A51730
/// {@endtemplate}
@JsonSerializable()
class ArticleIntroductionBlock with EquatableMixin implements NewsBlock {
  /// {@macro article_introduction_block}
  const ArticleIntroductionBlock({
    this.type = ArticleIntroductionBlock.identifier,
    required this.category,
    required this.author,
    required this.publishedAt,
    required this.title,
    this.imageUrl,
    this.isPremium = false,
  });

  /// Converts a `Map<String, dynamic>`
  /// into a [ArticleIntroductionBlock] instance.
  factory ArticleIntroductionBlock.fromJson(Map<String, dynamic> json) =>
      _$ArticleIntroductionBlockFromJson(json);

  /// The large post block type identifier.
  static const identifier = '__article_introduction__';

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

  /// Whether this post requires a premium subscription to access.
  ///
  /// Defaults to false.
  final bool isPremium;

  @override
  Map<String, dynamic> toJson() => _$ArticleIntroductionBlockToJson(this);

  @override
  final String type;

  @override
  List<Object?> get props => [
        type,
        category,
        author,
        publishedAt,
        imageUrl,
        title,
        isPremium,
      ];
}
