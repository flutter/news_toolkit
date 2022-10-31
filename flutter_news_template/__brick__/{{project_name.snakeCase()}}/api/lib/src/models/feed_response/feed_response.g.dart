// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, implicit_dynamic_parameter, lines_longer_than_80_chars, prefer_const_constructors, require_trailing_commas

part of 'feed_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeedResponse _$FeedResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'FeedResponse',
      json,
      ($checkedConvert) {
        final val = FeedResponse(
          feed: $checkedConvert(
              'feed', (v) => const NewsBlocksConverter().fromJson(v as List)),
          totalCount: $checkedConvert('total_count', (v) => v as int),
        );
        return val;
      },
      fieldKeyMap: const {'totalCount': 'total_count'},
    );

Map<String, dynamic> _$FeedResponseToJson(FeedResponse instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('feed', const NewsBlocksConverter().toJson(instance.feed));
  val['total_count'] = instance.totalCount;
  return val;
}
