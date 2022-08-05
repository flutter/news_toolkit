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
    required this.purchaseStatus,
  });

  SubscriptionsState.initial()
      : this(
          subscriptions: [],
          purchaseStatus: PurchaseStatus.none,
        );

  final List<Subscription> subscriptions;
  final PurchaseStatus purchaseStatus;

  @override
  List<Object> get props => [subscriptions, purchaseStatus];

  SubscriptionsState copyWith({
    List<Subscription>? subscriptions,
    PurchaseStatus? purchaseStatus,
  }) =>
      SubscriptionsState(
        subscriptions: subscriptions ?? this.subscriptions,
        purchaseStatus: purchaseStatus ?? this.purchaseStatus,
      );
}
