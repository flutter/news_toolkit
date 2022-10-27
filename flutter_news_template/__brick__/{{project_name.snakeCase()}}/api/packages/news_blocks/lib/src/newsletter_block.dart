import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:news_blocks/news_blocks.dart';

part 'newsletter_block.g.dart';

/// {@template newsletter_block}
/// A block which represents a newsletter.
/// https://www.figma.com/file/RajSN6YbRqTuqvdKYtij3b/Google-News-Template-App-v3?node-id=1701%3A24352
/// {@endtemplate}
@JsonSerializable()
class NewsletterBlock with EquatableMixin implements NewsBlock {
  /// {@macro newsletter_block}
  const NewsletterBlock({
    this.type = NewsletterBlock.identifier,
  });

  /// Converts a `Map<String, dynamic>` into
  /// a [NewsletterBlock] instance.
  factory NewsletterBlock.fromJson(Map<String, dynamic> json) =>
      _$NewsletterBlockFromJson(json);

  /// The newsletter block type identifier.
  static const identifier = '__newsletter__';

  @override
  final String type;

  @override
  Map<String, dynamic> toJson() => _$NewsletterBlockToJson(this);

  @override
  List<Object?> get props => [type];
}
