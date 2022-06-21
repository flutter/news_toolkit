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
          () => newsDataSource.isPremiumArticle(id: articleId),
        ).thenAnswer((_) async => null);
        final response = await get(Uri.parse('$host/$articleId'));
        expect(response.statusCode, equals(HttpStatus.notFound));
      },
      pipeline: () => Pipeline().inject<NewsDataSource>(newsDataSource),
      handler: () => controller.handler,
    );

    testServer(
      'returns a 404 when article is premium but not found',
      (host) async {
        when(
          () => newsDataSource.isPremiumArticle(id: articleId),
        ).thenAnswer((_) async => true);
        when(
          () => newsDataSource.getArticle(
            id: articleId,
            preview: any(named: 'preview'),
          ),
        ).thenAnswer((_) async => null);
        final response = await get(Uri.parse('$host/$articleId'));
        expect(response.statusCode, equals(HttpStatus.notFound));
      },
      pipeline: () => Pipeline().inject<NewsDataSource>(newsDataSource),
      handler: () => controller.handler,
    );

    testServer(
      'returns a 200 on success '
      'with full article content '
      'when the article is not premium',
      (host) async {
        final url = Uri.parse('https://dailyglobe.com');
        final article =
            Article(title: 'title', blocks: const [], totalBlocks: 0, url: url);
        when(
          () => newsDataSource.getArticle(
            id: articleId,
            preview: any(named: 'preview'),
          ),
        ).thenAnswer((_) async => article);
        when(
          () => newsDataSource.isPremiumArticle(id: articleId),
        ).thenAnswer((_) async => false);
        final expected = ArticleResponse(
          title: article.title,
          content: article.blocks,
          totalCount: article.totalBlocks,
          url: url,
          isPremium: false,
          isPreview: false,
        );
        final response = await get(Uri.parse('$host/$articleId'));
        expect(response.statusCode, equals(HttpStatus.ok));
        expect(response.body, equals(json.encode(expected.toJson())));
      },
      pipeline: () => Pipeline().inject<NewsDataSource>(newsDataSource),
      handler: () => controller.handler,
    );

    testServer(
      'returns a 200 on success '
      'with preview article content '
      'when the article is premium '
      'and authorization header is missing',
      (host) async {
        final url = Uri.parse('https://dailyglobe.com');
        final article =
            Article(title: 'title', blocks: const [], totalBlocks: 0, url: url);
        when(
          () => newsDataSource.getArticle(
            id: articleId,
            preview: any(named: 'preview'),
          ),
        ).thenAnswer((_) async => article);
        when(
          () => newsDataSource.isPremiumArticle(id: articleId),
        ).thenAnswer((_) async => true);
        final expected = ArticleResponse(
          title: article.title,
          content: article.blocks,
          totalCount: article.totalBlocks,
          url: url,
          isPremium: true,
          isPreview: true,
        );
        final response = await get(Uri.parse('$host/$articleId'));
        expect(response.statusCode, equals(HttpStatus.ok));
        expect(response.body, equals(json.encode(expected.toJson())));
      },
      pipeline: () => Pipeline().inject<NewsDataSource>(newsDataSource),
      handler: () => controller.handler,
    );

    testServer(
      'returns a 200 on success '
      'with preview article content '
      'when the article is premium '
      'and authorization header is malformed',
      (host) async {
        final url = Uri.parse('https://dailyglobe.com');
        final article =
            Article(title: 'title', blocks: const [], totalBlocks: 0, url: url);
        when(
          () => newsDataSource.getArticle(
            id: articleId,
            preview: any(named: 'preview'),
          ),
        ).thenAnswer((_) async => article);
        when(
          () => newsDataSource.isPremiumArticle(id: articleId),
        ).thenAnswer((_) async => true);
        final expected = ArticleResponse(
          title: article.title,
          content: article.blocks,
          totalCount: article.totalBlocks,
          url: url,
          isPremium: true,
          isPreview: true,
        );
        final response = await get(
          Uri.parse(
            '$host/$articleId',
          ),
          headers: {'authorization': 'malformed'},
        );
        expect(response.statusCode, equals(HttpStatus.ok));
        expect(response.body, equals(json.encode(expected.toJson())));
      },
      pipeline: () => Pipeline().inject<NewsDataSource>(newsDataSource),
      handler: () => controller.handler,
    );

    testServer(
      'returns a 200 on success '
      'with preview article content '
      'when the article is premium '
      'and user is not found',
      (host) async {
        final url = Uri.parse('https://dailyglobe.com');
        final article =
            Article(title: 'title', blocks: const [], totalBlocks: 0, url: url);
        when(
          () => newsDataSource.getArticle(
            id: articleId,
            preview: any(named: 'preview'),
          ),
        ).thenAnswer((_) async => article);
        when(
          () => newsDataSource.isPremiumArticle(id: articleId),
        ).thenAnswer((_) async => true);
        when(
          () => newsDataSource.getUser(userId: any(named: 'userId')),
        ).thenAnswer((_) async => null);
        final expected = ArticleResponse(
          title: article.title,
          content: article.blocks,
          totalCount: article.totalBlocks,
          url: url,
          isPremium: true,
          isPreview: true,
        );
        final response = await get(
          Uri.parse(
            '$host/$articleId',
          ),
          headers: {'authorization': 'bearer token'},
        );
        expect(response.statusCode, equals(HttpStatus.ok));
        expect(response.body, equals(json.encode(expected.toJson())));
      },
      pipeline: () => Pipeline().inject<NewsDataSource>(newsDataSource),
      handler: () => controller.handler,
    );

    testServer(
      'returns a 200 on success '
      'with preview article content '
      'when the article is premium '
      'and user is found and has no subscription',
      (host) async {
        final url = Uri.parse('https://dailyglobe.com');
        final article =
            Article(title: 'title', blocks: const [], totalBlocks: 0, url: url);
        when(
          () => newsDataSource.getArticle(
            id: articleId,
            preview: any(named: 'preview'),
          ),
        ).thenAnswer((_) async => article);
        when(
          () => newsDataSource.isPremiumArticle(id: articleId),
        ).thenAnswer((_) async => true);
        when(
          () => newsDataSource.getUser(userId: any(named: 'userId')),
        ).thenAnswer(
          (_) async => User(
            id: '__user_id__',
            subscription: SubscriptionPlan.none,
          ),
        );
        final expected = ArticleResponse(
          title: article.title,
          content: article.blocks,
          totalCount: article.totalBlocks,
          url: url,
          isPremium: true,
          isPreview: true,
        );
        final response = await get(
          Uri.parse(
            '$host/$articleId',
          ),
          headers: {'authorization': 'bearer token'},
        );
        expect(response.statusCode, equals(HttpStatus.ok));
        expect(response.body, equals(json.encode(expected.toJson())));
      },
      pipeline: () => Pipeline().inject<NewsDataSource>(newsDataSource),
      handler: () => controller.handler,
    );

    testServer(
      'returns a 200 on success '
      'with full article content '
      'when the article is premium '
      'and user is found and has subscription',
      (host) async {
        final url = Uri.parse('https://dailyglobe.com');
        final article =
            Article(title: 'title', blocks: const [], totalBlocks: 0, url: url);
        when(
          () => newsDataSource.getArticle(
            id: articleId,
            preview: any(named: 'preview'),
          ),
        ).thenAnswer((_) async => article);
        when(
          () => newsDataSource.isPremiumArticle(id: articleId),
        ).thenAnswer((_) async => true);
        when(
          () => newsDataSource.getUser(userId: any(named: 'userId')),
        ).thenAnswer(
          (_) async => User(
            id: '__user_id__',
            subscription: SubscriptionPlan.premium,
          ),
        );
        final expected = ArticleResponse(
          title: article.title,
          content: article.blocks,
          totalCount: article.totalBlocks,
          url: url,
          isPremium: true,
          isPreview: false,
        );
        final response = await get(
          Uri.parse(
            '$host/$articleId',
          ),
          headers: {'authorization': 'bearer token'},
        );
        expect(response.statusCode, equals(HttpStatus.ok));
        expect(response.body, equals(json.encode(expected.toJson())));
      },
      pipeline: () => Pipeline().inject<NewsDataSource>(newsDataSource),
      handler: () => controller.handler,
    );

    testServer(
      'parses limit, offset and preview correctly',
      (host) async {
        const limit = 42;
        const offset = 7;
        const preview = true;
        final url = Uri.parse('https://dailyglobe.com');
        final article =
            Article(title: 'title', blocks: const [], totalBlocks: 0, url: url);

        when(
          () => newsDataSource.getArticle(
            id: any(named: 'id'),
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
            preview: any(named: 'preview'),
          ),
        ).thenAnswer((_) async => article);

        when(
          () => newsDataSource.isPremiumArticle(id: articleId),
        ).thenAnswer((_) async => false);

        final expected = ArticleResponse(
          title: article.title,
          content: article.blocks,
          totalCount: article.totalBlocks,
          url: url,
          isPremium: false,
          isPreview: preview,
        );

        final response = await get(
          Uri.parse('$host/$articleId').replace(
            queryParameters: <String, String>{
              'limit': '$limit',
              'offset': '$offset',
              'preview': '$preview',
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
            preview: preview,
          ),
        ).called(1);
      },
      pipeline: () => Pipeline().inject<NewsDataSource>(newsDataSource),
      handler: () => controller.handler,
    );
  });
}
