import 'package:equatable/equatable.dart';
import 'package:flutter_news_template_api/api.dart';
import 'package:json_annotation/json_annotation.dart';

part 'categories_response.g.dart';

/// {@template categories_response}
/// A news categories response object which contains available news categories.
/// {@endtemplate}
@JsonSerializable()
class CategoriesResponse extends Equatable {
  /// {@macro categories_response}
  const CategoriesResponse({required this.categories});

  /// Converts a `Map<String, dynamic>` into a [CategoriesResponse] instance.
  factory CategoriesResponse.fromJson(Map<String, dynamic> json) =>
      _$CategoriesResponseFromJson(json);

  /// The available categories.
  final List<Category> categories;

  /// Converts the current instance to a `Map<String, dynamic>`.
  Map<String, dynamic> toJson() => _$CategoriesResponseToJson(this);

  @override
  List<Object> get props => [categories];
}
