import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:{{project_name.snakeCase()}}_api/api.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../routes/api/v1/categories/index.dart' as route;

class _MockNewsDataSource extends Mock implements NewsDataSource {}

class _MockRequestContext extends Mock implements RequestContext {}

void main() {
  group('GET /api/v1/categories', () {
    late NewsDataSource newsDataSource;

    setUp(() {
      newsDataSource = _MockNewsDataSource();
    });

    test('responds with a 200 and categories.', () async {
      const categories = [Category.sports, Category.entertainment];
      when(
        () => newsDataSource.getCategories(),
      ).thenAnswer((_) async => categories);
      const expected = CategoriesResponse(categories: categories);
      final request = Request('GET', Uri.parse('http://127.0.0.1/'));
      final context = _MockRequestContext();
      when(() => context.request).thenReturn(request);
      when(() => context.read<NewsDataSource>()).thenReturn(newsDataSource);
      final response = await route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.ok));
      expect(await response.json(), equals(expected.toJson()));
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
