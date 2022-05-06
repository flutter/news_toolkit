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
          category: $checkedConvert(
              'category', (v) => $enumDecode(_$PostCategoryEnumMap, v)),
          tiles: $checkedConvert('tiles',
              (v) => const PostGridTileBlocksConverter().fromJson(v as List)),
          type: $checkedConvert(
              'type', (v) => v as String? ?? PostGridGroupBlock.identifier),
        );
        return val;
      },
    );

Map<String, dynamic> _$PostGridGroupBlockToJson(PostGridGroupBlock instance) {
  final val = <String, dynamic>{
    'category': _$PostCategoryEnumMap[instance.category],
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(
      'tiles', const PostGridTileBlocksConverter().toJson(instance.tiles));
  val['type'] = instance.type;
  return val;
}

const _$PostCategoryEnumMap = {
  PostCategory.business: 'business',
  PostCategory.entertainment: 'entertainment',
  PostCategory.health: 'health',
  PostCategory.science: 'science',
  PostCategory.sports: 'sports',
  PostCategory.technology: 'technology',
};
