// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, implicit_dynamic_parameter, lines_longer_than_80_chars, prefer_const_constructors, require_trailing_commas

part of 'banner_ad_block.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BannerAdBlock _$BannerAdBlockFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'BannerAdBlock',
      json,
      ($checkedConvert) {
        final val = BannerAdBlock(
          size: $checkedConvert(
              'size', (v) => $enumDecode(_$BannerAdSizeEnumMap, v)),
          type: $checkedConvert(
              'type', (v) => v as String? ?? BannerAdBlock.identifier),
        );
        return val;
      },
    );

Map<String, dynamic> _$BannerAdBlockToJson(BannerAdBlock instance) =>
    <String, dynamic>{
      'size': _$BannerAdSizeEnumMap[instance.size]!,
      'type': instance.type,
    };

const _$BannerAdSizeEnumMap = {
  BannerAdSize.normal: 'normal',
  BannerAdSize.large: 'large',
  BannerAdSize.extraLarge: 'extraLarge',
  BannerAdSize.anchoredAdaptive: 'anchoredAdaptive',
};
