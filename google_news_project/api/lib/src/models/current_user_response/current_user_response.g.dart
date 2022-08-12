// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, implicit_dynamic_parameter, lines_longer_than_80_chars, prefer_const_constructors, require_trailing_commas

part of 'current_user_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurrentUserResponse _$CurrentUserResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'CurrentUserResponse',
      json,
      ($checkedConvert) {
        final val = CurrentUserResponse(
          user: $checkedConvert(
              'user', (v) => User.fromJson(v as Map<String, dynamic>)),
        );
        return val;
      },
    );

Map<String, dynamic> _$CurrentUserResponseToJson(
        CurrentUserResponse instance) =>
    <String, dynamic>{
      'user': instance.user.toJson(),
    };
