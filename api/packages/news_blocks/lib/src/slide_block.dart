import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:news_blocks/news_blocks.dart';

part 'slide_block.g.dart';

/// {@template slide_block}
/// A block which represents a slide in a slideshow.
/// {@endtemplate}
@JsonSerializable()
class SlideBlock with EquatableMixin implements NewsBlock {
  /// {@macro slide_block}
  const SlideBlock({
    required this.caption,
    required this.description,
    required this.photoCredit,
    required this.imageUrl,
    this.type = SlideBlock.identifier,
  });

  /// Converts a `Map<String, dynamic>` into a [SlideBlock] instance.
  factory SlideBlock.fromJson(Map<String, dynamic> json) =>
      _$SlideBlockFromJson(json);

  /// The caption of the slide image.
  final String caption;

  /// The description of the slide.
  final String description;

  /// The photo credit for the slide image.
  final String photoCredit;

  /// The URL of the slide image.
  final String imageUrl;

  /// The slide block type identifier.
  static const identifier = '__slide_block__';

  @override
  Map<String, dynamic> toJson() => _$SlideBlockToJson(this);

  @override
  final String type;

  @override
  List<Object> get props => [
        type,
        caption,
        description,
        photoCredit,
        imageUrl,
      ];
}
