import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:news_blocks/news_blocks.dart';

part 'article_response.g.dart';

/// {@template article_response}
/// A news article response object which contains news article content.
/// {@endtemplate}
@JsonSerializable()
class ArticleResponse extends Equatable {
  /// {@macro article_response}
  const ArticleResponse({
    required this.content,
    required this.totalCount,
    required this.url,
  });

  /// Converts a `Map<String, dynamic>` into a [ArticleResponse] instance.
  factory ArticleResponse.fromJson(Map<String, dynamic> json) =>
      _$ArticleResponseFromJson(json);

  /// The article content blocks.
  @NewsBlocksConverter()
  final List<NewsBlock> content;

  /// The total number of available content blocks.
  final int totalCount;

  /// The url for the associated article.
  final Uri url;

  /// Converts the current instance to a `Map<String, dynamic>`.
  Map<String, dynamic> toJson() => _$ArticleResponseToJson(this);

  @override
  List<Object> get props => [content, totalCount, url];
}
