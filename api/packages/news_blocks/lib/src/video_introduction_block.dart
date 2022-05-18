import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:news_blocks/news_blocks.dart';

part 'video_introduction_block.g.dart';

/// {@template video_introduction_block}
/// A block which represents a video introduction.
/// https://www.figma.com/file/RajSN6YbRqTuqvdKYtij3b/Google-News-Template-App-v3?node-id=391%3A18167
/// {@endtemplate}
@JsonSerializable()
class VideoIntroductionBlock with EquatableMixin implements NewsBlock {
  /// {@macro video_introduction_block}
  const VideoIntroductionBlock({
    required this.category,
    required this.title,
    required this.videoUrl,
    this.type = VideoIntroductionBlock.identifier,
  });

  /// Converts a `Map<String, dynamic>`
  /// into a [VideoIntroductionBlock] instance.
  factory VideoIntroductionBlock.fromJson(Map<String, dynamic> json) =>
      _$VideoIntroductionBlockFromJson(json);

  /// The video introduction block type identifier.
  static const identifier = '__video_introduction__';

  /// The category of the associated article.
  final PostCategory category;

  /// The title of the associated article.
  final String title;

  /// The video url of the associated article.
  final String videoUrl;

  @override
  final String type;

  @override
  Map<String, dynamic> toJson() => _$VideoIntroductionBlockToJson(this);

  @override
  List<Object> get props => [category, title, videoUrl, type];
}
