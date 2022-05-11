import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:news_blocks/news_blocks.dart';

part 'text_caption_block.g.dart';

/// The text weight of [TextCaptionBlock].
enum TextCaptionWeight {
  /// The normal text weight.
  normal,

  /// The light text weight.
  light,
}

/// {@template text_caption_block}
/// A block which represents a text caption.
/// https://www.figma.com/file/RajSN6YbRqTuqvdKYtij3b/Google-News-Template-App-v3?node-id=365%3A35853
/// {@endtemplate}
@JsonSerializable()
class TextCaptionBlock with EquatableMixin implements NewsBlock {
  /// {@macro text_caption_block}
  const TextCaptionBlock({
    required this.text,
    required this.weight,
    this.type = TextCaptionBlock.identifier,
  });

  /// Converts a `Map<String, dynamic>` into a [TextCaptionBlock] instance.
  factory TextCaptionBlock.fromJson(Map<String, dynamic> json) =>
      _$TextCaptionBlockFromJson(json);

  /// The text caption block type identifier.
  static const identifier = '__text_caption__';

  /// The weight of this text caption.
  final TextCaptionWeight weight;

  /// The text of this text caption.
  final String text;

  @override
  final String type;

  @override
  Map<String, dynamic> toJson() => _$TextCaptionBlockToJson(this);

  @override
  List<Object?> get props => [text, weight, type];
}
