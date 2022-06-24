part of 'subscriptions_bloc.dart';

abstract class SubscriptionsEvent extends Equatable {}

class SubscriptionsRequested extends SubscriptionsEvent {
  SubscriptionsRequested();

  @override
  List<Object> get props => [];
}

class CurrentSubscriptionChanged extends SubscriptionsEvent {
  CurrentSubscriptionChanged({required this.subscription});

  final SubscriptionPlan subscription;
  @override
  List<Object> get props => [subscription];
}

class SubscriptionPurchaseRequested extends SubscriptionsEvent {
  SubscriptionPurchaseRequested({required this.subscription});

  final Subscription subscription;

  @override
  List<Object?> get props => [subscription];
}

class SubscriptionPurchaseCompleted extends SubscriptionsEvent {
  SubscriptionPurchaseCompleted({required this.subscription});

  final Subscription subscription;

  @override
  List<Object?> get props => [subscription];
}

class InAppPurchaseUpdated extends SubscriptionsEvent {
  InAppPurchaseUpdated({required this.purchase});

  final PurchaseUpdate purchase;

  @override
  List<Object?> get props => [purchase];
}
