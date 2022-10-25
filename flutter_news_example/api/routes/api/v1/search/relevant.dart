import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:flutter_news_template_api/api.dart';
import 'package:news_blocks/news_blocks.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.get) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  final term = context.request.url.queryParameters['q'];
  if (term == null) return Response(statusCode: HttpStatus.badRequest);

  final newsDataSource = context.read<NewsDataSource>();
  final results = await Future.wait([
    newsDataSource.getRelevantArticles(term: term),
    newsDataSource.getRelevantTopics(term: term),
  ]);
  final articles = results.first as List<NewsBlock>;
  final topics = results.last as List<String>;
  final response = RelevantSearchResponse(articles: articles, topics: topics);
  return Response.json(body: response);
}
