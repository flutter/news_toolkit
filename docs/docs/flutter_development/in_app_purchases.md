---
sidebar_position: 9
description: Learn how to configure in-app purchases in your Flutter news application.
---

# In-App Purchases

This project supports in-app purchasing for Flutter using the [in_app_purchase](https://pub.dev/packages/in_app_purchase) package. For the purpose of this template application, a mocked version of the`in_app_purchase` package was created called [purchase_client](https://github.com/flutter/news_toolkit/tree/main/flutter_news_example/packages/purchase_client).

The [PurchaseClient class](https://github.com/flutter/news_toolkit/blob/main/flutter_news_example/packages/purchase_client/lib/src/purchase_client.dart#L36) implements `InAppPurchase` from the [in_app_purchase](https://pub.dev/packages/in_app_purchase) package and utilizes the same mechanism to expose the `purchaseStream`.

```dart
@override
Stream<List<PurchaseDetails>> get purchaseStream => _purchaseStream.stream;
```

Mocked products are being exposed in the [products.dart](https://github.com/flutter/news_toolkit/blob/main/flutter_news_example/packages/purchase_client/lib/src/products.dart) file.

A list of availiable subscription data featuring copy text and price information is served by Dart Frog backend. To edit the subscription data, change the `getSubscriptions()` method in your custom news data source. Make sure that the product IDs are the same for your iOS and Android purchase project, as this information will be passed to the platform-agnostic `in_app_purchase` package.

To use the [in_app_purchase](https://pub.dev/packages/in_app_purchase) package, substitute `PurchaseClient` usage in [main_development.dart](https://github.com/flutter/news_toolkit/blob/main/flutter_news_example/lib/main/main_development.dart#L87) and [main_production.dart](https://github.com/flutter/news_toolkit/blob/main/flutter_news_example/lib/main/main_production.dart#L87) with the `in_app_purchase` package implementation.

Then, follow the [Getting started](https://pub.dev/packages/in_app_purchase#getting-started) paragraph in the `in_app_purchase` package.
