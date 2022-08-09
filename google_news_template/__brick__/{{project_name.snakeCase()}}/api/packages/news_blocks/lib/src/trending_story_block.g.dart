// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, implicit_dynamic_parameter, lines_longer_than_80_chars, prefer_const_constructors, require_trailing_commas

part of 'trending_story_block.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrendingStoryBlock _$TrendingStoryBlockFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'TrendingStoryBlock',
      json,
      ($checkedConvert) {
        final val = TrendingStoryBlock(
          content: $checkedConvert('content',
              (v) => PostSmallBlock.fromJson(v as Map<String, dynamic>)),
          type: $checkedConvert(
              'type', (v) => v as String? ?? TrendingStoryBlock.identifier),
        );
        return val;
      },
    );

Map<String, dynamic> _$TrendingStoryBlockToJson(TrendingStoryBlock instance) =>
    <String, dynamic>{
      'content': instance.content.toJson(),
      'type': instance.type,
    };
