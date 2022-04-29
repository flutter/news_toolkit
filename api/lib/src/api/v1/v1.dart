import 'package:google_news_template_api/src/api/v1/categories/categories.dart';
import 'package:google_news_template_api/src/api/v1/feed/feed.dart';
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
      ..register('/categories', const CategoriesController())
      ..register('/feed', const FeedController());
  }
}
