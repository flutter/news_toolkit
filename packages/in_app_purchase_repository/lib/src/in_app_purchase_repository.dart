import 'package:equatable/equatable.dart';
import 'package:google_news_template_api/client.dart';
import 'package:rxdart/rxdart.dart';

/// {@template subscriptions_failure}
/// A base failure for the subscriptions repository failures.
/// {@endtemplate}
abstract class SubscriptionsFailure with EquatableMixin implements Exception {
  /// {@macro subscriptions_failure}
  const SubscriptionsFailure(this.error);

  /// The error which was caught.
  final Object error;

  @override
  List<Object> get props => [error];
}

/// {@template request_subscription_failure}
/// Thrown when requesting a subscription fails.
/// {@endtemplate}
class RequestSubscriptionFailure extends SubscriptionsFailure {
  /// {@macro request_subscription_failure}
  const RequestSubscriptionFailure(super.error);
}

/// {@template in_app_purchase_repository}
/// A repository that manages user subscriptions.
/// {@endtemplate}
class InAppPurchaseRepository {
  /// {@macro in_app_purchase_repository}
  InAppPurchaseRepository({
    required GoogleNewsTemplateApiClient apiClient,
  })  : _apiClient = apiClient,
        _currentSubscriptionPlanSubject =
            BehaviorSubject.seeded(SubscriptionPlan.none);

  final GoogleNewsTemplateApiClient _apiClient;

  final BehaviorSubject<SubscriptionPlan> _currentSubscriptionPlanSubject;

  /// A stream of the current subscription plan of a user.
  Stream<SubscriptionPlan> get currentSubscriptionPlan =>
      _currentSubscriptionPlanSubject;

  /// Requests to set the current subscription to the subscription
  /// with the associated [subscriptionId].
  Future<void> requestSubscription(String subscriptionId) async {
    try {
      await _apiClient.createSubscription(subscriptionId: subscriptionId);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        RequestSubscriptionFailure(error),
        stackTrace,
      );
    }
  }
}
