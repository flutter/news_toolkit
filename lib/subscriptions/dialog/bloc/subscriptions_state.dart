part of 'subscriptions_bloc.dart';

enum PurchaseStatus {
  none,
  pending,
  completed,
  failed,
}

class SubscriptionsState extends Equatable {
  const SubscriptionsState({
    required this.subscriptions,
    required this.currentSubscription,
    required this.purchaseStatus,
  });

  SubscriptionsState.initial()
      : this(
          subscriptions: [],
          currentSubscription: SubscriptionPlan.none,
          purchaseStatus: PurchaseStatus.none,
        );

  final List<Subscription> subscriptions;
  final SubscriptionPlan currentSubscription;
  final PurchaseStatus purchaseStatus;

  @override
  List<Object> get props =>
      [subscriptions, currentSubscription, purchaseStatus];

  SubscriptionsState copyWith({
    List<Subscription>? subscriptions,
    SubscriptionPlan? currentSubscription,
    PurchaseStatus? purchaseStatus,
  }) =>
      SubscriptionsState(
        subscriptions: subscriptions ?? this.subscriptions,
        currentSubscription: currentSubscription ?? this.currentSubscription,
        purchaseStatus: purchaseStatus ?? this.purchaseStatus,
      );
}
