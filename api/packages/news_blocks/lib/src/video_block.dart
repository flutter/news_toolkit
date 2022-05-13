import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:news_blocks/news_blocks.dart';

part 'video_block.g.dart';

/// {@template video_block}
/// A block which represents a video.
/// https://www.figma.com/file/RajSN6YbRqTuqvdKYtij3b/Google-News-Template-App-v3?node-id=812%3A31908
/// {@endtemplate}
@JsonSerializable()
class VideoBlock with EquatableMixin implements NewsBlock {
  /// {@macro video_block}
  const VideoBlock({
    required this.videoUrl,
    this.type = VideoBlock.identifier,
  });

  /// Converts a `Map<String, dynamic>` into a [VideoBlock] instance.
  factory VideoBlock.fromJson(Map<String, dynamic> json) =>
      _$VideoBlockFromJson(json);

  /// The video block type identifier.
  static const identifier = '__video__';

  /// The url of this video.
  final String videoUrl;

  @override
  final String type;

  @override
  Map<String, dynamic> toJson() => _$VideoBlockToJson(this);

  @override
  List<Object> get props => [videoUrl, type];
}
