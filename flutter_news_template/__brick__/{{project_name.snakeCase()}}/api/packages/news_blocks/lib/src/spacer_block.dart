import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:news_blocks/news_blocks.dart';

part 'spacer_block.g.dart';

/// The spacing of [SpacerBlock].
enum Spacing {
  /// The extra small spacing.
  extraSmall,

  /// The small spacing.
  small,

  /// The medium spacing.
  medium,

  /// The large spacing.
  large,

  /// The very large spacing.
  veryLarge,

  /// The extra large spacing.
  extraLarge,
}

/// {@template spacer_block}
/// A block which represents a spacer.
/// https://www.figma.com/file/RajSN6YbRqTuqvdKYtij3b/Google-News-Template-App-v3?node-id=358%3A18765
/// {@endtemplate}
@JsonSerializable()
class SpacerBlock with EquatableMixin implements NewsBlock {
  /// {@macro spacer_block}
  const SpacerBlock({
    required this.spacing,
    this.type = SpacerBlock.identifier,
  });

  /// Converts a `Map<String, dynamic>` into a [SpacerBlock] instance.
  factory SpacerBlock.fromJson(Map<String, dynamic> json) =>
      _$SpacerBlockFromJson(json);

  /// The spacer block type identifier.
  static const identifier = '__spacer__';

  /// The spacing of this spacer.
  final Spacing spacing;

  @override
  final String type;

  @override
  Map<String, dynamic> toJson() => _$SpacerBlockToJson(this);

  @override
  List<Object?> get props => [spacing, type];
}
