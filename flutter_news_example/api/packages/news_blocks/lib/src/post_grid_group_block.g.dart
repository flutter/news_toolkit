// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, implicit_dynamic_parameter, lines_longer_than_80_chars, prefer_const_constructors, require_trailing_commas

part of 'post_grid_group_block.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostGridGroupBlock _$PostGridGroupBlockFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'PostGridGroupBlock',
      json,
      ($checkedConvert) {
        final val = PostGridGroupBlock(
          categoryId: $checkedConvert('category_id', (v) => v as String),
          tiles: $checkedConvert(
              'tiles',
              (v) => (v as List<dynamic>)
                  .map((e) =>
                      PostGridTileBlock.fromJson(e as Map<String, dynamic>))
                  .toList()),
          type: $checkedConvert(
              'type', (v) => v as String? ?? PostGridGroupBlock.identifier),
        );
        return val;
      },
      fieldKeyMap: const {'categoryId': 'category_id'},
    );

Map<String, dynamic> _$PostGridGroupBlockToJson(PostGridGroupBlock instance) =>
    <String, dynamic>{
      'category_id': instance.categoryId,
      'tiles': instance.tiles.map((e) => e.toJson()).toList(),
      'type': instance.type,
    };
