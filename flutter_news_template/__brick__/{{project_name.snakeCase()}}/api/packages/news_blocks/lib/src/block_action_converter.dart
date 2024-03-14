import 'package:json_annotation/json_annotation.dart';
import 'package:news_blocks/news_blocks.dart';

/// {@template block_action_converter}
/// A [JsonConverter] that supports (de)serializing a [BlockAction].
/// {@endtemplate}
class BlockActionConverter
    implements JsonConverter<BlockAction?, Map<String, dynamic>?> {
  /// {@macro block_action_converter}
  const BlockActionConverter();

  @override
  Map<String, dynamic>? toJson(BlockAction? blockAction) =>
      blockAction?.toJson();

  @override
  BlockAction? fromJson(Object? jsonString) => jsonString != null
      ? BlockAction.fromJson(jsonString as Map<String, dynamic>)
      : null;
}
