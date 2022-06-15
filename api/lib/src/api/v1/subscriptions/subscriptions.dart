import 'package:google_news_template_api/src/api/v1/subscriptions/create_subscription/create_subscription.dart';
import 'package:google_news_template_api/src/api/v1/subscriptions/get_subscriptions/get_subscriptions.dart';
import 'package:google_news_template_api/src/controller.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

/// {@template subscriptions}
/// Controller for `/api/v1/subscriptions` routes.
/// {@endtemplate}
class SubscriptionsController extends Controller
    with CreateSubscriptionMixin, GetSubscriptionsMixin {
  /// {@macro subscriptions}
  const SubscriptionsController();

  @override
  Handler get handler {
    return Router()
      ..get('/', getSubscriptions)
      ..post('/', createSubscription);
  }
}
