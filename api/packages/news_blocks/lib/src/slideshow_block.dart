import 'package:json_annotation/json_annotation.dart';
import 'package:news_blocks/news_blocks.dart';

part 'slideshow_block.g.dart';

/// {@template slideshow_block}
/// A block which represents a slideshow.
///
/// {@endtemplate}
@JsonSerializable()
class SlideshowBlock implements NewsBlock {
  /// {@macro slideshow_block}
  const SlideshowBlock({
    required this.title,
    required this.slides,
  });

  /// The title of this slideshow.
  final String title;

  /// List of slides to be displayed.
  List<SlideBlock> slides;

  /// Converts a `Map<String, dynamic>` into a [SlideshowBlock] instance.
  factory SlideshowBlock.fromJson(Map<String, dynamic> json) =>
      _$SlideshowBlockFromJson(json);

  /// The slideshow block type identifier.
  static const identifier = '__slideshow_block__';

  @override
  Map<String, dynamic> toJson() => _$SlideshowBlockToJson(this);
}
