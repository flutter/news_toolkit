import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:news_blocks/news_blocks.dart';

part 'video_intro_block.g.dart';

/// {@template video_intro_block}
/// A block which represents a video intro.
/// https://www.figma.com/file/RajSN6YbRqTuqvdKYtij3b/Google-News-Template-App-v3?node-id=391%3A18167
/// {@endtemplate}
@JsonSerializable()
class VideoIntroBlock with EquatableMixin implements NewsBlock {
  /// {@macro video_intro_block}
  const VideoIntroBlock({
    required this.category,
    required this.title,
    required this.videoUrl,
    this.type = VideoIntroBlock.identifier,
  });

  /// Converts a `Map<String, dynamic>` into a [VideoIntroBlock] instance.
  factory VideoIntroBlock.fromJson(Map<String, dynamic> json) =>
      _$VideoIntroBlockFromJson(json);

  /// The video block type identifier.
  static const identifier = '__video_intro__';

  /// The category of this post.
  final PostCategory category;

  /// The title of this post.
  final String title;

  /// The url of this video.
  final String videoUrl;

  @override
  final String type;

  @override
  Map<String, dynamic> toJson() => _$VideoIntroBlockToJson(this);

  @override
  List<Object> get props => [category, title, videoUrl, type];
}
