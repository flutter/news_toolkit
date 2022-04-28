// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, implicit_dynamic_parameter, lines_longer_than_80_chars, prefer_const_constructors, require_trailing_commas

part of 'unknown_block.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UnknownBlock _$UnknownBlockFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'UnknownBlock',
      json,
      ($checkedConvert) {
        final val = UnknownBlock(
          type: $checkedConvert(
              'type', (v) => v as String? ?? UnknownBlock.identifier),
        );
        return val;
      },
    );

Map<String, dynamic> _$UnknownBlockToJson(UnknownBlock instance) =>
    <String, dynamic>{
      'type': instance.type,
    };
