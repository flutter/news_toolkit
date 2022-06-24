import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:in_app_purchase_repository/in_app_purchase_repository.dart';

part 'subscriptions_event.dart';
part 'subscriptions_state.dart';

class SubscriptionsBloc extends Bloc<SubscriptionsEvent, SubscriptionsState> {
  SubscriptionsBloc({
    required InAppPurchaseRepository inAppPurchaseRepository,
  })  : _inAppPurchaseRepository = inAppPurchaseRepository,
        super(
          SubscriptionsState.initial(),
        ) {
    on<SubscriptionsRequested>(_onSubscriptionsRequested);
    on<CurrentSubscriptionChanged>(_onCurrentSubscriptionChanged);
    on<SubscriptionPurchaseRequested>(_onSubscriptionPurchaseRequested);
    on<InAppPurchaseUpdated>(_onInAppPurchaseUpdated);

    _currentSubscriptionPlanSubscription =
        _inAppPurchaseRepository.currentSubscriptionPlan.listen(
      (subscription) => add(
        CurrentSubscriptionChanged(
          subscription: subscription,
        ),
      ),
    );

    _inAppPurchaseUpdateSubscription = _inAppPurchaseRepository
        .purchaseUpdateStream
        .listen((purchase) => add(InAppPurchaseUpdated(purchase: purchase)));
  }

  final InAppPurchaseRepository _inAppPurchaseRepository;

  late StreamSubscription<SubscriptionPlan>
      _currentSubscriptionPlanSubscription;

  late StreamSubscription<PurchaseUpdate> _inAppPurchaseUpdateSubscription;

  FutureOr<void> _onSubscriptionsRequested(
    SubscriptionsRequested event,
    Emitter<SubscriptionsState> emit,
  ) async {
    final subscriptions = await _inAppPurchaseRepository.fetchSubscriptions();
    emit(state.copyWith(subscriptions: subscriptions));
  }

  FutureOr<void> _onCurrentSubscriptionChanged(
    CurrentSubscriptionChanged event,
    Emitter<SubscriptionsState> emit,
  ) {
    emit(state.copyWith(currentSubscription: event.subscription));
  }

  FutureOr<void> _onSubscriptionPurchaseRequested(
    SubscriptionPurchaseRequested event,
    Emitter<SubscriptionsState> emit,
  ) async {
    emit(state.copyWith(purchaseStatus: PurchaseStatus.pending));
    await _inAppPurchaseRepository.purchase(subscription: event.subscription);
  }

  FutureOr<void> _onInAppPurchaseUpdated(
    InAppPurchaseUpdated event,
    Emitter<SubscriptionsState> emit,
  ) {
    final purchase = event.purchase;

    if (purchase is PurchasePurchased) {
      emit(
        state.copyWith(
          purchaseStatus: PurchaseStatus.pending,
        ),
      );
    } else if (purchase is PurchaseDelivered) {
      emit(
        state.copyWith(
          purchaseStatus: PurchaseStatus.completed,
        ),
      );
    } else if (purchase is PurchaseFailed || purchase is PurchaseCanceled) {
      emit(
        state.copyWith(
          purchaseStatus: PurchaseStatus.failed,
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _currentSubscriptionPlanSubscription.cancel();
    _inAppPurchaseUpdateSubscription.cancel();
    return super.close();
  }
}
