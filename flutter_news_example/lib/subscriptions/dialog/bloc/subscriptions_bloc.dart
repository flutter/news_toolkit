import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:in_app_purchase_repository/in_app_purchase_repository.dart';
import 'package:user_repository/user_repository.dart';

part 'subscriptions_event.dart';
part 'subscriptions_state.dart';

class SubscriptionsBloc extends Bloc<SubscriptionsEvent, SubscriptionsState> {
  SubscriptionsBloc({
    required InAppPurchaseRepository inAppPurchaseRepository,
    required UserRepository userRepository,
  })  : _inAppPurchaseRepository = inAppPurchaseRepository,
        _userRepository = userRepository,
        super(
          SubscriptionsState.initial(),
        ) {
    on<SubscriptionsRequested>(_onSubscriptionsRequested);
    on<SubscriptionPurchaseRequested>(_onSubscriptionPurchaseRequested);
    on<SubscriptionPurchaseUpdated>(_onSubscriptionPurchaseUpdated);

    _subscriptionPurchaseUpdateSubscription =
        _inAppPurchaseRepository.purchaseUpdate.listen(
      (purchase) => add(SubscriptionPurchaseUpdated(purchase: purchase)),
      onError: addError,
    );
  }

  final InAppPurchaseRepository _inAppPurchaseRepository;
  final UserRepository _userRepository;

  late StreamSubscription<PurchaseUpdate>
      _subscriptionPurchaseUpdateSubscription;

  FutureOr<void> _onSubscriptionsRequested(
    SubscriptionsRequested event,
    Emitter<SubscriptionsState> emit,
  ) async {
    try {
      final subscriptions = await _inAppPurchaseRepository.fetchSubscriptions();
      emit(state.copyWith(subscriptions: subscriptions));
    } catch (error, stackTrace) {
      addError(error, stackTrace);
    }
  }

  FutureOr<void> _onSubscriptionPurchaseRequested(
    SubscriptionPurchaseRequested event,
    Emitter<SubscriptionsState> emit,
  ) async {
    try {
      emit(state.copyWith(purchaseStatus: PurchaseStatus.pending));
      await _inAppPurchaseRepository.purchase(subscription: event.subscription);
    } catch (error, stackTrace) {
      addError(error, stackTrace);
    }
  }

  FutureOr<void> _onSubscriptionPurchaseUpdated(
    SubscriptionPurchaseUpdated event,
    Emitter<SubscriptionsState> emit,
  ) async {
    final purchase = event.purchase;

    if (purchase is PurchasePurchased) {
      emit(
        state.copyWith(
          purchaseStatus: PurchaseStatus.pending,
        ),
      );
    } else if (purchase is PurchaseDelivered) {
      await _userRepository.updateSubscriptionPlan();
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
    _subscriptionPurchaseUpdateSubscription.cancel();
    return super.close();
  }
}
