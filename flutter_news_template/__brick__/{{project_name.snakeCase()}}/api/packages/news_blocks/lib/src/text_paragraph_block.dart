import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:news_blocks/news_blocks.dart';

part 'text_paragraph_block.g.dart';

/// {@template text_paragraph_block}
/// A block which represents a text paragraph.
/// https://www.figma.com/file/RajSN6YbRqTuqvdKYtij3b/Google-News-Template-App-v3?node-id=35%3A5007
/// {@endtemplate}
@JsonSerializable()
class TextParagraphBlock with EquatableMixin implements NewsBlock {
  /// {@macro text_paragraph_block}
  const TextParagraphBlock({
    required this.text,
    this.type = TextParagraphBlock.identifier,
  });

  /// Converts a `Map<String, dynamic>` into a [TextParagraphBlock] instance.
  factory TextParagraphBlock.fromJson(Map<String, dynamic> json) =>
      _$TextParagraphBlockFromJson(json);

  /// The text paragraph block type identifier.
  static const identifier = '__text_paragraph__';

  /// The text of the text paragraph.
  final String text;

  @override
  final String type;

  @override
  Map<String, dynamic> toJson() => _$TextParagraphBlockToJson(this);

  @override
  List<Object?> get props => [text, type];
}
