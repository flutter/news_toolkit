// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:io';

import 'package:google_news_template_api/api.dart';
import 'package:google_news_template_api/src/api/v1/categories/categories.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import '../../../../../test_server.dart';

class MockNewsDataSource extends Mock implements NewsDataSource {}

void main() {
  group('GET /api/v1/categories', () {
    late NewsDataSource newsDataSource;
    late CategoriesController controller;

    setUp(() {
      newsDataSource = MockNewsDataSource();
      controller = CategoriesController();
    });

    testServer(
      'returns a 200 on success',
      (host) async {
        const categories = [Category.sports, Category.entertainment];
        when(
          () => newsDataSource.getCategories(),
        ).thenAnswer((_) async => categories);
        final expected = CategoriesResponse(categories: categories);
        final response = await get(host);
        expect(response.statusCode, equals(HttpStatus.ok));
        expect(response.body, equals(json.encode(expected.toJson())));
      },
      pipeline: () => Pipeline().inject<NewsDataSource>(newsDataSource),
      handler: () => controller.handler,
    );
  });
}
