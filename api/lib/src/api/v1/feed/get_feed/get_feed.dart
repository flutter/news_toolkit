import 'package:google_news_template_api/api.dart';
import 'package:google_news_template_api/src/controller.dart';
import 'package:google_news_template_api/src/json_response.dart';
import 'package:shelf/shelf.dart';

/// Mixin on [Controller] which adds support for fetching a news feed.
mixin GetFeedMixin on Controller {
  /// Get the news feed.
  Future<Response> getFeed(Request request) async {
    final queryParams = request.url.queryParameters;
    final categoryQueryParam = queryParams['category'];
    final category = Category.values.firstWhere(
      (category) => category.name == categoryQueryParam,
      orElse: () => Category.top,
    );
    final limit = int.tryParse(queryParams['limit'] ?? '') ?? 20;
    final offset = int.tryParse(queryParams['offset'] ?? '') ?? 0;
    final feed = await request
        .get<NewsDataSource>()
        .getFeed(category: category, limit: limit, offset: offset);
    final response = FeedResponse(
      feed: feed.blocks,
      totalCount: feed.totalBlocks,
    );
    return JsonResponse.ok(body: response.toJson());
  }
}
