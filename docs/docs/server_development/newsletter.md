---
sidebar_position: 4
description: Learn how to configure your own newsletter.
---

# Newsletter

The current [implementation](https://github.com/VGVentures/google_news_template/blob/main/api/lib/src/api/v1/newsletter/create_subscription/create_subscription.dart) of newsletter email subscription will always return true and the response is handled in the app as a success state. Be aware that the current implementation of this feature does not store the subscriber state for a user.

```dart
/// Mixin on [Controller] which adds support for subscribing to a newsletter.
mixin CreateSubscriptionMixin on Controller {
  /// Subscribe to receive a newsletter.
  Future<Response> createSubscription(Request request) async {
    return JsonResponse.created();
  }
}
```

To fully leverage the newsletter subscription feature please add your API handling logic or an already existing email service, such as [mailchimp.](https://mailchimp.com/)
