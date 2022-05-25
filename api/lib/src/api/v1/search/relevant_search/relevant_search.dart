import 'package:google_news_template_api/api.dart';
import 'package:google_news_template_api/src/controller.dart';
import 'package:google_news_template_api/src/json_response.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:shelf/shelf.dart';

/// Mixin on [Controller] which adds support for searching for relevant content.
mixin RelevantSearchMixin on Controller {
  /// Search for relevant news content based on the `q` query parameter.
  Future<Response> relevantSearch(Request request) async {
    final term = request.url.queryParameters['q'];
    if (term == null) return Response.badRequest();

    final newsDataSource = request.get<NewsDataSource>();
    final results = await Future.wait([
      newsDataSource.getRelevantArticles(term: term),
      newsDataSource.getRelevantTopics(term: term),
    ]);
    final articles = results.first as List<NewsBlock>;
    final topics = results.last as List<String>;
    final response = RelevantSearchResponse(articles: articles, topics: topics);
    return JsonResponse.ok(body: response.toJson());
  }
}
