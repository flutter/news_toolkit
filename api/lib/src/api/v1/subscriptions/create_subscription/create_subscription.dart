import 'package:google_news_template_api/api.dart';
import 'package:google_news_template_api/src/controller.dart';
import 'package:google_news_template_api/src/json_response.dart';
import 'package:shelf/shelf.dart';

/// Mixin on [Controller] which adds support for creating a new subscription.
mixin CreateSubscriptionMixin on Controller {
  /// Create a new subscription.
  Future<Response> createSubscription(Request request) async {
    final userId = request.userId;
    if (userId == null) return Response.badRequest();

    await request.get<NewsDataSource>().createSubscription(
          userId: userId,
          subscription: SubscriptionPlan.premium,
        );

    return JsonResponse.created();
  }
}

extension on Request {
  String? get userId {
    final authorizationHeader = headers['authorization'];
    if (authorizationHeader == null) return null;
    final segments = authorizationHeader.split(' ');
    if (segments.length != 2) return null;
    if (segments.first.toLowerCase() != 'bearer') return null;
    final userId = segments.last;
    return userId;
  }
}
