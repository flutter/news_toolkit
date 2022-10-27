import 'package:dart_frog/dart_frog.dart';
import 'package:{{project_name.snakeCase()}}_api/api.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockRequestContext extends Mock implements RequestContext {}

void main() {
  group('newsDataSourceProvider', () {
    test('provides a NewsDataSource instance', () async {
      NewsDataSource? value;
      final handler = newsDataSourceProvider()(
        (context) {
          value = context.read<NewsDataSource>();
          return Response(body: '');
        },
      );
      final request = Request.get(Uri.parse('http://localhost/'));
      final context = _MockRequestContext();
      when(() => context.request).thenReturn(request);
      await handler(context);
      expect(value, isNotNull);
    });
  });
}
