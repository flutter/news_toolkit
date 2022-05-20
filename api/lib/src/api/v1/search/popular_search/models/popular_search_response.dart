import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:news_blocks/news_blocks.dart';

part 'popular_search_response.g.dart';

/// {@template popular_search_response}
/// A search response object which contains popular news content.
/// {@endtemplate}
@JsonSerializable()
class PopularSearchResponse extends Equatable {
  /// {@macro popular_search_response}
  const PopularSearchResponse({required this.articles, required this.topics});

  /// Converts a `Map<String, dynamic>` into a [PopularSearchResponse] instance.
  factory PopularSearchResponse.fromJson(Map<String, dynamic> json) =>
      _$PopularSearchResponseFromJson(json);

  /// The article content blocks.
  @NewsBlocksConverter()
  final List<NewsBlock> articles;

  /// The associated popular topics.
  final List<String> topics;

  /// Converts the current instance to a `Map<String, dynamic>`.
  Map<String, dynamic> toJson() => _$PopularSearchResponseToJson(this);

  @override
  List<Object> get props => [articles, topics];
}
