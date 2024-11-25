// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'categories_bloc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoriesState _$CategoriesStateFromJson(Map<String, dynamic> json) =>
    CategoriesState(
      status: $enumDecode(_$CategoriesStatusEnumMap, json['status']),
      categories: (json['categories'] as List<dynamic>?)
          ?.map((e) => Category.fromJson(e as Map<String, dynamic>))
          .toList(),
      selectedCategory: json['selectedCategory'] == null
          ? null
          : Category.fromJson(json['selectedCategory'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CategoriesStateToJson(CategoriesState instance) =>
    <String, dynamic>{
      'status': _$CategoriesStatusEnumMap[instance.status]!,
      'categories': instance.categories?.map((e) => e.toJson()).toList(),
      'selectedCategory': instance.selectedCategory?.toJson(),
    };

const _$CategoriesStatusEnumMap = {
  CategoriesStatus.initial: 'initial',
  CategoriesStatus.loading: 'loading',
  CategoriesStatus.populated: 'populated',
  CategoriesStatus.failure: 'failure',
};
