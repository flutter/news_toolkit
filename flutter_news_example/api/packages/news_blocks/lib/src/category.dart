import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'category.g.dart';

/// {@template category}
/// Represents a news category.
/// {@endtemplate}
@JsonSerializable()
class Category extends Equatable {
  /// {@macro category}
  const Category({
    required this.id,
    required this.name,
  });

  /// Converts a `Map<String, dynamic>` into
  /// a [Category] instance.
  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);

  /// Category id.
  final String id;

  /// Category name.
  final String name;

  /// Converts the current instance to a `Map<String, dynamic>`.
  Map<String, dynamic> toJson() => _$CategoryToJson(this);

  @override
  List<Object?> get props => [id, name];
}
