import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:news_blocks/news_blocks.dart';

part 'relevant_search_response.g.dart';

/// {@template relevant_search_response}
/// A search response object which contains relevant news content.
/// {@endtemplate}
@JsonSerializable()
class RelevantSearchResponse extends Equatable {
  /// {@macro relevant_search_response}
  const RelevantSearchResponse({required this.articles, required this.topics});

  /// Converts a `Map<String, dynamic>` into a
  /// [RelevantSearchResponse] instance.
  factory RelevantSearchResponse.fromJson(Map<String, dynamic> json) =>
      _$RelevantSearchResponseFromJson(json);

  /// The article content blocks.
  @NewsBlocksConverter()
  final List<NewsBlock> articles;

  /// The associated relevant topics.
  final List<String> topics;

  /// Converts the current instance to a `Map<String, dynamic>`.
  Map<String, dynamic> toJson() => _$RelevantSearchResponseToJson(this);

  @override
  List<Object> get props => [articles, topics];
}
