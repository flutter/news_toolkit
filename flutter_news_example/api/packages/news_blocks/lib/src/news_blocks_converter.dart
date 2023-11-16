import 'package:json_annotation/json_annotation.dart';
import 'package:news_blocks/news_blocks.dart';

/// {@template news_blocks_converter}
/// A [JsonConverter] that supports (de)serializing a `List<NewsBlock>`.
/// {@endtemplate}
class NewsBlocksConverter
    implements JsonConverter<List<NewsBlock>, List<dynamic>> {
  /// {@macro news_blocks_converter}
  const NewsBlocksConverter();

  @override
  List<Map<String, dynamic>> toJson(List<NewsBlock> blocks) {
    return blocks.map((b) => b.toJson()).toList();
  }

  @override
  List<NewsBlock> fromJson(List<dynamic> jsonString) {
    return jsonString
        .map((dynamic e) => NewsBlock.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
