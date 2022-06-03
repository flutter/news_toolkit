import 'package:google_news_template_api/api.dart';
import 'package:google_news_template_api/src/controller.dart';
import 'package:google_news_template_api/src/json_response.dart';
import 'package:shelf/shelf.dart';

/// Mixin on [Controller] which adds support for fetching article content.
mixin GetArticleMixin on Controller {
  /// Get the article content for the provided [id].
  Future<Response> getArticle(Request request, String id) async {
    final queryParams = request.url.queryParameters;
    final limit = int.tryParse(queryParams['limit'] ?? '') ?? 20;
    final offset = int.tryParse(queryParams['offset'] ?? '') ?? 0;

    final article = await request.get<NewsDataSource>().getArticle(
          id: id,
          limit: limit,
          offset: offset,
        );

    if (article == null) return JsonResponse.notFound();
    final response = ArticleResponse(
      content: article.blocks,
      totalCount: article.totalBlocks,
      url: article.url,
    );
    return JsonResponse.ok(body: response.toJson());
  }
}
