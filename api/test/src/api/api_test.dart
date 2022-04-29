// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:google_news_template_api/google_news_template_api.dart';
import 'package:http/http.dart';
import 'package:test/test.dart';

import '../../test_server.dart';

void main() {
  group('ApiController', () {
    late ApiController controller;

    setUp(() {
      controller = ApiController();
    });

    group('GET /', () {
      testServer(
        'returns 204',
        (host) async {
          final response = await get(host);
          expect(response.statusCode, equals(HttpStatus.noContent));
          expect(response.body, isEmpty);
        },
        handler: () => controller.handler,
      );
    });
  });
}
