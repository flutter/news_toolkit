part of 'subscriptions_bloc.dart';

abstract class SubscriptionsEvent extends Equatable {}

class SubscriptionsRequested extends SubscriptionsEvent {
  SubscriptionsRequested();

  @override
  List<Object> get props => [];
}

class SubscriptionPurchaseRequested extends SubscriptionsEvent {
  SubscriptionPurchaseRequested({required this.subscription});

  final Subscription subscription;

  @override
  List<Object> get props => [subscription];
}

class SubscriptionPurchaseCompleted extends SubscriptionsEvent {
  SubscriptionPurchaseCompleted({required this.subscription});

  final Subscription subscription;

  @override
  List<Object> get props => [subscription];
}

class SubscriptionPurchaseUpdated extends SubscriptionsEvent {
  SubscriptionPurchaseUpdated({required this.purchase});

  final PurchaseUpdate purchase;

  @override
  List<Object> get props => [purchase];
}
