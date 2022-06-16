// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:io';

import 'package:google_news_template_api/api.dart';
import 'package:google_news_template_api/src/api/v1/users/users.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import '../../../../../test_server.dart';

class MockNewsDataSource extends Mock implements NewsDataSource {}

void main() {
  group('GET /api/v1/users/me', () {
    late NewsDataSource newsDataSource;
    late UsersController controller;

    setUp(() {
      newsDataSource = MockNewsDataSource();
      controller = UsersController();
    });

    testServer(
      'returns a 400 when authorization header is missing',
      (host) async {
        when(
          () => newsDataSource.getUser(userId: any(named: 'userId')),
        ).thenAnswer((_) async => null);
        final response = await get(Uri.parse('$host/me'));
        expect(response.statusCode, equals(HttpStatus.badRequest));
      },
      pipeline: () => Pipeline().inject<NewsDataSource>(newsDataSource),
      handler: () => controller.handler,
    );

    testServer(
      'returns a 400 when authorization header is malformed',
      (host) async {
        when(
          () => newsDataSource.getUser(userId: any(named: 'userId')),
        ).thenAnswer((_) async => null);
        final response = await get(
          Uri.parse('$host/me'),
          headers: {'authorization': 'malformed'},
        );
        expect(response.statusCode, equals(HttpStatus.badRequest));
      },
      pipeline: () => Pipeline().inject<NewsDataSource>(newsDataSource),
      handler: () => controller.handler,
    );

    testServer(
      'returns a 404 when user is not found',
      (host) async {
        when(
          () => newsDataSource.getUser(userId: any(named: 'userId')),
        ).thenAnswer((_) async => null);
        final response = await get(
          Uri.parse('$host/me'),
          headers: {'authorization': 'bearer token'},
        );
        expect(response.statusCode, equals(HttpStatus.notFound));
        expect(response.body, equals('{}'));
      },
      pipeline: () => Pipeline().inject<NewsDataSource>(newsDataSource),
      handler: () => controller.handler,
    );

    testServer(
      'returns a 200 when user is found',
      (host) async {
        final user = User(id: 'id', subscription: SubscriptionPlan.basic);
        when(
          () => newsDataSource.getUser(userId: any(named: 'userId')),
        ).thenAnswer((_) async => user);
        final expected = CurrentUserResponse(user: user);
        final response = await get(
          Uri.parse('$host/me'),
          headers: {'authorization': 'bearer token'},
        );
        expect(response.statusCode, equals(HttpStatus.ok));
        expect(response.body, equals(json.encode(expected.toJson())));
      },
      pipeline: () => Pipeline().inject<NewsDataSource>(newsDataSource),
      handler: () => controller.handler,
    );
  });
}
