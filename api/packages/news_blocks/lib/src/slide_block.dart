import 'package:json_annotation/json_annotation.dart';
import 'package:news_blocks/news_blocks.dart';

part 'slide_block.g.dart';

/// {@template slide_block}
/// A block which represents a slide in a slideshow.
/// 
/// {@endtemplate}
@JsonSerializable()
class SlideBlock implements NewsBlock {
  /// {@macro slide_block}
  const SlideBlock({
  });

  final String? caption;
  
  final String? description;

  final String? photoCredit;

  /// Converts a `Map<String, dynamic>` into a [SlideBlock] instance.
  factory SlideBlock.fromJson(Map<String, dynamic> json) =>
      _$SlideBlockFromJson(json);

  /// The slide block type identifier.
  static const identifier = '__slide_block__';

  @override
  Map<String, dynamic> toJson() => _$SlideBlockToJson(this);
}
