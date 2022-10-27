import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:google_news_template_api/api.dart';
import 'package:google_news_template_api/src/data/in_memory_news_data_source.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../routes/api/v1/search/relevant.dart' as route;

class _MockNewsDataSource extends Mock implements NewsDataSource {}

class _MockRequestContext extends Mock implements RequestContext {}

void main() {
  group('GET /api/v1/search/relevant', () {
    late NewsDataSource newsDataSource;

    setUp(() {
      newsDataSource = _MockNewsDataSource();
    });

    test('responds with a 400 when query parameter is missing.', () async {
      final request = Request('GET', Uri.parse('http://127.0.0.1/'));
      final context = _MockRequestContext();
      when(() => context.request).thenReturn(request);
      when(() => context.read<NewsDataSource>()).thenReturn(newsDataSource);

      final response = await route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.badRequest));
    });

    test('responds with a 200 on success.', () async {
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
      final request = Request(
        'GET',
        Uri.parse('http://127.0.0.1/').replace(
          queryParameters: <String, String>{'q': term},
        ),
      );
      final context = _MockRequestContext();
      when(() => context.request).thenReturn(request);
      when(() => context.read<NewsDataSource>()).thenReturn(newsDataSource);

      final response = await route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.ok));
      expect(response.json(), completion(equals(expected.toJson())));
      verify(() => newsDataSource.getRelevantArticles(term: term)).called(1);
      verify(() => newsDataSource.getRelevantTopics(term: term)).called(1);
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
