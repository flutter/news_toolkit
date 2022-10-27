import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:{{project_name.snakeCase()}}_api/api.dart';
import 'package:{{project_name.snakeCase()}}_api/src/data/in_memory_news_data_source.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../routes/api/v1/search/popular.dart' as route;

class _MockNewsDataSource extends Mock implements NewsDataSource {}

class _MockRequestContext extends Mock implements RequestContext {}

void main() {
  group('GET /api/v1/search/popular', () {
    late NewsDataSource newsDataSource;

    setUp(() {
      newsDataSource = _MockNewsDataSource();
    });

    test('responds with a 200 on success.', () async {
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
      final request = Request('GET', Uri.parse('http://127.0.0.1/'));
      final context = _MockRequestContext();
      when(() => context.request).thenReturn(request);
      when(() => context.read<NewsDataSource>()).thenReturn(newsDataSource);

      final response = await route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.ok));
      expect(response.json(), completion(equals(expected.toJson())));
      verify(() => newsDataSource.getPopularArticles()).called(1);
      verify(() => newsDataSource.getPopularTopics()).called(1);
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
