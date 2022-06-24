import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:news_blocks/news_blocks.dart';

part 'slideshow_introduction_block.g.dart';

/// {@template slideshow_introduction_block}
/// A block which represents a slideshow introduction.
///
/// {@endtemplate}
@JsonSerializable()
class SlideshowIntroductionBlock with EquatableMixin implements NewsBlock {
  /// {@macro slideshow_introduction_block}
  const SlideshowIntroductionBlock({
    required this.title,
    this.coverImageUrl,
    this.type = SlideshowIntroductionBlock.identifier,
  });

  /// The title of this slideshow.
  final String title;

  /// The slideshow cover image URL.
  final String? coverImageUrl;

  /// Converts a `Map<String, dynamic>` into a [SlideshowBlock] instance.
  factory SlideshowIntroductionBlock.fromJson(Map<String, dynamic> json) =>
      _$SlideshowIntroductionBlockFromJson(json);

  /// The slideshow introduction block type identifier.
  static const identifier = '__slideshow_introducion_block__';

  @override
  Map<String, dynamic> toJson() => _$SlideshowIntroductionBlockToJson(this);

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();

  @override
  final String type;
}
