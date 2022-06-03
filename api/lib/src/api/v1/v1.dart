import 'package:google_news_template_api/src/api/v1/articles/articles.dart';
import 'package:google_news_template_api/src/api/v1/categories/categories.dart';
import 'package:google_news_template_api/src/api/v1/feed/feed.dart';
import 'package:google_news_template_api/src/api/v1/newsletter/newsletter.dart';
import 'package:google_news_template_api/src/api/v1/search/search.dart';
import 'package:google_news_template_api/src/api/v1/subscriptions/subscriptions.dart';
import 'package:google_news_template_api/src/controller.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

/// {@template api_v1_controller}
/// API V1
/// {@endtemplate}
class ApiV1Controller extends Controller {
  /// {@macro api_v1_controller}
  const ApiV1Controller();

  @override
  Handler get handler {
    return Router()
      ..register('/articles', const ArticlesController())
      ..register('/categories', const CategoriesController())
      ..register('/feed', const FeedController())
      ..register('/newsletter', const NewsletterController())
      ..register('/search', const SearchController())
      ..register('/subscriptions', const SubscriptionsController());
  }
}
