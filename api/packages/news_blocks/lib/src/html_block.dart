import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:news_blocks/news_blocks.dart';

part 'html_block.g.dart';

/// {@template html_block}
/// A block which represents HTML content.
/// {@endtemplate}
@JsonSerializable()
class HtmlBlock with EquatableMixin implements NewsBlock {
  /// {@macro html_block}
  const HtmlBlock({
    required this.content,
    this.type = HtmlBlock.identifier,
  });

  /// Converts a `Map<String, dynamic>` into
  /// an [HtmlBlock] instance.
  factory HtmlBlock.fromJson(Map<String, dynamic> json) =>
      _$HtmlBlockFromJson(json);

  /// The HTML block type identifier.
  static const identifier = '__html__';

  /// The html content.
  final String content;

  @override
  final String type;

  @override
  Map<String, dynamic> toJson() => _$HtmlBlockToJson(this);

  @override
  List<Object> get props => [content, type];
}
