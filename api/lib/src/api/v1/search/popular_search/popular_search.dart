import 'package:google_news_template_api/api.dart';
import 'package:google_news_template_api/src/controller.dart';
import 'package:google_news_template_api/src/json_response.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:shelf/shelf.dart';

/// Mixin on [Controller] which adds support for searching for popular content.
mixin PopularSearchMixin on Controller {
  /// Search for popular news content.
  Future<Response> popularSearch(Request request) async {
    final newsDataSource = request.get<NewsDataSource>();
    final results = await Future.wait([
      newsDataSource.getPopularArticles(),
      newsDataSource.getPopularTopics(),
    ]);
    final articles = results.first as List<NewsBlock>;
    final topics = results.last as List<String>;
    final response = PopularSearchResponse(articles: articles, topics: topics);
    return JsonResponse.ok(body: response.toJson());
  }
}
