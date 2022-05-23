// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:io';

import 'package:google_news_template_api/api.dart';
import 'package:google_news_template_api/src/api/v1/search/search.dart';
import 'package:google_news_template_api/src/data/in_memory_news_data_source.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import '../../../../../test_server.dart';

class MockNewsDataSource extends Mock implements NewsDataSource {}

void main() {
  group('GET /api/v1/search/relevant', () {
    late NewsDataSource newsDataSource;
    late SearchController controller;

    setUp(() {
      newsDataSource = MockNewsDataSource();
      controller = SearchController();
    });

    testServer(
      'returns a 400 when query parameter is missing',
      (host) async {
        final response = await get(Uri.parse('$host/relevant'));
        expect(response.statusCode, equals(HttpStatus.badRequest));
      },
      handler: () => controller.handler,
    );

    testServer(
      'returns a 200 on success',
      (host) async {
        const term = '__test_term__';
        final expected = RelevantSearchResponse(
          articles: relevantArticles.map((item) => item.post).toList(),
          topics: relevantTopics,
        );
        when(
          () => newsDataSource.getRelevantArticles(term: any(named: 'term')),
        ).thenAnswer((_) async => expected.articles);
        when(
          () => newsDataSource.getRelevantTopics(term: any(named: 'term')),
        ).thenAnswer((_) async => expected.topics);
        final response = await get(
          Uri.parse('$host/relevant').replace(
            queryParameters: <String, String>{'q': term},
          ),
        );
        expect(response.statusCode, equals(HttpStatus.ok));
        expect(response.body, equals(json.encode(expected.toJson())));
      },
      pipeline: () => Pipeline().inject<NewsDataSource>(newsDataSource),
      handler: () => controller.handler,
    );
  });
}
