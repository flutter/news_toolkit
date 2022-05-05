import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:news_blocks/news_blocks.dart';

part 'unknown_block.g.dart';

/// {@template unknown_block}
/// A block which represents an unknown type.
/// {@endtemplate}
@JsonSerializable()
class UnknownBlock with EquatableMixin implements NewsBlock {
  /// {@macro unknown_block}
  const UnknownBlock({this.type = UnknownBlock.identifier});

  /// Converts a `Map<String, dynamic>` into a [UnknownBlock] instance.
  factory UnknownBlock.fromJson(Map<String, dynamic> json) =>
      _$UnknownBlockFromJson(json);

  /// The unknown block type identifier.
  static const identifier = '__unknown__';

  @override
  final String type;

  @override
  Map<String, dynamic> toJson() => _$UnknownBlockToJson(this);

  @override
  List<Object> get props => [type];
}
