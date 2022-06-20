import 'package:google_news_template_api/api.dart';
import 'package:google_news_template_api/src/controller.dart';
import 'package:google_news_template_api/src/json_response.dart';
import 'package:shelf/shelf.dart';

/// Mixin on [Controller] which adds support for querying all subscriptions.
mixin GetSubscriptionsMixin on Controller {
  /// Query all available subscriptions.
  Future<Response> getSubscriptions(Request request) async {
    final subscriptions =
        await request.get<NewsDataSource>().getSubscriptions();
    final response = SubscriptionsResponse(subscriptions: subscriptions);
    return JsonResponse.ok(body: response.toJson());
  }
}
