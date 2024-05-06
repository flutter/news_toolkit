import 'package:dart_frog/dart_frog.dart';
import 'package:flutter_news_example_api/api.dart';
import 'package:test/test.dart';

import 'test_request_context.dart';

void main() {
  group('newsDataSourceProvider', () {
    test('provides a NewsDataSource instance', () async {
      NewsDataSource? value;
      final context = TestRequestContext(
        path: 'http://localhost/',
      );

      final handler = newsDataSourceProvider()(
        (_) {
          value = context.read<NewsDataSource>();
          return Response(body: '');
        },
      );

      context.mockProvide<NewsDataSource>(InMemoryNewsDataSource());

      await handler(context);
      expect(value, isNotNull);
    });
  });
}
