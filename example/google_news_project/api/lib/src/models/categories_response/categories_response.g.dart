// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, implicit_dynamic_parameter, lines_longer_than_80_chars, prefer_const_constructors, require_trailing_commas

part of 'categories_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoriesResponse _$CategoriesResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'CategoriesResponse',
      json,
      ($checkedConvert) {
        final val = CategoriesResponse(
          categories: $checkedConvert(
              'categories',
              (v) => (v as List<dynamic>)
                  .map((e) => $enumDecode(_$CategoryEnumMap, e))
                  .toList()),
        );
        return val;
      },
    );

Map<String, dynamic> _$CategoriesResponseToJson(CategoriesResponse instance) =>
    <String, dynamic>{
      'categories':
          instance.categories.map((e) => _$CategoryEnumMap[e]).toList(),
    };

const _$CategoryEnumMap = {
  Category.business: 'business',
  Category.entertainment: 'entertainment',
  Category.top: 'top',
  Category.health: 'health',
  Category.science: 'science',
  Category.sports: 'sports',
  Category.technology: 'technology',
};
