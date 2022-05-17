import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:news_blocks/news_blocks.dart';

part 'related_articles.g.dart';

/// {@template related_articles}
/// An object which contains paginated related article contents.
/// {@endtemplate}
@JsonSerializable()
class RelatedArticles extends Equatable {
  /// {@macro related_articles}
  const RelatedArticles({required this.blocks, required this.totalBlocks});

  /// {@macro related_articles}
  const RelatedArticles.empty() : this(blocks: const [], totalBlocks: 0);

  /// Converts a `Map<String, dynamic>` into a [RelatedArticles] instance.
  factory RelatedArticles.fromJson(Map<String, dynamic> json) =>
      _$RelatedArticlesFromJson(json);

  /// The list of news blocks for the associated related articles (paginated).
  @NewsBlocksConverter()
  final List<NewsBlock> blocks;

  /// The total number of blocks for the related articles.
  final int totalBlocks;

  /// Converts the current instance to a `Map<String, dynamic>`.
  Map<String, dynamic> toJson() => _$RelatedArticlesToJson(this);

  @override
  List<Object> get props => [blocks, totalBlocks];
}
