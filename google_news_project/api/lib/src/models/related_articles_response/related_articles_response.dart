import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:news_blocks/news_blocks.dart';

part 'related_articles_response.g.dart';

/// {@template related_articles_response}
/// A response object which contains related news article content.
/// {@endtemplate}
@JsonSerializable()
class RelatedArticlesResponse extends Equatable {
  /// {@macro related_articles_response}
  const RelatedArticlesResponse({
    required this.relatedArticles,
    required this.totalCount,
  });

  /// Converts a `Map<String, dynamic>` into
  /// a [RelatedArticlesResponse] instance.
  factory RelatedArticlesResponse.fromJson(Map<String, dynamic> json) =>
      _$RelatedArticlesResponseFromJson(json);

  /// The article content blocks.
  @NewsBlocksConverter()
  final List<NewsBlock> relatedArticles;

  /// The total number of available content blocks.
  final int totalCount;

  /// Converts the current instance to a `Map<String, dynamic>`.
  Map<String, dynamic> toJson() => _$RelatedArticlesResponseToJson(this);

  @override
  List<Object> get props => [relatedArticles, totalCount];
}
