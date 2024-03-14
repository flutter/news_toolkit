import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:news_blocks/news_blocks.dart';

part 'feed_response.g.dart';

/// {@template feed_response}
/// A news feed response object which contains news feed metadata.
/// {@endtemplate}
@JsonSerializable()
class FeedResponse extends Equatable {
  /// {@macro feed_response}
  const FeedResponse({required this.feed, required this.totalCount});

  /// Converts a `Map<String, dynamic>` into a [FeedResponse] instance.
  factory FeedResponse.fromJson(Map<String, dynamic> json) =>
      _$FeedResponseFromJson(json);

  /// The associated feed (composition of blocks).
  @NewsBlocksConverter()
  final List<NewsBlock> feed;

  /// The total number of available blocks.
  final int totalCount;

  /// Converts the current instance to a `Map<String, dynamic>`.
  Map<String, dynamic> toJson() => _$FeedResponseToJson(this);

  @override
  List<Object> get props => [feed, totalCount];
}
