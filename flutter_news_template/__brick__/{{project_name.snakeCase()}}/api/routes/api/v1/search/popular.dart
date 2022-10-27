import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:{{project_name.snakeCase()}}_api/api.dart';
import 'package:news_blocks/news_blocks.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.get) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  final newsDataSource = context.read<NewsDataSource>();
  final results = await Future.wait([
    newsDataSource.getPopularArticles(),
    newsDataSource.getPopularTopics(),
  ]);
  final articles = results.first as List<NewsBlock>;
  final topics = results.last as List<String>;
  final response = PopularSearchResponse(articles: articles, topics: topics);
  return Response.json(body: response);
}
