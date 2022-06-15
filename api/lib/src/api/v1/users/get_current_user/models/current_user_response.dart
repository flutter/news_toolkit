import 'package:equatable/equatable.dart';
import 'package:google_news_template_api/api.dart';
import 'package:json_annotation/json_annotation.dart';

part 'current_user_response.g.dart';

/// {@template current_user_response}
/// A  response object which contains the current user.
/// {@endtemplate}
@JsonSerializable()
class CurrentUserResponse extends Equatable {
  /// {@macro current_user_response}
  const CurrentUserResponse({required this.user});

  /// Converts a `Map<String, dynamic>` into a
  /// [CurrentUserResponse] instance.
  factory CurrentUserResponse.fromJson(Map<String, dynamic> json) =>
      _$CurrentUserResponseFromJson(json);

  /// The article content blocks.
  final User user;

  /// Converts the current instance to a `Map<String, dynamic>`.
  Map<String, dynamic> toJson() => _$CurrentUserResponseToJson(this);

  @override
  List<Object> get props => [user];
}
