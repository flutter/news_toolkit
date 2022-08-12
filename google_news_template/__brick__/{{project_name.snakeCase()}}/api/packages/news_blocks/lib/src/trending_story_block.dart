import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:news_blocks/news_blocks.dart';

part 'trending_story_block.g.dart';

/// {@template trending_story_block}
/// A block which represents a trending story.
/// https://www.figma.com/file/RajSN6YbRqTuqvdKYtij3b/Google-News-Template-App-v3?node-id=13%3A3140
/// {@endtemplate}
@JsonSerializable()
class TrendingStoryBlock with EquatableMixin implements NewsBlock {
  /// {@macro trending_story_block}
  const TrendingStoryBlock({
    required this.content,
    this.type = TrendingStoryBlock.identifier,
  });

  /// Converts a `Map<String, dynamic>` into a [TrendingStoryBlock] instance.
  factory TrendingStoryBlock.fromJson(Map<String, dynamic> json) =>
      _$TrendingStoryBlockFromJson(json);

  /// The trending story block type identifier.
  static const identifier = '__trending_story__';

  /// The content of the trending story.
  final PostSmallBlock content;

  @override
  final String type;

  @override
  Map<String, dynamic> toJson() => _$TrendingStoryBlockToJson(this);

  @override
  List<Object> get props => [content, type];
}
