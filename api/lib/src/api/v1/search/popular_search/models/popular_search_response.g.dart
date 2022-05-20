// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, implicit_dynamic_parameter, lines_longer_than_80_chars, prefer_const_constructors, require_trailing_commas

part of 'popular_search_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PopularSearchResponse _$PopularSearchResponseFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'PopularSearchResponse',
      json,
      ($checkedConvert) {
        final val = PopularSearchResponse(
          articles: $checkedConvert('articles',
              (v) => const NewsBlocksConverter().fromJson(v as List)),
          topics: $checkedConvert('topics',
              (v) => (v as List<dynamic>).map((e) => e as String).toList()),
        );
        return val;
      },
    );

Map<String, dynamic> _$PopularSearchResponseToJson(
    PopularSearchResponse instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(
      'articles', const NewsBlocksConverter().toJson(instance.articles));
  val['topics'] = instance.topics;
  return val;
}
