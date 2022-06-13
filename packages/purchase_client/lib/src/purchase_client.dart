import 'dart:async';

import 'package:google_news_template_api/client.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_platform_interface/src/in_app_purchase_platform_addition.dart';

/// {@template purchase_client}
/// A PurchaseClient stubbing InAppPurchase implementation.
///
/// For real implementation, see [InAppPurchase].
/// {@endtemplate}
class PurchaseClient implements InAppPurchase {
  /// {@macro purchase_client}
  PurchaseClient({
    required GoogleNewsTemplateApiClient apiClient,
  }) : _apiClient = apiClient;

  final GoogleNewsTemplateApiClient _apiClient;

  @override
  Stream<List<PurchaseDetails>> get purchaseStream => _purchaseStream.stream;

  final StreamController<List<PurchaseDetails>> _purchaseStream =
      StreamController<List<PurchaseDetails>>.broadcast();

  @override
  Future<bool> buyConsumable(
      {required PurchaseParam purchaseParam, bool autoConsume = true}) {
    // TODO: implement buyConsumable
    throw UnimplementedError();
  }

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
      transactionDate: DateTime.now().millisecondsSinceEpoch.toString(),
    );

    _purchaseStream.add([purchaseDetails]);
    try {
      await _apiClient.createSubscription(
        subscription: SubscriptionPlan.premium,
      );
      _purchaseStream.add([
        purchaseDetails
          ..status = PurchaseStatus.purchased
          ..pendingCompletePurchase = true
      ]);

      return Future.value(true);
    } catch (e) {
      _purchaseStream.add([purchaseDetails..status = PurchaseStatus.canceled]);
      return Future.value(false);
    }
  }

  @override
  Future<void> completePurchase(PurchaseDetails purchase) async {
    _purchaseStream.add([purchase..pendingCompletePurchase = false]);
  }

  @override
  T getPlatformAddition<T extends InAppPurchasePlatformAddition?>() {
    // TODO: implement getPlatformAddition
    throw UnimplementedError();
  }

  @override
  Future<bool> isAvailable() {
    // isAvailable backend endpoint?
    return Future<bool>.delayed(
      const Duration(milliseconds: 100),
    ).then((_) => true);
  }

  @override
  Future<ProductDetailsResponse> queryProductDetails(Set<String> identifiers) {
    // TODO: implement queryProductDetails
    throw UnimplementedError();
  }

  @override
  Future<void> restorePurchases({String? applicationUserName}) {
    // TODO: implement restorePurchases
    throw UnimplementedError();
  }
}
