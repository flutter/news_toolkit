// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:io';

import 'package:google_news_template_api/api.dart';
import 'package:google_news_template_api/src/api/v1/subscriptions/subscriptions.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import '../../../../../test_server.dart';

class MockNewsDataSource extends Mock implements NewsDataSource {}

void main() {
  group('GET /api/v1/subscriptions', () {
    late NewsDataSource newsDataSource;
    late SubscriptionsController controller;

    setUp(() {
      newsDataSource = MockNewsDataSource();
      controller = SubscriptionsController();
    });

    testServer(
      'returns a 200 on success',
      (host) async {
        when(
          () => newsDataSource.getSubscriptions(),
        ).thenAnswer((_) async => []);

        final expected = SubscriptionsResponse(subscriptions: const []);
        final response = await get(host);
        expect(response.statusCode, equals(HttpStatus.ok));
        expect(response.body, equals(json.encode(expected.toJson())));
        verify(() => newsDataSource.getSubscriptions()).called(1);
      },
      pipeline: () => Pipeline().inject<NewsDataSource>(newsDataSource),
      handler: () => controller.handler,
    );
  });
}
