import 'package:authentication_client/authentication_client.dart';
import 'package:flutter_news_template_api/client.dart';

/// {@template user}
/// User model represents the current user with subscription plan.
/// {@endtemplate}
class User extends AuthenticationUser {
  /// {@macro user}
  const User({
    required this.subscriptionPlan,
    required super.id,
    super.email,
    super.name,
    super.photo,
    super.isNewUser,
  });

  /// Converts [AuthenticationUser] to [User] with [SubscriptionPlan].
  factory User.fromAuthenticationUser({
    required AuthenticationUser authenticationUser,
    required SubscriptionPlan subscriptionPlan,
  }) =>
      User(
        email: authenticationUser.email,
        id: authenticationUser.id,
        name: authenticationUser.name,
        photo: authenticationUser.photo,
        isNewUser: authenticationUser.isNewUser,
        subscriptionPlan: subscriptionPlan,
      );

  /// Whether the current user is anonymous.
  @override
  bool get isAnonymous => this == anonymous;

  /// Anonymous user which represents an unauthenticated user.
  static const User anonymous = User(
    id: '',
    subscriptionPlan: SubscriptionPlan.none,
  );

  /// The current user's subscription plan.
  final SubscriptionPlan subscriptionPlan;
}
