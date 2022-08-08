import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:news_blocks/news_blocks.dart';

part 'image_block.g.dart';

/// {@template image_block}
/// A block which represents an image.
/// https://www.figma.com/file/RajSN6YbRqTuqvdKYtij3b/Google-News-Template-App-v3?node-id=35%3A4874
/// {@endtemplate}
@JsonSerializable()
class ImageBlock with EquatableMixin implements NewsBlock {
  /// {@macro image_block}
  const ImageBlock({
    required this.imageUrl,
    this.type = ImageBlock.identifier,
  });

  /// Converts a `Map<String, dynamic>` into a [ImageBlock] instance.
  factory ImageBlock.fromJson(Map<String, dynamic> json) =>
      _$ImageBlockFromJson(json);

  /// The image block type identifier.
  static const identifier = '__image__';

  /// The url of this image.
  final String imageUrl;

  @override
  final String type;

  @override
  Map<String, dynamic> toJson() => _$ImageBlockToJson(this);

  @override
  List<Object> get props => [imageUrl, type];
}
