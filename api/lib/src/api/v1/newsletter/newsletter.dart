import 'package:google_news_template_api/src/api/v1/newsletter/create_subscription/create_subscription.dart';
import 'package:google_news_template_api/src/controller.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

/// {@template newsletter}
/// Controller for `/api/v1/newsletter` routes.
/// {@endtemplate}
class NewsletterController extends Controller with CreateSubscriptionMixin {
  /// {@macro newsletter}
  const NewsletterController();

  @override
  Handler get handler {
    return Router()..post('/subscription', createSubscription);
  }
}
