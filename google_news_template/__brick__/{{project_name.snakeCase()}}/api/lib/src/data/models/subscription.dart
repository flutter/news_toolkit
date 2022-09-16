import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'subscription.g.dart';

/// {@template subscription}
/// A news subscription object which contains
/// metadata about a subscription tier.
/// {@endtemplate}
@JsonSerializable()
class Subscription extends Equatable {
  /// {@macro subscription}
  const Subscription({
    required this.id,
    required this.name,
    required this.cost,
    required this.benefits,
  });

  /// Converts a `Map<String, dynamic>` into a [Subscription] instance.
  factory Subscription.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionFromJson(json);

  /// The unique identifier of the subscription which corresponds to the
  /// in-app product id defined in the App Store and Google Play.
  final String id;

  /// The name of the subscription.
  final SubscriptionPlan name;

  /// The cost of the subscription.
  final SubscriptionCost cost;

  /// The included benefits.
  final List<String> benefits;

  /// Converts the current instance to a `Map<String, dynamic>`.
  Map<String, dynamic> toJson() => _$SubscriptionToJson(this);

  @override
  List<Object> get props => [id, name, cost, benefits];
}

/// The available subscription plans.
enum SubscriptionPlan {
  /// No subscription plan.
  none,

  /// The basic subscription plan.
  basic,

  /// The plus subscription plan.
  plus,

  /// The premium subscription plan.
  premium,
}

/// {@template subscription_cost}
/// A news subscription cost object which contains
/// metadata about the cost of a specific subscription.
/// {@endtemplate}
@JsonSerializable()
class SubscriptionCost extends Equatable {
  /// {@macro subscription_cost}
  const SubscriptionCost({required this.monthly, required this.annual});

  /// Converts a `Map<String, dynamic>` into a [SubscriptionCost] instance.
  factory SubscriptionCost.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionCostFromJson(json);

  /// The monthly subscription cost in cents.
  final int monthly;

  /// The annual subscription cost in cents.
  final int annual;

  /// Converts the current instance to a `Map<String, dynamic>`.
  Map<String, dynamic> toJson() => _$SubscriptionCostToJson(this);

  @override
  List<Object> get props => [monthly, annual];
}
