import 'package:dart_frog/dart_frog.dart';
import 'package:flutter_news_example_api/api.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockRequestContext extends Mock implements RequestContext {}

class _MockRequestUser extends Mock implements RequestUser {}

void main() {
  group('userProvider', () {
    late RequestContext context;

    setUp(() {
      context = _MockRequestContext();

      when(() => context.provide<NewsDataSource>(any())).thenReturn(context);
      when(() => context.provide<RequestUser>(any())).thenReturn(context);
    });

    test(
        'provides RequestUser.anonymous '
        'when authorization header is missing.', () async {
      RequestUser? value;
      final handler = userProvider()(
        (_) {
          value = context.read<RequestUser>();
          return Response(body: '');
        },
      );

      final request = Request.get(Uri.parse('http://localhost/'));

      when(() => context.request).thenReturn(request);
      when(() => context.read<RequestUser>()).thenReturn(RequestUser.anonymous);

      await handler(context);
      expect(value, equals(RequestUser.anonymous));
    });

    test(
        'provides RequestUser.anonymous '
        'when authorization header is malformed (no bearer).', () async {
      RequestUser? value;
      final handler = userProvider()(
        (_) {
          value = context.read<RequestUser>();
          return Response(body: '');
        },
      );
      final request = Request.get(
        Uri.parse('http://localhost/'),
        headers: {'Authorization': 'some token'},
      );

      when(() => context.request).thenReturn(request);
      when(() => context.read<RequestUser>()).thenReturn(RequestUser.anonymous);

      await handler(context);

      expect(value, equals(RequestUser.anonymous));
      expect(value!.isAnonymous, isTrue);
    });

    test(
        'provides RequestUser.anonymous '
        'when authorization header is malformed (too many segments).',
        () async {
      RequestUser? value;
      final handler = userProvider()(
        (_) {
          value = context.read<RequestUser>();
          return Response(body: '');
        },
      );
      final request = Request.get(
        Uri.parse('http://localhost/'),
        headers: {'Authorization': 'bearer some token'},
      );
      when(() => context.request).thenReturn(request);
      when(() => context.read<RequestUser>()).thenReturn(RequestUser.anonymous);

      await handler(context);

      expect(value, equals(RequestUser.anonymous));
      expect(value!.isAnonymous, isTrue);
    });

    test(
        'provides correct RequestUser '
        'when authorization header is valid.', () async {
      const userId = '__user_id__';
      final requestUser = _MockRequestUser();
      when(() => requestUser.id).thenReturn(userId);
      RequestUser? value;
      final handler = userProvider()(
        (_) {
          value = context.read<RequestUser>();
          return Response(body: '');
        },
      );
      final request = Request.get(
        Uri.parse('http://localhost/'),
        headers: {'Authorization': 'Bearer $userId'},
      );

      when(() => context.request).thenReturn(request);
      when(() => context.read<RequestUser>()).thenReturn(requestUser);

      await handler(context);

      expect(value, isA<RequestUser>().having((r) => r.id, 'id', userId));
    });
  });
}
