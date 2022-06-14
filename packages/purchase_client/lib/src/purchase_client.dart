import 'dart:async';

import 'package:clock/clock.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
// ignore: implementation_imports
import 'package:in_app_purchase_platform_interface/src/in_app_purchase_platform_addition.dart';

/// Extension on PurchaseDetails enabling copyWith.
extension PurchaseDetailsCopyWith on PurchaseDetails {
  /// Returns a copy of the current PurchaseDetails with the given parameters.
  PurchaseDetails copyWith({
    String? purchaseID,
    String? productID,
    PurchaseVerificationData? verificationData,
    String? transactionDate,
    PurchaseStatus? status,
    bool? pendingCompletePurchase,
  }) {
    return PurchaseDetails(
      purchaseID: purchaseID ?? this.purchaseID,
      productID: productID ?? this.productID,
      verificationData: verificationData ?? this.verificationData,
      transactionDate: transactionDate ?? this.transactionDate,
      status: status ?? this.status,
    )..pendingCompletePurchase =
        pendingCompletePurchase ?? this.pendingCompletePurchase;
  }
}

/// {@template purchase_client}
/// A PurchaseClient stubbing InAppPurchase implementation.
///
/// For real implementation, see [InAppPurchase].
/// {@endtemplate}
class PurchaseClient implements InAppPurchase {
  /// {@macro purchase_client}
  PurchaseClient();

  /// List of products defined in stores.
  ///
  /// Has to be defined in the underlying payment platform, for example,
  /// [App Store Connect](https://appstoreconnect.apple.com/) for iOS
  /// and [Google Play Console](https://play.google.com/) for Android.
  List<ProductDetails> products = <ProductDetails>[
    ProductDetails(
      id: '17e79fca-853a-40e3-b4a7-291a64d3846b',
      title: 'premium',
      description: 'premium subscription',
      price: r'$14.99',
      rawPrice: 14.99,
      currencyCode: 'USD',
    ),
  ];

  @override
  Stream<List<PurchaseDetails>> get purchaseStream => _purchaseStream.stream;

  final StreamController<List<PurchaseDetails>> _purchaseStream =
      StreamController<List<PurchaseDetails>>.broadcast();

  @override
  Future<bool> buyConsumable({
    required PurchaseParam purchaseParam,
    bool autoConsume = true,
  }) =>
      throw UnimplementedError();

  @override
  Future<bool> buyNonConsumable({required PurchaseParam purchaseParam}) async {
    final purchaseDetails = PurchaseDetails(
      productID: purchaseParam.productDetails.id,
      verificationData: PurchaseVerificationData(
        localVerificationData: purchaseParam.applicationUserName!,
        serverVerificationData: purchaseParam.applicationUserName!,
        source: 'local',
      ),
      status: PurchaseStatus.pending,
      transactionDate: clock.now().millisecondsSinceEpoch.toString(),
    );

    _purchaseStream.add([purchaseDetails]);
    try {
      _purchaseStream.add([
        purchaseDetails.copyWith(
          status: PurchaseStatus.purchased,
          pendingCompletePurchase: true,
        ),
      ]);

      return Future.value(true);
    } catch (e) {
      _purchaseStream.add([purchaseDetails..status = PurchaseStatus.error]);
      return Future.value(false);
    }
  }

  @override
  Future<void> completePurchase(PurchaseDetails purchase) async {
    _purchaseStream.add([purchase.copyWith(pendingCompletePurchase: false)]);
  }

  @override
  T getPlatformAddition<T extends InAppPurchasePlatformAddition?>() {
    throw UnimplementedError();
  }

  @override
  Future<bool> isAvailable() {
    return Future<bool>.delayed(
      const Duration(milliseconds: 100),
    ).then((_) => true);
  }

  @override
  Future<ProductDetailsResponse> queryProductDetails(Set<String> identifiers) {
    final notFoundIdentifiers = identifiers
        .where(
          (identifier) => !products.any(
            (product) => product.id == identifier,
          ),
        )
        .toList();

    return Future.value(
      ProductDetailsResponse(
        productDetails: products,
        notFoundIDs: notFoundIdentifiers,
      ),
    );
  }

  @override
  Future<void> restorePurchases({String? applicationUserName}) {
    // No purchases are restored
    // in this stubbed implementation of InAppPurchase.
    return Future.value();
  }
}
