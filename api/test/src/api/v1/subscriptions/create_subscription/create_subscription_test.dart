// ignore_for_file: prefer_const_constructors

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
  group('POST /api/v1/subscriptions', () {
    late NewsDataSource newsDataSource;
    late SubscriptionsController controller;

    setUpAll(() {
      registerFallbackValue(SubscriptionPlan.none);
    });

    setUp(() {
      newsDataSource = MockNewsDataSource();
      controller = SubscriptionsController();
    });

    testServer(
      'returns a 403 on missing authorization header',
      (host) async {
        final response = await post(host);
        expect(response.statusCode, equals(HttpStatus.badRequest));
      },
      handler: () => controller.handler,
    );

    testServer(
      'returns a 403 on non-bearer authorization header',
      (host) async {
        final response = await post(
          host,
          headers: {'authorization': 'invalid'},
        );
        expect(response.statusCode, equals(HttpStatus.badRequest));
      },
      handler: () => controller.handler,
    );

    testServer(
      'returns a 403 on malformed bearer authorization header',
      (host) async {
        final response = await post(
          host,
          headers: {'authorization': 'bearer malformed value'},
        );
        expect(response.statusCode, equals(HttpStatus.badRequest));
      },
      handler: () => controller.handler,
    );

    testServer(
      'returns a 201 on success',
      (host) async {
        const userId = '__userId__';
        when(
          () => newsDataSource.createSubscription(
            userId: any(named: 'userId'),
            subscriptionId: any(named: 'subscriptionId'),
          ),
        ).thenAnswer((_) async {});

        final response = await post(
          host.replace(
            queryParameters: <String, String>{
              'subscriptionId': 'subscriptionId',
            },
          ),
          headers: const {'authorization': 'Bearer $userId'},
        );
        expect(response.statusCode, equals(HttpStatus.created));
        verify(
          () => newsDataSource.createSubscription(
            userId: userId,
            subscriptionId: 'subscriptionId',
          ),
        ).called(1);
      },
      handler: () => controller.handler,
      pipeline: () => const Pipeline().inject<NewsDataSource>(newsDataSource),
    );
  });
}
