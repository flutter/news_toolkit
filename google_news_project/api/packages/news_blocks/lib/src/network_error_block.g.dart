// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, implicit_dynamic_parameter, lines_longer_than_80_chars, prefer_const_constructors, require_trailing_commas

part of 'network_error_block.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NetworkErrorBlock _$NetworkErrorBlockFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'NetworkErrorBlock',
      json,
      ($checkedConvert) {
        final val = NetworkErrorBlock(
          type: $checkedConvert(
              'type', (v) => v as String? ?? NetworkErrorBlock.identifier),
        );
        return val;
      },
    );

Map<String, dynamic> _$NetworkErrorBlockToJson(NetworkErrorBlock instance) =>
    <String, dynamic>{
      'type': instance.type,
    };
