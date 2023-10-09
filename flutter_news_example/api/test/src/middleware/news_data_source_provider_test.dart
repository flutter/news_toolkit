import 'package:dart_frog/dart_frog.dart';
import 'package:flutter_news_example_api/api.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockRequestContext extends Mock implements RequestContext {}

void main() {
  group('newsDataSourceProvider', () {
    test('provides a NewsDataSource instance', () async {
      NewsDataSource? value;
      final context = _MockRequestContext();
      final handler = newsDataSourceProvider()(
        (_) {
          value = context.read<NewsDataSource>();
          return Response(body: '');
        },
      );
      final request = Request.get(Uri.parse('http://localhost/'));
      when(() => context.request).thenReturn(request);

      when(() => context.read<NewsDataSource>())
          .thenReturn(InMemoryNewsDataSource());

      when(() => context.provide<NewsDataSource>(any())).thenReturn(context);
      when(() => context.provide<RequestUser>(any())).thenReturn(context);

      await handler(context);
      expect(value, isNotNull);
    });
  });
}
