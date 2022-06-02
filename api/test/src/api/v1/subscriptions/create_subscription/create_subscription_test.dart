// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:google_news_template_api/src/api/v1/subscriptions/subscriptions.dart';
import 'package:http/http.dart';
import 'package:test/test.dart';

import '../../../../../test_server.dart';

void main() {
  group('POST /api/v1/subscriptions', () {
    late SubscriptionsController controller;

    setUp(() {
      controller = SubscriptionsController();
    });

    testServer(
      'returns a 201 on success',
      (host) async {
        final response = await post(host);
        expect(response.statusCode, equals(HttpStatus.created));
      },
      handler: () => controller.handler,
    );
  });
}
