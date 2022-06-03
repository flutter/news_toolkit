// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:io';

import 'package:google_news_template_api/api.dart';
import 'package:google_news_template_api/src/api/v1/articles/articles.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import '../../../../../test_server.dart';

class MockNewsDataSource extends Mock implements NewsDataSource {}

void main() {
  group('GET /api/v1/articles/<id>', () {
    const articleId = '__test_article_id__';
    late NewsDataSource newsDataSource;
    late ArticlesController controller;

    setUp(() {
      newsDataSource = MockNewsDataSource();
      controller = ArticlesController();
    });

    testServer(
      'returns a 404 when article is not found',
      (host) async {
        when(
          () => newsDataSource.getArticle(id: articleId),
        ).thenAnswer((_) async => null);
        final response = await get(Uri.parse('$host/$articleId'));
        expect(response.statusCode, equals(HttpStatus.notFound));
      },
      pipeline: () => Pipeline().inject<NewsDataSource>(newsDataSource),
      handler: () => controller.handler,
    );

    testServer(
      'returns a 200 on success',
      (host) async {
        final url = Uri.parse('https://dailyglobe.com');
        final article = Article(blocks: const [], totalBlocks: 0, url: url);
        when(
          () => newsDataSource.getArticle(id: articleId),
        ).thenAnswer((_) async => article);
        final expected = ArticleResponse(
          content: article.blocks,
          totalCount: article.totalBlocks,
          url: url,
        );
        final response = await get(Uri.parse('$host/$articleId'));
        expect(response.statusCode, equals(HttpStatus.ok));
        expect(response.body, equals(json.encode(expected.toJson())));
      },
      pipeline: () => Pipeline().inject<NewsDataSource>(newsDataSource),
      handler: () => controller.handler,
    );

    testServer(
      'parses limit and offset correctly',
      (host) async {
        const limit = 42;
        const offset = 7;
        final url = Uri.parse('https://dailyglobe.com');
        final article = Article(blocks: const [], totalBlocks: 0, url: url);

        when(
          () => newsDataSource.getArticle(
            id: any(named: 'id'),
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
          ),
        ).thenAnswer((_) async => article);

        final expected = ArticleResponse(
          content: article.blocks,
          totalCount: article.totalBlocks,
          url: url,
        );

        final response = await get(
          Uri.parse('$host/$articleId').replace(
            queryParameters: <String, String>{
              'limit': '$limit',
              'offset': '$offset',
            },
          ),
        );
        expect(response.statusCode, equals(HttpStatus.ok));
        expect(response.body, equals(json.encode(expected.toJson())));
        verify(
          () => newsDataSource.getArticle(
            id: articleId,
            limit: limit,
            offset: offset,
          ),
        ).called(1);
      },
      pipeline: () => Pipeline().inject<NewsDataSource>(newsDataSource),
      handler: () => controller.handler,
    );
  });
}
