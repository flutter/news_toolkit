import 'package:json_annotation/json_annotation.dart';
import 'package:news_blocks/news_blocks.dart';

part 'article_introduction_block.g.dart';

/// {@template post_large_block}
/// A block which represents an article introduction block.
/// https://www.figma.com/file/RajSN6YbRqTuqvdKYtij3b/Google-News-Template-App-v3?node-id=1394%3A51730
/// {@endtemplate}
@JsonSerializable()
class ArticleIntroductionBlock extends PostBlock {
  /// {@macro post_large_block}
  const ArticleIntroductionBlock({
    required super.id,
    required super.category,
    required super.author,
    required super.publishedAt,
    required super.title,
    super.imageUrl,
    super.type = ArticleIntroductionBlock.identifier,
    super.isPremium,
  });

  /// Converts a `Map<String, dynamic>`
  /// into a [ArticleIntroductionBlock] instance.
  factory ArticleIntroductionBlock.fromJson(Map<String, dynamic> json) =>
      _$ArticleIntroductionBlockFromJson(json);

  /// The large post block type identifier.
  static const identifier = '__post_large__';

  @override
  Map<String, dynamic> toJson() => _$ArticleIntroductionBlockToJson(this);
}
