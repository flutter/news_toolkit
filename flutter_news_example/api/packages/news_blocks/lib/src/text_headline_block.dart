import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:news_blocks/news_blocks.dart';

part 'text_headline_block.g.dart';

/// {@template text_headline_block}
/// A block which represents a text headline.
/// https://www.figma.com/file/RajSN6YbRqTuqvdKYtij3b/Google-News-Template-App-v3?node-id=35%3A5014
/// {@endtemplate}
@JsonSerializable()
class TextHeadlineBlock with EquatableMixin implements NewsBlock {
  /// {@macro text_headline_block}
  const TextHeadlineBlock({
    required this.text,
    this.type = TextHeadlineBlock.identifier,
  });

  /// Converts a `Map<String, dynamic>` into a [TextHeadlineBlock] instance.
  factory TextHeadlineBlock.fromJson(Map<String, dynamic> json) =>
      _$TextHeadlineBlockFromJson(json);

  /// The text headline block type identifier.
  static const identifier = '__text_headline__';

  /// The text of the text headline.
  final String text;

  @override
  final String type;

  @override
  Map<String, dynamic> toJson() => _$TextHeadlineBlockToJson(this);

  @override
  List<Object?> get props => [type, text];
}
