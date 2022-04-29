// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:io';

import 'package:google_news_template_api/google_news_template_api.dart';
import 'package:google_news_template_api/src/api/v1/feed/feed.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import '../../../../../test_server.dart';

class MockNewsDataSource extends Mock implements NewsDataSource {}

class MockFeed extends Mock implements Feed {}

void main() {
  group('GET /api/v1/feed', () {
    late NewsDataSource newsDataSource;
    late FeedController controller;

    setUp(() {
      newsDataSource = MockNewsDataSource();
      controller = FeedController();
    });

    testServer(
      'returns a 200 on success',
      (host) async {
        final blocks = <NewsBlock>[];
        final feed = MockFeed();
        when(() => feed.blocks).thenReturn(blocks);
        when(() => feed.totalBlocks).thenReturn(blocks.length);
        when(() => newsDataSource.getNewsFeed()).thenAnswer((_) async => feed);

        final expected = FeedResponse(feed: blocks, totalCount: blocks.length);
        final response = await get(host);
        expect(response.statusCode, equals(HttpStatus.ok));
        expect(response.body, equals(json.encode(expected.toJson())));
      },
      pipeline: () => Pipeline().inject<NewsDataSource>(newsDataSource),
      handler: () => controller.handler,
    );
  });
}
