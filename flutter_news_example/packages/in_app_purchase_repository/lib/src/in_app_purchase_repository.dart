import 'dart:async';
import 'package:authentication_client/authentication_client.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_news_example_api/client.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

/// {@template in_app_purchase_failure}
/// A base failure class for the in-app purchase repository failures.
/// {@endtemplate}
abstract class InAppPurchaseFailure with EquatableMixin implements Exception {
  /// {@macro in_app_purchase_failure}
  const InAppPurchaseFailure(this.error);

  /// The error which was caught.
  final Object error;

  @override
  List<Object> get props => [error];
}

/// {@template deliver_in_app_purchase_failure}
/// An exception thrown when delivering a purchase from the purchaseStream
/// fails.
/// {@endtemplate}
class DeliverInAppPurchaseFailure extends InAppPurchaseFailure {
  /// {@macro deliver_in_app_purchase_failure}
  const DeliverInAppPurchaseFailure(super.error);
}

/// {@template complete_in_app_purchase_failure}
/// An exception thrown when completing a purchase from the purchaseStream
/// fails.
/// {@endtemplate}
class CompleteInAppPurchaseFailure extends InAppPurchaseFailure {
  /// {@macro complete_in_app_purchase_failure}
  const CompleteInAppPurchaseFailure(super.error);
}

/// {@template internal_in_app_purchase_failure}
/// An exception thrown when emitted purchase from the purchaseStream
/// has status [PurchaseStatus.error].
/// {@endtemplate}
class InternalInAppPurchaseFailure extends InAppPurchaseFailure {
  /// {@macro internal_in_app_purchase_failure}
  const InternalInAppPurchaseFailure(super.error);
}

/// {@template fetch_subscriptions_failure}
/// An exception thrown when fetching subscriptions fails.
/// {@endtemplate}
class FetchSubscriptionsFailure extends InAppPurchaseFailure {
  /// {@macro fetch_subscriptions_failure}
  const FetchSubscriptionsFailure(super.error);
}

/// {@template query_in_app_product_details_failure}
/// An exception thrown when querying in app product details fails.
/// {@endtemplate}
class QueryInAppProductDetailsFailure extends InAppPurchaseFailure {
  /// {@macro query_in_app_product_details_failure}
  const QueryInAppProductDetailsFailure(super.error);
}

/// {@template in_app_purchase_buy_non_consumable_failure}
/// An exception thrown when buyNonConsumable returns false.
/// {@endtemplate}
class InAppPurchaseBuyNonConsumableFailure extends InAppPurchaseFailure {
  /// {@macro in_app_purchase_buy_non_consumable_failure}
  const InAppPurchaseBuyNonConsumableFailure(super.error);
}

/// {@template in_app_purchase_repository}
/// The `InAppPurchaseRepository` uses [in_app_purchase](https://pub.dev/packages/in_app_purchase)
/// package to conduct native in-app purchase.
///
/// Here is a quick explanation of how the purchase flow looks like:
/// 1.  The app displays a list of available (subscriptions) that are fetched
///     using the [fetchSubscriptions] method.
///
/// 2.  Once the user selects one of the products, the [purchase] method is
///     called. This method does not update us about the entire purchase
///     process. However, the purchase updates are available through the
///     [purchaseStream](https://pub.dev/documentation/in_app_purchase/latest/in_app_purchase/InAppPurchase/purchaseStream.html).
///
/// 3.  Once a user successfully finishes the transaction, a [PurchaseDetails](https://pub.dev/documentation/in_app_purchase_platform_interface/latest/in_app_purchase_platform_interface/PurchaseDetails-class.html)
///     object is pushed to the `purchaseStream`. It will have a [pendingCompletePurchase](https://pub.dev/documentation/in_app_purchase_platform_interface/latest/in_app_purchase_platform_interface/PurchaseDetails/pendingCompletePurchase.html)
///     flag set to true, which means that we need to deliver the content of the
///     product to the user and mark the purchase as completed using [completePurchase](https://pub.dev/documentation/in_app_purchase_platform_interface/latest/in_app_purchase_platform_interface/InAppPurchasePlatform/completePurchase.html)
///     method.
/// {@endtemplate}
class InAppPurchaseRepository {
  /// {@macro in_app_purchase_repository}
  InAppPurchaseRepository({
    required AuthenticationClient authenticationClient,
    required FlutterNewsExampleApiClient apiClient,
    required InAppPurchase inAppPurchase,
  })  : _apiClient = apiClient,
        _authenticationClient = authenticationClient,
        _inAppPurchase = inAppPurchase {
    _inAppPurchase.purchaseStream
        .expand((value) => value)
        .listen(_onPurchaseUpdated);
  }

  final InAppPurchase _inAppPurchase;
  final FlutterNewsExampleApiClient _apiClient;
  final AuthenticationClient _authenticationClient;

  final _purchaseUpdateStreamController =
      StreamController<PurchaseUpdate>.broadcast();

  /// A stream of purchase updates.
  ///
  /// List of possible updates:
  /// * [PurchaseCanceled]
  /// * [PurchaseDelivered]
  /// * [PurchaseCompleted]
  /// * [PurchaseFailed]
  Stream<PurchaseUpdate> get purchaseUpdate =>
      _purchaseUpdateStreamController.stream.asBroadcastStream();

  List<Subscription>? _cachedSubscriptions;

  /// Fetches and caches list of subscriptions from the server.
  Future<List<Subscription>> fetchSubscriptions() async {
    try {
      if (_cachedSubscriptions != null) {
        return _cachedSubscriptions!;
      }
      final response = await _apiClient.getSubscriptions();
      _cachedSubscriptions = response.subscriptions;
      return _cachedSubscriptions ?? [];
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        FetchSubscriptionsFailure(error),
        stackTrace,
      );
    }
  }

  /// Allows the user to purchase given [subscription].
  ///
  /// When the payment is successfully completed, the app informs
  /// the server about the purchased subscription. The server then verifies
  /// if the purchase was correct and updates user's subscription.
  Future<void> purchase({
    required Subscription subscription,
  }) async {
    final productDetailsResponse =
        await _inAppPurchase.queryProductDetails({subscription.id});

    if (productDetailsResponse.error != null) {
      Error.throwWithStackTrace(
        QueryInAppProductDetailsFailure(
          productDetailsResponse.error.toString(),
        ),
        StackTrace.current,
      );
    }

    if (productDetailsResponse.productDetails.isEmpty) {
      Error.throwWithStackTrace(
        QueryInAppProductDetailsFailure(
          'No subscription found with id ${subscription.id}.',
        ),
        StackTrace.current,
      );
    }

    if (productDetailsResponse.productDetails.length > 1) {
      Error.throwWithStackTrace(
        QueryInAppProductDetailsFailure(
          'Found ${productDetailsResponse.productDetails.length} products '
          'with id ${subscription.id}. Only one should be found.',
        ),
        StackTrace.current,
      );
    }

    final productDetails = productDetailsResponse.productDetails.first;

    final user = await _authenticationClient.user.first;

    final purchaseParam = PurchaseParam(
      productDetails: productDetails,
      applicationUserName: user.id,
    );

    final isPurchaseRequestSuccessful =
        await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);

    if (!isPurchaseRequestSuccessful) {
      Error.throwWithStackTrace(
        InAppPurchaseBuyNonConsumableFailure(
          'Failed to buy ${productDetails.id} for user ${user.id}',
        ),
        StackTrace.current,
      );
    }
  }

  /// If user is authenticated, then the `restorePurchases` can be called
  /// in order to restore all the previous purchases.
  ///
  /// Restored purchases are delivered through the purchaseStream
  /// with a status of [PurchaseStatus.restored].
  Future<void> restorePurchases() async {
    final user = await _authenticationClient.user.first;
    if (!user.isAnonymous) {
      await _inAppPurchase.restorePurchases(applicationUserName: user.id);
    }
  }

  Future<void> _onPurchaseUpdated(PurchaseDetails purchase) async {
    /// On iOS, the canceled status is never reported.
    /// When the native payment dialog is closed, the error status is reported.
    if (purchase.status == PurchaseStatus.canceled) {
      _purchaseUpdateStreamController.add(const PurchaseCanceled());
    }

    if (purchase.status == PurchaseStatus.error) {
      _purchaseUpdateStreamController.add(
        PurchaseFailed(
          failure: InternalInAppPurchaseFailure(
            purchase.error.toString(),
          ),
        ),
      );
    }

    try {
      if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        final purchasedProduct = (await fetchSubscriptions())
            .firstWhere((product) => product.id == purchase.productID);

        _purchaseUpdateStreamController.add(
          PurchasePurchased(subscription: purchasedProduct),
        );

        await _apiClient.createSubscription(
          subscriptionId: purchasedProduct.id,
        );

        _purchaseUpdateStreamController.add(
          PurchaseDelivered(subscription: purchasedProduct),
        );
      }
    } catch (error, stackTrace) {
      _purchaseUpdateStreamController.addError(
        PurchaseFailed(
          failure: DeliverInAppPurchaseFailure(
            error,
          ),
        ),
        stackTrace,
      );
    }

    try {
      if (purchase.pendingCompletePurchase) {
        final purchasedSubscription = (await fetchSubscriptions()).firstWhere(
          (subscription) => subscription.id == purchase.productID,
        );

        await _inAppPurchase.completePurchase(purchase);

        _purchaseUpdateStreamController.add(
          PurchaseCompleted(
            subscription: purchasedSubscription,
          ),
        );
      }
    } catch (error, stackTrace) {
      _purchaseUpdateStreamController.addError(
        PurchaseFailed(
          failure: CompleteInAppPurchaseFailure(
            error,
          ),
        ),
        stackTrace,
      );
    }
  }
}

/// {@template purchase_update}
/// A base class that represents a purchase update.
/// {@endtemplate}
abstract class PurchaseUpdate extends Equatable {
  /// {@macro purchase_update}
  const PurchaseUpdate();
}

/// {@template purchase_delivered}
/// An update representing a delivered purchase.
/// {@endtemplate}
class PurchaseDelivered extends PurchaseUpdate {
  /// {@macro purchase_delivered}
  const PurchaseDelivered({
    required this.subscription,
  }) : super();

  /// A subscription associated with a purchase that was delivered.
  final Subscription subscription;

  @override
  List<Object> get props => [subscription];
}

/// {@template purchase_completed}
/// An update representing a completed purchase.
/// {@endtemplate}
class PurchaseCompleted extends PurchaseUpdate {
  /// {@macro purchase_completed}
  const PurchaseCompleted({
    required this.subscription,
  }) : super();

  /// A subscription that was successfully purchased.
  final Subscription subscription;

  @override
  List<Object> get props => [subscription];
}

/// {@template purchase_purchased}
/// An update representing a purchased purchase that has not been delivered yet.
/// {@endtemplate}
class PurchasePurchased extends PurchaseUpdate {
  /// {@macro purchase_purchased}
  const PurchasePurchased({
    required this.subscription,
  }) : super();

  /// A subscription that was successfully purchased.
  final Subscription subscription;

  @override
  List<Object> get props => [subscription];
}

/// {@template purchase_canceled}
/// An update representing canceled purchase.
/// {@endtemplate}
class PurchaseCanceled extends PurchaseUpdate {
  /// {@macro purchase_canceled}
  const PurchaseCanceled() : super();

  @override
  List<Object> get props => [];
}

/// {@template purchase_failed}
/// An update representing failed purchase.
/// {@endtemplate}
class PurchaseFailed extends PurchaseUpdate {
  /// {@macro purchase_failed}
  const PurchaseFailed({
    required this.failure,
  }) : super();

  /// A failure which occurred when purchasing a subscription.
  final InAppPurchaseFailure failure;

  @override
  List<Object> get props => [];
}
