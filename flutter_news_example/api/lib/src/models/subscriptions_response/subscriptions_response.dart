import 'package:equatable/equatable.dart';
import 'package:flutter_news_example_api/api.dart';
import 'package:json_annotation/json_annotation.dart';

part 'subscriptions_response.g.dart';

/// {@template subscriptions_response}
/// A subscriptions response object which
/// contains a list of all available subscriptions.
/// {@endtemplate}
@JsonSerializable(explicitToJson: true)
class SubscriptionsResponse extends Equatable {
  /// {@macro subscriptions_response}
  const SubscriptionsResponse({required this.subscriptions});

  /// Converts a `Map<String, dynamic>` into a
  /// [SubscriptionsResponse] instance.
  factory SubscriptionsResponse.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionsResponseFromJson(json);

  /// The list of subscriptions.
  final List<Subscription> subscriptions;

  /// Converts the current instance to a `Map<String, dynamic>`.
  Map<String, dynamic> toJson() => _$SubscriptionsResponseToJson(this);

  @override
  List<Object> get props => [subscriptions];
}
