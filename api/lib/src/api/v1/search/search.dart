import 'package:google_news_template_api/src/api/v1/search/popular_search/popular_search.dart';
import 'package:google_news_template_api/src/api/v1/search/relevant_search/relevant_search.dart';
import 'package:google_news_template_api/src/controller.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

/// {@template search}
/// Controller for `/api/v1/search` routes.
/// {@endtemplate}
class SearchController extends Controller
    with PopularSearchMixin, RelevantSearchMixin {
  /// {@macro search}
  const SearchController();

  @override
  Handler get handler {
    return Router()
      ..get('/popular', popularSearch)
      ..get('/relevant', relevantSearch);
  }
}
