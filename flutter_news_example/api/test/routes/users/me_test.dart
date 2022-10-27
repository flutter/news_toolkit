// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:google_news_template_api/api.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../routes/api/v1/users/me.dart' as route;

class _MockRequestContext extends Mock implements RequestContext {}

class _MockNewsDataSource extends Mock implements NewsDataSource {}

class _MockRequestUser extends Mock implements RequestUser {}

void main() {
  late NewsDataSource newsDataSource;

  setUp(() {
    newsDataSource = _MockNewsDataSource();
  });

  group('GET /api/v1/users/me', () {
    test('responds with a 400 when user is anonymous.', () async {
      final request = Request('GET', Uri.parse('http://127.0.0.1/'));
      final context = _MockRequestContext();
      when(() => context.request).thenReturn(request);
      when(() => context.read<RequestUser>()).thenReturn(RequestUser.anonymous);
      final response = await route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.badRequest));
    });

    test('responds with a 404 when user is not found.', () async {
      const userId = '__userId__';
      final request = Request('GET', Uri.parse('http://127.0.0.1/'));
      final user = _MockRequestUser();
      when(() => user.id).thenReturn(userId);
      when(() => user.isAnonymous).thenReturn(false);
      final context = _MockRequestContext();
      when(() => context.request).thenReturn(request);
      when(() => context.read<NewsDataSource>()).thenReturn(newsDataSource);
      when(() => context.read<RequestUser>()).thenReturn(user);
      when(
        () => newsDataSource.getUser(userId: any(named: 'userId')),
      ).thenAnswer((_) async => null);

      final response = await route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.notFound));
      verify(() => newsDataSource.getUser(userId: userId)).called(1);
    });

    test('responds with a 200 when user is found.', () async {
      const userId = '__userId__';
      final user = User(id: 'id', subscription: SubscriptionPlan.basic);
      final request = Request('GET', Uri.parse('http://127.0.0.1/'));
      final requestUser = _MockRequestUser();
      when(() => requestUser.id).thenReturn(userId);
      when(() => requestUser.isAnonymous).thenReturn(false);
      final context = _MockRequestContext();
      when(() => context.request).thenReturn(request);
      when(() => context.read<NewsDataSource>()).thenReturn(newsDataSource);
      when(() => context.read<RequestUser>()).thenReturn(requestUser);
      when(
        () => newsDataSource.getUser(userId: any(named: 'userId')),
      ).thenAnswer((_) async => user);
      final expected = CurrentUserResponse(user: user);

      final response = await route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.ok));
      expect(response.json(), completion(equals(expected.toJson())));
      verify(() => newsDataSource.getUser(userId: userId)).called(1);
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
