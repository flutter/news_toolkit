// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, implicit_dynamic_parameter, lines_longer_than_80_chars, prefer_const_constructors, require_trailing_commas

part of 'slideshow_introduction_block.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SlideshowIntroductionBlock _$SlideshowIntroductionBlockFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'SlideshowIntroductionBlock',
      json,
      ($checkedConvert) {
        final val = SlideshowIntroductionBlock(
          title: $checkedConvert('title', (v) => v as String),
          coverImageUrl: $checkedConvert('cover_image_url', (v) => v as String),
          type: $checkedConvert('type',
              (v) => v as String? ?? SlideshowIntroductionBlock.identifier),
          action: $checkedConvert(
              'action',
              (v) => const BlockActionConverter()
                  .fromJson(v as Map<String, dynamic>?)),
        );
        return val;
      },
      fieldKeyMap: const {'coverImageUrl': 'cover_image_url'},
    );

Map<String, dynamic> _$SlideshowIntroductionBlockToJson(
    SlideshowIntroductionBlock instance) {
  final val = <String, dynamic>{
    'title': instance.title,
    'cover_image_url': instance.coverImageUrl,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('action', const BlockActionConverter().toJson(instance.action));
  val['type'] = instance.type;
  return val;
}
