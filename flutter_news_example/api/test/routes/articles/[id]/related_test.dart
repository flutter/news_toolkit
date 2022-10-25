import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:flutter_news_template_api/api.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:test/test.dart';

import '../../../../routes/api/v1/articles/[id]/related.dart' as route;

class _MockNewsDataSource extends Mock implements NewsDataSource {}

class _MockRequestContext extends Mock implements RequestContext {}

class _MockRelatedArticles extends Mock implements RelatedArticles {}

void main() {
  const id = '__test_article_id__';
  group('GET /api/v1/articles/<id>/related', () {
    late NewsDataSource newsDataSource;

    setUp(() {
      newsDataSource = _MockNewsDataSource();
    });

    test('returns a 200 on success', () async {
      final blocks = <NewsBlock>[];
      final relatedArticles = _MockRelatedArticles();
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

      final request = Request('GET', Uri.parse('http://127.0.0.1/'));
      final context = _MockRequestContext();
      when(() => context.request).thenReturn(request);
      when(() => context.read<NewsDataSource>()).thenReturn(newsDataSource);
      final response = await route.onRequest(context, id);
      expect(response.statusCode, equals(HttpStatus.ok));
      expect(await response.json(), equals(expected.toJson()));
    });

    test('parses limit and offset correctly', () async {
      const limit = 42;
      const offset = 7;
      final blocks = <NewsBlock>[];
      final relatedArticles = _MockRelatedArticles();
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

      final request = Request(
        'GET',
        Uri.parse('http://127.0.0.1/').replace(
          queryParameters: <String, String>{
            'limit': '$limit',
            'offset': '$offset',
          },
        ),
      );
      final context = _MockRequestContext();
      when(() => context.request).thenReturn(request);
      when(() => context.read<NewsDataSource>()).thenReturn(newsDataSource);

      final response = await route.onRequest(context, id);
      expect(response.statusCode, equals(HttpStatus.ok));
      expect(await response.json(), equals(expected.toJson()));
      verify(
        () => newsDataSource.getRelatedArticles(
          id: id,
          limit: limit,
          offset: offset,
        ),
      ).called(1);
    });
  });

  test('responds with 405 when method is not GET.', () async {
    final request = Request('POST', Uri.parse('http://127.0.0.1/'));
    final context = _MockRequestContext();
    when(() => context.request).thenReturn(request);
    final response = await route.onRequest(context, id);
    expect(response.statusCode, equals(HttpStatus.methodNotAllowed));
  });
}
