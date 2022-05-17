import 'package:google_news_template_api/api.dart';
import 'package:google_news_template_api/src/controller.dart';
import 'package:google_news_template_api/src/json_response.dart';
import 'package:shelf/shelf.dart';

/// Mixin on [Controller] which adds support
/// for fetching related article content.
mixin GetRelatedArticlesMixin on Controller {
  /// Get the related article content for the provided article [id].
  Future<Response> getRelatedArticles(Request request, String id) async {
    final queryParams = request.url.queryParameters;
    final limit = int.tryParse(queryParams['limit'] ?? '') ?? 20;
    final offset = int.tryParse(queryParams['offset'] ?? '') ?? 0;
    final relatedArticles = await request
        .get<NewsDataSource>()
        .getRelatedArticles(id: id, limit: limit, offset: offset);
    final response = RelatedArticlesResponse(
      relatedArticles: relatedArticles.blocks,
      totalCount: relatedArticles.totalBlocks,
    );
    return JsonResponse.ok(body: response.toJson());
  }
}
