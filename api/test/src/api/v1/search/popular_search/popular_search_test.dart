// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:google_news_template_api/src/api/v1/search/search.dart';
import 'package:http/http.dart';
import 'package:test/test.dart';

import '../../../../../test_server.dart';

void main() {
  group('GET /api/v1/search/popular', () {
    late SearchController controller;

    setUp(() {
      controller = SearchController();
    });

    testServer(
      'returns a 501',
      (host) async {
        final response = await get(Uri.parse('$host/popular'));
        expect(response.statusCode, equals(HttpStatus.notImplemented));
      },
      handler: () => controller.handler,
    );
  });
}
