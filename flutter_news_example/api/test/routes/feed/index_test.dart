import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:flutter_news_template_api/api.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:test/test.dart';

import '../../../routes/api/v1/feed/index.dart' as route;

class _MockFeed extends Mock implements Feed {}

class _MockNewsDataSource extends Mock implements NewsDataSource {}

class _MockRequestContext extends Mock implements RequestContext {}

void main() {
  group('GET /api/v1/feed', () {
    late NewsDataSource newsDataSource;

    setUpAll(() {
      registerFallbackValue(Category.top);
    });

    setUp(() {
      newsDataSource = _MockNewsDataSource();
    });

    test('responds with a 200 on success.', () async {
      final blocks = <NewsBlock>[];
      final feed = _MockFeed();
      when(() => feed.blocks).thenReturn(blocks);
      when(() => feed.totalBlocks).thenReturn(blocks.length);
      when(
        () => newsDataSource.getFeed(
          category: any(named: 'category'),
          limit: any(named: 'limit'),
          offset: any(named: 'offset'),
        ),
      ).thenAnswer((_) async => feed);

      final expected = FeedResponse(feed: blocks, totalCount: blocks.length);
      final request = Request('GET', Uri.parse('http://127.0.0.1/'));
      final context = _MockRequestContext();
      when(() => context.request).thenReturn(request);
      when(() => context.read<NewsDataSource>()).thenReturn(newsDataSource);
      final response = await route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.ok));
      expect(await response.json(), equals(expected.toJson()));
    });

    test('parses category, limit, and offset correctly.', () async {
      const category = Category.entertainment;
      const limit = 42;
      const offset = 7;
      final blocks = <NewsBlock>[];
      final feed = _MockFeed();
      when(() => feed.blocks).thenReturn(blocks);
      when(() => feed.totalBlocks).thenReturn(blocks.length);
      when(
        () => newsDataSource.getFeed(
          category: any(named: 'category'),
          limit: any(named: 'limit'),
          offset: any(named: 'offset'),
        ),
      ).thenAnswer((_) async => feed);

      final expected = FeedResponse(feed: blocks, totalCount: blocks.length);
      final request = Request(
        'GET',
        Uri.parse('http://127.0.0.1/').replace(
          queryParameters: <String, String>{
            'category': category.name,
            'limit': '$limit',
            'offset': '$offset',
          },
        ),
      );
      final context = _MockRequestContext();
      when(() => context.request).thenReturn(request);
      when(() => context.read<NewsDataSource>()).thenReturn(newsDataSource);
      final response = await route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.ok));
      expect(await response.json(), equals(expected.toJson()));
      verify(
        () => newsDataSource.getFeed(
          category: category,
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
    final response = await route.onRequest(context);
    expect(response.statusCode, equals(HttpStatus.methodNotAllowed));
  });
}
