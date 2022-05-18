// ignore_for_file: prefer_const_constructors
import 'dart:convert';
import 'dart:io';

import 'package:google_news_template_api/api.dart';
import 'package:google_news_template_api/src/api/v1/articles/articles.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import '../../../../../test_server.dart';

class MockNewsDataSource extends Mock implements NewsDataSource {}

class MockRelatedArticles extends Mock implements RelatedArticles {}

void main() {
  group('GET /api/v1/articles/<id>/related', () {
    const articleId = '__test_article_id__';
    late ArticlesController controller;
    late NewsDataSource newsDataSource;

    setUp(() {
      controller = ArticlesController();
      newsDataSource = MockNewsDataSource();
    });

    testServer(
      'returns a 200 on success',
      (host) async {
        final blocks = <NewsBlock>[];
        final relatedArticles = MockRelatedArticles();
        when(() => relatedArticles.blocks).thenReturn(blocks);
        when(() => relatedArticles.totalBlocks).thenReturn(blocks.length);
        when(
          () => newsDataSource.getRelatedArticles(
            id: any(named: 'id'),
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
          ),
        ).thenAnswer((_) async => relatedArticles);

        final expected = RelatedArticlesResponse(
          relatedArticles: blocks,
          totalCount: blocks.length,
        );
        final response = await get(Uri.parse('$host/$articleId/related'));
        expect(response.statusCode, equals(HttpStatus.ok));
        expect(response.body, equals(json.encode(expected.toJson())));
        verify(
          () => newsDataSource.getRelatedArticles(id: articleId),
        ).called(1);
      },
      pipeline: () => Pipeline().inject<NewsDataSource>(newsDataSource),
      handler: () => controller.handler,
    );

    testServer(
      'parses limit and offset correctly',
      (host) async {
        const limit = 42;
        const offset = 7;
        final blocks = <NewsBlock>[];
        final relatedArticles = MockRelatedArticles();
        when(() => relatedArticles.blocks).thenReturn(blocks);
        when(() => relatedArticles.totalBlocks).thenReturn(blocks.length);
        when(
          () => newsDataSource.getRelatedArticles(
            id: any(named: 'id'),
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
          ),
        ).thenAnswer((_) async => relatedArticles);

        final expected = RelatedArticlesResponse(
          relatedArticles: blocks,
          totalCount: blocks.length,
        );
        final response = await get(
          Uri.parse('$host/$articleId/related').replace(
            queryParameters: <String, String>{
              'limit': '$limit',
              'offset': '$offset',
            },
          ),
        );
        expect(response.statusCode, equals(HttpStatus.ok));
        expect(response.body, equals(json.encode(expected.toJson())));
        verify(
          () => newsDataSource.getRelatedArticles(
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
