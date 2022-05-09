// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:google_news_template_api/src/api/v1/newsletter/newsletter.dart';
import 'package:http/http.dart';
import 'package:test/test.dart';

import '../../../../../test_server.dart';

void main() {
  group('POST /api/v1/newsletter/subscription', () {
    late NewsletterController controller;

    setUp(() {
      controller = NewsletterController();
    });

    testServer(
      'returns a 201 on success',
      (host) async {
        final response = await post(Uri.parse('$host/subscription'));
        expect(response.statusCode, equals(HttpStatus.created));
      },
      handler: () => controller.handler,
    );
  });
}
