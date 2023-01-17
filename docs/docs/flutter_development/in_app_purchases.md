---
sidebar_position: 9
description: Learn how to configure in-app purchases in your Flutter news application.
---

# In-app purchases

This project supports in-app purchasing for Flutter using the [in_app_purchase](https://pub.dev/packages/in_app_purchase) package. The generated template application provides a mocked version of the`in_app_purchase` package called [`purchase_client`](https://github.com/flutter/news_toolkit/tree/main/flutter_news_example/packages/purchase_client).

The [`PurchaseClient` class](https://github.com/flutter/news_toolkit/blob/main/flutter_news_example/packages/purchase_client/lib/src/purchase_client.dart#L36) implements `InAppPurchase` from the [in_app_purchase](https://pub.dev/packages/in_app_purchase) package and uses the same mechanism to expose the `purchaseStream`:

```dart
@override
Stream<List<PurchaseDetails>> get purchaseStream => _purchaseStream.stream;
```

The [products.dart](https://github.com/flutter/news_toolkit/blob/main/flutter_news_example/packages/purchase_client/lib/src/products.dart) file contains mocked products.

The Dart Frog backend serves a list of available subscription data featuring copy text and price information. To edit the subscription data, change the `getSubscriptions()` method in your custom news data source. Make sure that the product IDs are the same for both your iOS and Android purchase project, as this information is passed to the platform-agnostic `in_app_purchase` package.

To use the [in_app_purchase](https://pub.dev/packages/in_app_purchase) package, substitute `PurchaseClient` in [`main_development.dart`](https://github.com/flutter/news_toolkit/blob/main/flutter_news_example/lib/main/main_development.dart#L87) and [`main_production.dart`](https://github.com/flutter/news_toolkit/blob/main/flutter_news_example/lib/main/main_production.dart#L87) with the `in_app_purchase` package implementation.

Then, follow the [Getting started](https://pub.dev/packages/in_app_purchase#getting-started) section in the `in_app_purchase` package docs.
