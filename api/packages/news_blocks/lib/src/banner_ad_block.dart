import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:news_blocks/news_blocks.dart';

part 'banner_ad_block.g.dart';

/// The size of a [BannerAdBlock].
enum BannerAdSize {
  /// The normal size of a banner ad.
  normal,

  /// The large size of a banner ad.
  large,

  /// The extra large size of a banner ad.
  extraLarge,

  /// The anchored adaptive size of a banner ad.
  anchoredAdaptive
}

/// {@template banner_ad_block}
/// A block which represents a banner ad.
/// https://www.figma.com/file/RajSN6YbRqTuqvdKYtij3b/Google-News-Template-App-v3?node-id=35%3A5151
/// {@endtemplate}
@JsonSerializable()
class BannerAdBlock with EquatableMixin implements NewsBlock {
  /// {@macro banner_ad_block}
  const BannerAdBlock({
    required this.size,
    this.type = BannerAdBlock.identifier,
  });

  /// Converts a `Map<String, dynamic>` into a [BannerAdBlock] instance.
  factory BannerAdBlock.fromJson(Map<String, dynamic> json) =>
      _$BannerAdBlockFromJson(json);

  /// The banner ad block type identifier.
  static const identifier = '__banner_ad__';

  /// The size of this banner ad.
  final BannerAdSize size;

  @override
  final String type;

  @override
  Map<String, dynamic> toJson() => _$BannerAdBlockToJson(this);

  @override
  List<Object> get props => [size, type];
}
