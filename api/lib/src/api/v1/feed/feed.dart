import 'package:google_news_template_api/src/api/v1/feed/get_feed/get_feed.dart';
import 'package:google_news_template_api/src/controller.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

/// {@template feed}
/// Controller for `/api/v1/feed` routes.
/// {@endtemplate}
class FeedController extends Controller with GetFeedMixin {
  /// {@macro feed}
  const FeedController();

  @override
  Handler get handler {
    return Router()..get('/', getFeed);
  }
}
