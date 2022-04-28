import 'package:json_annotation/json_annotation.dart';
import 'package:news_blocks/news_blocks.dart';

part 'feed.g.dart';

/// {@template feed}
/// A news feed response object which contains news feed metadata.
/// {@endtemplate}
@JsonSerializable()
class Feed {
  /// {@macro feed}
  const Feed({required this.blocks});

  /// Converts a `Map<String, dynamic>` into a [Feed] instance.
  factory Feed.fromJson(Map<String, dynamic> json) => _$FeedFromJson(json);

  /// The list of news blocks for the associated feed.
  @_NewsBlocksConverter()
  final List<NewsBlock> blocks;

  /// Converts the current instance to a `Map<String, dynamic>`.
  Map<String, dynamic> toJson() => _$FeedToJson(this);
}

class _NewsBlocksConverter
    implements JsonConverter<List<NewsBlock>, List<Map<String, dynamic>>> {
  const _NewsBlocksConverter();

  @override
  List<Map<String, dynamic>> toJson(List<NewsBlock> blocks) {
    return blocks.map((b) => b.toJson()).toList();
  }

  @override
  List<NewsBlock> fromJson(List<Map<String, dynamic>> jsonString) {
    return jsonString.map(NewsBlock.fromJson).toList();
  }
}
