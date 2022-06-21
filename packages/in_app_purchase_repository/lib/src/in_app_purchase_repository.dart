import 'dart:async';

import 'package:authentication_client/authentication_client.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_news_template_api/client.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:rxdart/rxdart.dart';

/// {@template in_app_purchases_failure}
/// Base failure class for the in-app purchases repository failures.
/// {@endtemplate}
abstract class InAppPurchasesFailure with EquatableMixin implements Exception {
  /// {@macro in_app_purchases_failure}
  const InAppPurchasesFailure(this.error, this.stackTrace);

  /// The error which was caught.
  final Object error;

  /// The stack trace associated with the [error].
  final StackTrace stackTrace;

  @override
  List<Object?> get props => [error, stackTrace];
}

/// {@template deliver_in_app_purchase_failure}
/// An exception thrown when delivering a purchase from the purchaseStream
/// fails.
/// {@endtemplate}
class DeliverInAppPurchaseFailure extends InAppPurchasesFailure {
  /// {@macro deliver_in_app_purchase_failure}
  const DeliverInAppPurchaseFailure(super.error, super.stackTrace);
}

/// {@template complete_in_app_purchase_failure}
/// An exception thrown when completing a purchase from the purchaseStream
/// fails.
/// {@endtemplate}
class CompleteInAppPurchaseFailure extends InAppPurchasesFailure {
  /// {@macro complete_in_app_purchase_failure}
  const CompleteInAppPurchaseFailure(super.error, super.stackTrace);
}

/// {@template internal_in_app_purchase_failure}
/// An exception thrown when emitted purchase from the purchaseStream
/// has status [PurchaseStatus.error].
/// {@endtemplate}
class InternalInAppPurchaseFailure extends InAppPurchasesFailure {
  /// {@macro internal_in_app_purchase_failure}
  const InternalInAppPurchaseFailure(super.error, super.stackTrace);
}

/// {@template fetch_in_app_purchases_failure}
/// An exception thrown when fetching in app products fails.
/// {@endtemplate}
class FetchInAppProductsFailure extends InAppPurchasesFailure {
  /// {@macro fetch_in_app_purchases_failure}
  const FetchInAppProductsFailure(super.error, super.stackTrace);
}

/// {@template query_in_app_product_details_failure}
/// An exception thrown when querying in app product details fails.
/// {@endtemplate}
class QueryInAppProductDetailsFailure extends InAppPurchasesFailure {
  /// {@macro query_in_app_product_details_failure}
  const QueryInAppProductDetailsFailure(super.error, super.stackTrace);
}

/// {@template in_app_purchase_buy_consumable_failure}
/// An exception thrown when buyNonConsumable returns false.
/// {@endtemplate}
class InAppPurchaseBuyNonConsumableFailure extends InAppPurchasesFailure {
  /// {@macro in_app_purchase_buy_consumable_failure}
  const InAppPurchaseBuyNonConsumableFailure(super.error, super.stackTrace);
}

/// {@template in_app_purchases_repository}
/// The `InAppPurchasesRepository` uses [in_app_purchase](https://pub.dev/packages/in_app_purchase)
/// package to conduct native in-app purchases.
///
/// Here is a quick explanation of how the purchase flow looks like:
/// 1.  The app displays a list of available products that are fetched using the
///     [fetchProducts] method. The products are stored in the Firebase Realtime
///     Database in the [rewards_iap_reboot](https://console.firebase.google.com/u/0/project/hamilton-app-cms-dev/database/hamilton-app-cms-dev-e3d74/data/~2Frewards_iap_reboot)
///     collection.
///
/// 2.  Once the user selects one of the products, the [purchase] method is
///     called. This method does not update us about the entire purchase
///     process. However, the purchase updates are available through the
///     [purchaseStream](https://pub.dev/documentation/in_app_purchase/latest/in_app_purchase/InAppPurchase/purchaseStream.html).
///
/// 3.  A native dialog appears which allows the user to finish the transaction.
///
/// 4.  Once a user successfully finishes the transaction, a [PurchaseDetails](https://pub.dev/documentation/in_app_purchase_platform_interface/latest/in_app_purchase_platform_interface/PurchaseDetails-class.html)
///     object is pushed to the `purchaseStream`. It will have a [pendingCompletePurchase](https://pub.dev/documentation/in_app_purchase_platform_interface/latest/in_app_purchase_platform_interface/PurchaseDetails/pendingCompletePurchase.html)
///     flag set to true, which means that we need to deliver the content of the
///     product to the user (upgrade the star count) and mark the purchase as
///     completed using [completePurchase](https://pub.dev/documentation/in_app_purchase_platform_interface/latest/in_app_purchase_platform_interface/InAppPurchasePlatform/completePurchase.html)
///     method.

/// Note: When the [InAppPurchaseRepository] is created, a subscription to user
///       stream from `AuthenticationClient` is created.
///       Whenever the user changes, we call the [restorePurchases](https://pub.dev/documentation/in_app_purchase_platform_interface/latest/in_app_purchase_platform_interface/InAppPurchasePlatform/restorePurchases.html)
///       method in order to restore all previous purchases that haven't been
///       completed yet. Those restored purchases are delivered through the [purchaseStream](https://pub.dev/documentation/in_app_purchase/latest/in_app_purchase/InAppPurchase/purchaseStream.html)
///       with a status of [PurchaseStatus.restored](https://pub.dev/documentation/in_app_purchase_platform_interface/latest/in_app_purchase_platform_interface/PurchaseStatus.html).
/// {@endtemplate}
class InAppPurchaseRepository {
  /// {@macro in_app_purchases_repository}
  InAppPurchaseRepository({
    required AuthenticationClient authenticationClient,
    required GoogleNewsTemplateApiClient apiClient,
    required InAppPurchase inAppPurchase,
  })  : _apiClient = apiClient,
        _authenticationClient = authenticationClient,
        _inAppPurchase = inAppPurchase {
    _inAppPurchase.purchaseStream
        .expand((value) => value)
        .listen(_onPurchaseUpdated);
  }

  final InAppPurchase _inAppPurchase;
  final GoogleNewsTemplateApiClient _apiClient;
  final AuthenticationClient _authenticationClient;

  final BehaviorSubject<SubscriptionPlan> _currentSubscriptionPlanSubject =
      BehaviorSubject.seeded(SubscriptionPlan.none);

  /// A stream of the current subscription plan of a user.
  Stream<SubscriptionPlan> get currentSubscriptionPlan =>
      _currentSubscriptionPlanSubject.stream;

  final _purchaseUpdateStreamController =
      StreamController<PurchaseUpdate>.broadcast();

  /// A stream of purchase updates.
  ///
  /// List of possible updates:
  /// * [PurchaseCanceled]
  /// * [PurchaseDelivered]
  /// * [PurchaseCompleted]
  /// * [PurchaseFailed]
  Stream<PurchaseUpdate> get purchaseUpdateStream =>
      _purchaseUpdateStreamController.stream;

  List<ProductDetails>? _cachedProducts;

  /// Fetches and caches in-app products from the server.
  Future<List<ProductDetails>> fetchProducts() async {
    if (_cachedProducts != null) {
      return _cachedProducts!;
    }

    try {
      final response = await _apiClient.getSubscriptions();
      _cachedProducts = response.subscriptions.toProductDetails();
      return _cachedProducts ?? [];
    } catch (error, stackTrace) {
      throw FetchInAppProductsFailure(error, stackTrace);
    }
  }

  /// Allows the user to purchase given [product].
  ///
  /// When called, the native in-app purchase dialog will appear,
  /// which will allow the user to complete the payment.
  ///
  /// When the payment is successfully completed, the app informs
  /// the server about the purchased product. The server then verifies
  /// if the purchase was correct and updates user's amount of stars.
  Future<void> purchase({
    required ProductDetails product,
  }) async {
    final productDetailsResponse =
        await _inAppPurchase.queryProductDetails({product.id});

    if (productDetailsResponse.error != null) {
      throw QueryInAppProductDetailsFailure(
        productDetailsResponse.error.toString(),
        StackTrace.current,
      );
    }

    if (productDetailsResponse.productDetails.isEmpty) {
      throw QueryInAppProductDetailsFailure(
        'No products found with id ${product.id}.',
        StackTrace.current,
      );
    }

    if (productDetailsResponse.productDetails.length > 1) {
      throw QueryInAppProductDetailsFailure(
        'Found ${productDetailsResponse.productDetails.length} products '
        'with id ${product.id}. Only one should be found.',
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
      throw InAppPurchaseBuyNonConsumableFailure(
        'Failed to buy ${productDetails.id} for user ${user.id}',
        StackTrace.current,
      );
    }
  }

  /// If user is authenticated, then the `restorePurchases` can be called
  /// in order to restore all the previous purchases.
  ///
  /// Restored purchases are delivered through the purchaseStream
  /// with a status of [PurchaseStatus.restored].
  Future restorePurchases() async {
    final user = await _authenticationClient.user.first;
    if (!user.isAnonymous) {
      await _inAppPurchase.restorePurchases(applicationUserName: user.id);
    }
  }

  Future _onPurchaseUpdated(PurchaseDetails purchase) async {
    /// On iOS, the canceled status is never reported.
    /// When the native payment dialog is closed, the error status is reported.
    if (purchase.status == PurchaseStatus.canceled) {
      _purchaseUpdateStreamController.add(PurchaseCanceled());
    }

    if (purchase.status == PurchaseStatus.error) {
      _purchaseUpdateStreamController.add(
        PurchaseFailed(
          failure: InternalInAppPurchaseFailure(
            purchase.error.toString(),
            StackTrace.current,
          ),
        ),
      );
    }

    try {
      if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        final purchasedProduct = (await fetchProducts())
            .where((product) => product.id == purchase.productID)
            .first;

        _purchaseUpdateStreamController.add(
          PurchasePurchased(product: purchasedProduct),
        );

        await _apiClient.createSubscription(
          subscriptionId: purchasedProduct.id,
        );

        _purchaseUpdateStreamController.add(
          PurchaseDelivered(product: purchasedProduct),
        );

        final response = await _apiClient.getCurrentUser();

        _currentSubscriptionPlanSubject.add(response.user.subscription);
      }
    } catch (error, stackTrace) {
      _purchaseUpdateStreamController.add(
        PurchaseFailed(
          failure: DeliverInAppPurchaseFailure(
            error,
            stackTrace,
          ),
        ),
      );
    }

    try {
      if (purchase.pendingCompletePurchase) {
        final purchasedProduct = (await fetchProducts())
            .where((product) => product.id == purchase.productID)
            .first;

        await _inAppPurchase.completePurchase(purchase);

        _purchaseUpdateStreamController.add(
          PurchaseCompleted(
            product: purchasedProduct,
          ),
        );
      }
    } catch (error, stackTrace) {
      _purchaseUpdateStreamController.add(
        PurchaseFailed(
          failure: CompleteInAppPurchaseFailure(
            error,
            stackTrace,
          ),
        ),
      );
    }
  }
}

/// {@template purchase_update}
/// A base class that represents a purchase update.
/// {@endtemplate}
abstract class PurchaseUpdate {
  /// {@macro purchase_update}
  const PurchaseUpdate();
}

/// {@template purchase_delivered}
/// An update representing a delivered purchase.
/// {@endtemplate}
class PurchaseDelivered extends PurchaseUpdate {
  /// {@macro purchase_delivered}
  PurchaseDelivered({
    required this.product,
  }) : super();

  /// A product associated with a purchase that was delivered.
  final ProductDetails product;
}

/// {@template purchase_completed}
/// An update representing a completed purchase.
/// {@endtemplate}
class PurchaseCompleted extends PurchaseUpdate {
  /// {@macro purchase_completed}
  PurchaseCompleted({
    required this.product,
  }) : super();

  /// A product that was successfully purchased.
  final ProductDetails product;
}

/// {@template purchase_purchased}
/// An update representing a purchased purchase but has not been delivered yet.
/// {@endtemplate}
class PurchasePurchased extends PurchaseUpdate {
  /// {@macro purchase_purchased}
  PurchasePurchased({
    required this.product,
  }) : super();

  /// A product that was successfully purchased.
  final ProductDetails product;
}

/// {@template purchase_canceled}
/// An update representing canceled purchase.
/// {@endtemplate}
class PurchaseCanceled extends PurchaseUpdate {
  /// {@macro purchase_canceled}
  PurchaseCanceled() : super();
}

/// {@template purchase_failed}
/// An update representing failed purchase.
/// {@endtemplate}
class PurchaseFailed extends PurchaseUpdate {
  /// {@macro purchase_failed}
  PurchaseFailed({
    required this.failure,
  }) : super();

  /// A failure which occurred when purchasing a product.
  final InAppPurchasesFailure failure;
}

/// {@template purchase_details_from_subscription}
/// An extension that creates a ProductDetails from a Subscription.
@visibleForTesting
extension SubscriptionToProductDetails on List<Subscription> {
  /// {@macro purchase_details_from_subscription}
  List<ProductDetails> toProductDetails() {
    return map(
      (subscription) => ProductDetails(
        id: subscription.id,
        currencyCode: 'USD',
        description: subscription.benefits.toString(),
        price: subscription.cost.monthly.toString(),
        title: subscription.name.toString(),
        rawPrice: subscription.cost.monthly.toDouble(),
      ),
    ).toList();
  }
}
