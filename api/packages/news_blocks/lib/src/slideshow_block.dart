import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:news_blocks/news_blocks.dart';

part 'slideshow_block.g.dart';

/// {@template slideshow_block}
/// A block which represents a slideshow.
/// {@endtemplate}
@JsonSerializable()
class SlideshowBlock with EquatableMixin implements NewsBlock {
  /// {@macro slideshow_block}
  const SlideshowBlock({
    required this.title,
    required this.slides,
    this.type = SlideshowBlock.identifier,
  });

  /// Converts a `Map<String, dynamic>` into a [SlideshowBlock] instance.
  factory SlideshowBlock.fromJson(Map<String, dynamic> json) =>
      _$SlideshowBlockFromJson(json);

  /// The title of this slideshow.
  final String title;

  /// List of slides to be displayed.
  final List<SlideBlock> slides;

  /// The slideshow block type identifier.
  static const identifier = '__slideshow__';

  @override
  Map<String, dynamic> toJson() => _$SlideshowBlockToJson(this);

  @override
  List<Object> get props => [type, title, slides];

  @override
  final String type;
}
