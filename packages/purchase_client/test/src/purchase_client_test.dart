// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:purchase_client/purchase_client.dart';

void main() {
  group('PurchaseClient', () {
    final productDetails = ProductDetails(
      id: '17e79fca-853a-40e3-b4a7-291a64d3846b',
      title: 'premium',
      description: 'premium subscription',
      price: r'$14.99',
      rawPrice: 14.99,
      currencyCode: 'USD',
    );

    final purchaseDetails = PurchaseDetails(
      productID: 'productID',
      verificationData: PurchaseVerificationData(
        localVerificationData: 'localVerificationData',
        serverVerificationData: 'serverVerificationData',
        source: 'local',
      ),
      transactionDate: 'transactionDate',
      status: PurchaseStatus.purchased,
    );

    late PurchaseClient purchaseClient;

    setUp(() {
      purchaseClient = PurchaseClient();
    });

    test('isAvailable returns true', () {
      expect(purchaseClient.isAvailable(), completion(isTrue));
    });

    group('queryProductDetails', () {
      test(
          'returns empty productDetails '
          'with an empty notFoundIDs', () async {
        final response = await purchaseClient.queryProductDetails(<String>{});
        expect(response.notFoundIDs, isEmpty);
        expect(response.productDetails, isEmpty);
      });

      test(
          'returns found productDetails '
          'with an empty notFoundIDs', () async {
        final response = await purchaseClient
            .queryProductDetails(<String>{productDetails.id});

        expect(response.notFoundIDs, isEmpty);
        expect(response.productDetails.length, equals(1));
        expect(response.productDetails.first.id, equals(productDetails.id));
      });

      test(
          'returns an empty productDetails '
          'with provided id in notFoundIDs', () async {
        final response =
            await purchaseClient.queryProductDetails(<String>{'unknownId'});
        expect(response.notFoundIDs, equals(['unknownId']));
        expect(response.productDetails, equals(<ProductDetails>[]));
      });
    });

    test(
        'buyNonConsumable returns true '
        'and adds to purchaseStream ', () async {
      final result = await purchaseClient.buyNonConsumable(
        purchaseParam: PurchaseParam(
          productDetails: productDetails,
          applicationUserName: 'testUserName',
        ),
      );

      purchaseClient.purchaseStream.listen((purchases) {
        expect(purchases, equals([purchaseDetails]));
      });

      expect(result, true);
    });
    test('completePurchase', () async {
      await purchaseClient.completePurchase(purchaseDetails);

      purchaseClient.purchaseStream.listen((purchases) {
        expect(purchases, equals([purchaseDetails]));
      });
    });

    test('restorePurchases', () async {
      await expectLater(purchaseClient.restorePurchases(), completes);
    });
  });
}
