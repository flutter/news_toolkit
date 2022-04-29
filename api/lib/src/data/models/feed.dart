import 'package:json_annotation/json_annotation.dart';
import 'package:news_blocks/news_blocks.dart';

part 'feed.g.dart';

/// {@template feed}
/// A news feed object which contains paginated news feed metadata.
/// {@endtemplate}
@JsonSerializable()
class Feed {
  /// {@macro feed}
  const Feed({required this.blocks, required this.totalBlocks});

  /// Converts a `Map<String, dynamic>` into a [Feed] instance.
  factory Feed.fromJson(Map<String, dynamic> json) => _$FeedFromJson(json);

  /// The list of news blocks for the associated feed (paginated).
  @NewsBlocksConverter()
  final List<NewsBlock> blocks;

  /// The total number of blocks for this feed.
  final int totalBlocks;

  /// Converts the current instance to a `Map<String, dynamic>`.
  Map<String, dynamic> toJson() => _$FeedToJson(this);
}

/// {@template news_blocks_converter}
/// A [JsonConverter] that supports (de)serializing a `List<NewsBlock>`.
/// {@endtemplate}
class NewsBlocksConverter
    implements JsonConverter<List<NewsBlock>, List<Map<String, dynamic>>> {
  /// {@macro news_blocks_converter}
  const NewsBlocksConverter();

  @override
  List<Map<String, dynamic>> toJson(List<NewsBlock> blocks) {
    return blocks.map((b) => b.toJson()).toList();
  }

  @override
  List<NewsBlock> fromJson(List<Map<String, dynamic>> jsonString) {
    return jsonString.map(NewsBlock.fromJson).toList();
  }
}
