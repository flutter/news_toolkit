// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, implicit_dynamic_parameter, lines_longer_than_80_chars, prefer_const_constructors, require_trailing_commas

part of 'block_action.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlockAction _$BlockActionFromJson(Map<String, dynamic> json) => $checkedCreate(
      'BlockAction',
      json,
      ($checkedConvert) {
        final val = BlockAction(
          type: $checkedConvert(
              'type', (v) => $enumDecode(_$BlockActionTypeEnumMap, v)),
          uri: $checkedConvert(
              'uri', (v) => v == null ? null : Uri.parse(v as String)),
        );
        return val;
      },
    );

Map<String, dynamic> _$BlockActionToJson(BlockAction instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('uri', instance.uri?.toString());
  val['type'] = _$BlockActionTypeEnumMap[instance.type];
  return val;
}

const _$BlockActionTypeEnumMap = {
  BlockActionType.navigation: 'navigation',
};
