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
  group('GET /api/v1/search/popular', () {
    late NewsDataSource newsDataSource;
    late SearchController controller;

    setUp(() {
      newsDataSource = MockNewsDataSource();
      controller = SearchController();
    });

    testServer(
      'returns a 200 on success',
      (host) async {
        final expected = PopularSearchResponse(
          articles: popularArticles.map((item) => item.post).toList(),
          topics: popularTopics,
        );
        when(() => newsDataSource.getPopularArticles()).thenAnswer(
          (_) async => expected.articles,
        );
        when(
          () => newsDataSource.getPopularTopics(),
        ).thenAnswer((_) async => expected.topics);
        final response = await get(Uri.parse('$host/popular'));
        expect(response.statusCode, equals(HttpStatus.ok));
        expect(response.body, equals(json.encode(expected.toJson())));
      },
      pipeline: () => Pipeline().inject<NewsDataSource>(newsDataSource),
      handler: () => controller.handler,
    );
  });
}
