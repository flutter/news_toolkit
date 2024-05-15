// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:purchase_client/purchase_client.dart';
import 'package:purchase_client/src/products.dart';

extension _PurchaseDetailsEquals on PurchaseDetails {
  /// Returns a copy of the current PurchaseDetails with the given parameters.
  bool equals(PurchaseDetails purchaseDetails) =>
      purchaseDetails.purchaseID == purchaseID &&
      purchaseDetails.productID == productID &&
      purchaseDetails.verificationData == verificationData &&
      purchaseDetails.transactionDate == transactionDate &&
      purchaseDetails.status == status &&
      purchaseDetails.pendingCompletePurchase == pendingCompletePurchase &&
      purchaseDetails.error == error;
}

void main() {
  group('PurchaseDetails', () {
    group('copyWith', () {
      final purchaseDetails = PurchaseDetails(
        productID: 'id',
        status: PurchaseStatus.pending,
        transactionDate: 'date',
        verificationData: PurchaseVerificationData(
          localVerificationData: 'local',
          serverVerificationData: 'server',
          source: 'source',
        ),
      );

      test(
          'returns the same object '
          'when no parameters are passed', () {
        expect(purchaseDetails.copyWith().equals(purchaseDetails), isTrue);
      });

      test(
          'sets purchaseID '
          'when purchaseID is passed', () {
        expect(
          purchaseDetails.copyWith(purchaseID: 'newId').purchaseID,
          'newId',
        );
      });

      test(
          'sets productID '
          'when productID is passed', () {
        expect(purchaseDetails.copyWith(productID: 'newId').productID, 'newId');
      });

      test(
          'sets status '
          'when status is passed', () {
        expect(
          purchaseDetails.copyWith(status: PurchaseStatus.purchased).status,
          PurchaseStatus.purchased,
        );
      });
      test(
          'sets transactionDate '
          'when transactionDate is passed', () {
        expect(
          purchaseDetails.copyWith(transactionDate: 'newDate').transactionDate,
          'newDate',
        );
      });

      test(
          'sets verificationData '
          'when verificationData is passed', () {
        final verificationData = PurchaseVerificationData(
          localVerificationData: 'newLocal',
          serverVerificationData: 'newServer',
          source: 'newSource',
        );
        expect(
          purchaseDetails
              .copyWith(verificationData: verificationData)
              .verificationData,
          verificationData,
        );
      });

      test(
          'sets pendingCompletePurchase '
          'when pendingCompletePurchase is passed', () {
        expect(
          purchaseDetails
              .copyWith(pendingCompletePurchase: true)
              .pendingCompletePurchase,
          isTrue,
        );
      });
    });
  });

  group('PurchaseClient', () {
    final productDetails = availableProducts.values.first;

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
          'with an empty notFoundIDs '
          'when no identifiers are provided', () async {
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
        'and adds purchase '
        'with purchase status PurchaseStatus.pending '
        'to purchaseStream', () async {
      final result = await purchaseClient.buyNonConsumable(
        purchaseParam: PurchaseParam(
          productDetails: productDetails,
          applicationUserName: 'testUserName',
        ),
      );

      purchaseClient.purchaseStream.listen((purchases) {
        expect(purchases, equals([purchaseDetails]));
        expect(purchases.first.status, equals(PurchaseStatus.pending));
      });

      expect(result, true);
    });

    test(
        'completePurchase adds purchaseDetails to purchaseStream '
        'with pendingCompletePurchase set to false', () async {
      await Future.wait([
        expectLater(
          purchaseClient.purchaseStream,
          emitsThrough(
            (List<PurchaseDetails> purchases) => purchases.first.equals(
              purchaseDetails.copyWith(
                pendingCompletePurchase: false,
              ),
            ),
          ),
        ),
        purchaseClient.completePurchase(purchaseDetails),
      ]);
    });

    test('restorePurchases completes', () async {
      await expectLater(purchaseClient.restorePurchases(), completes);
    });

    test('buyConsumable throws an UnimplementedError', () async {
      expect(
        () => purchaseClient.buyConsumable(
          purchaseParam: PurchaseParam(
            productDetails: productDetails,
            applicationUserName: 'testUserName',
          ),
        ),
        throwsA(isA<UnimplementedError>()),
      );
    });

    test('getPlatformAddition throws an UnimplementedError', () async {
      expect(
        () => purchaseClient.getPlatformAddition(),
        throwsA(isA<UnimplementedError>()),
      );
    });

    test('countryCode throws an UnimplementedError', () async {
      expect(
        () => purchaseClient.countryCode(),
        throwsA(isA<UnimplementedError>()),
      );
    });
  });
}
