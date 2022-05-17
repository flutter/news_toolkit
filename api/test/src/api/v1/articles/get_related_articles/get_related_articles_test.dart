// ignore_for_file: prefer_const_constructors
import 'dart:io';

import 'package:google_news_template_api/src/api/v1/articles/articles.dart';
import 'package:http/http.dart';
import 'package:test/test.dart';

import '../../../../../test_server.dart';

void main() {
  group('GET /api/v1/articles/<id>/related', () {
    const articleId = '__test_article_id__';
    late ArticlesController controller;

    setUp(() {
      controller = ArticlesController();
    });

    testServer(
      'returns 501 (not implemented)',
      (host) async {
        final response = await get(Uri.parse('$host/$articleId/related'));
        expect(response.statusCode, equals(HttpStatus.notImplemented));
      },
      handler: () => controller.handler,
    );
  });
}
