import 'package:json_annotation/json_annotation.dart';
import 'package:news_blocks/news_blocks.dart';

part 'unknown_block.g.dart';

/// The unknown block type identifier.
const unknownBlockType = '__unknown__';

/// {@template unknown_block}
/// A block which represents an unknown type.
/// {@endtemplate}
@JsonSerializable()
class UnknownBlock implements NewsBlock {
  /// {@macro unknown_block}
  const UnknownBlock({this.type = unknownBlockType});

  /// Converts a `Map<String, dynamic>` into a [BlockAction] instance.
  factory UnknownBlock.fromJson(Map<String, dynamic> json) =>
      _$UnknownBlockFromJson(json);

  @override
  final String type;

  @override
  Map<String, dynamic> toJson() => _$UnknownBlockToJson(this);
}
