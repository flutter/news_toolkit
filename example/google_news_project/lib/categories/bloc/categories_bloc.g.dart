// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'categories_bloc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoriesState _$CategoriesStateFromJson(Map<String, dynamic> json) =>
    CategoriesState(
      status: $enumDecode(_$CategoriesStatusEnumMap, json['status']),
      categories: (json['categories'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$CategoryEnumMap, e))
          .toList(),
      selectedCategory:
          $enumDecodeNullable(_$CategoryEnumMap, json['selectedCategory']),
    );

Map<String, dynamic> _$CategoriesStateToJson(CategoriesState instance) =>
    <String, dynamic>{
      'status': _$CategoriesStatusEnumMap[instance.status]!,
      'categories':
          instance.categories?.map((e) => _$CategoryEnumMap[e]!).toList(),
      'selectedCategory': _$CategoryEnumMap[instance.selectedCategory],
    };

const _$CategoriesStatusEnumMap = {
  CategoriesStatus.initial: 'initial',
  CategoriesStatus.loading: 'loading',
  CategoriesStatus.populated: 'populated',
  CategoriesStatus.failure: 'failure',
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
