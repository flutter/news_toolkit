import 'package:dart_frog/dart_frog.dart';
import 'package:flutter_news_example_api/api.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../routes/_middleware.dart';

class _MockRequestContext extends Mock implements RequestContext {}

void main() {
  group('middleware', () {
    test('provides NewsDataSource instance.', () async {
      final context = _MockRequestContext();

      final handler = middleware(
        (_) {
          expect(context.read<NewsDataSource>(), isNotNull);
          return Response();
        },
      );
      final request = Request('GET', Uri.parse('http://127.0.0.1/'));

      when(() => context.request).thenReturn(request);

      when(() => context.read<NewsDataSource>())
          .thenReturn(InMemoryNewsDataSource());

      when(() => context.provide<NewsDataSource>(any())).thenReturn(context);
      when(() => context.provide<RequestUser>(any())).thenReturn(context);
      await handler(context);
    });
  });
}
