import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:news_blocks/news_blocks.dart';

part 'text_lead_paragraph_block.g.dart';

/// {@template text_lead_paragraph_block}
/// A block which represents a text lead paragraph.
/// https://www.figma.com/file/RajSN6YbRqTuqvdKYtij3b/Google-News-Template-App-v3?node-id=35%3A5002
/// {@endtemplate}
@JsonSerializable()
class TextLeadParagraphBlock with EquatableMixin implements NewsBlock {
  /// {@macro text_lead_paragraph_block}
  const TextLeadParagraphBlock({
    required this.text,
    this.type = TextLeadParagraphBlock.identifier,
  });

  /// Converts a `Map<String, dynamic>`
  /// into a [TextLeadParagraphBlock] instance.
  factory TextLeadParagraphBlock.fromJson(Map<String, dynamic> json) =>
      _$TextLeadParagraphBlockFromJson(json);

  /// The text lead paragraph block type identifier.
  static const identifier = '__text_lead_paragraph__';

  /// The text of the text lead paragraph.
  final String text;

  @override
  final String type;

  @override
  Map<String, dynamic> toJson() => _$TextLeadParagraphBlockToJson(this);

  @override
  List<Object?> get props => [type, text];
}
