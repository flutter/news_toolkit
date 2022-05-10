import 'package:google_news_template_api/api.dart';
import 'package:google_news_template_api/src/controller.dart';
import 'package:google_news_template_api/src/json_response.dart';
import 'package:shelf/shelf.dart';

/// Mixin on [Controller] which adds support for fetching article content.
mixin GetArticleMixin on Controller {
  /// Get the article content for the provided [id].
  Future<Response> getArticle(Request request, String id) async {
    final articles = await request.get<NewsDataSource>().getArticle(id: id);
    return JsonResponse.ok(body: articles.toJson());
  }
}
