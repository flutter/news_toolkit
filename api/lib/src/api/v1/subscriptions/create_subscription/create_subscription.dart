import 'package:google_news_template_api/src/controller.dart';
import 'package:google_news_template_api/src/json_response.dart';
import 'package:shelf/shelf.dart';

/// Mixin on [Controller] which adds support for creating a new subscription.
mixin CreateSubscriptionMixin on Controller {
  /// Create a new subscription.
  Future<Response> createSubscription(Request request) async {
    return JsonResponse.created();
  }
}
