import 'package:equatable/equatable.dart';
import 'package:flutter_news_example_api/client.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

/// {@template user}
/// A user object which contains user metadata.
/// {@endtemplate}
@JsonSerializable(explicitToJson: true)
class User extends Equatable {
  /// {@macro user}
  const User({required this.id, required this.subscription});

  /// Converts a `Map<String, dynamic>` into a [User] instance.
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  /// The associated user identifier.
  final String id;

  /// The associated subscription plan.
  final SubscriptionPlan subscription;

  /// Converts the current instance to a `Map<String, dynamic>`.
  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  List<Object> get props => [id, subscription];
}
