import 'package:dart_frog/dart_frog.dart';
import 'package:{{project_name.snakeCase()}}_api/api.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'test_request_context.dart';

class _MockRequestUser extends Mock implements RequestUser {}

void main() {
  group('userProvider', () {
    test(
        'provides RequestUser.anonymous '
        'when authorization header is missing.', () async {
      final context = TestRequestContext(
        path: 'http://localhost/',
      );

      RequestUser? value;
      final handler = userProvider()(
        (_) {
          value = context.read<RequestUser>();
          return Response(body: '');
        },
      );

      context.mockProvide<RequestUser>(RequestUser.anonymous);

      await handler(context);
      expect(value, equals(RequestUser.anonymous));
    });

    test(
        'provides RequestUser.anonymous '
        'when authorization header is malformed (no bearer).', () async {
      final context = TestRequestContext(
        path: 'http://localhost/',
        headers: {'Authorization': 'some token'},
      );
      RequestUser? value;
      final handler = userProvider()(
        (_) {
          value = context.read<RequestUser>();
          return Response(body: '');
        },
      );

      context.mockProvide<RequestUser>(RequestUser.anonymous);

      await handler(context);

      expect(value, equals(RequestUser.anonymous));
      expect(value!.isAnonymous, isTrue);
    });

    test(
        'provides RequestUser.anonymous '
        'when authorization header is malformed (too many segments).',
        () async {
      final context = TestRequestContext(
        path: 'http://localhost/',
        headers: {'Authorization': 'bearer some token'},
      );

      RequestUser? value;
      final handler = userProvider()(
        (_) {
          value = context.read<RequestUser>();
          return Response(body: '');
        },
      );

      context.mockProvide<RequestUser>(RequestUser.anonymous);

      await handler(context);

      expect(value, equals(RequestUser.anonymous));
      expect(value!.isAnonymous, isTrue);
    });

    test(
        'provides correct RequestUser '
        'when authorization header is valid.', () async {
      const userId = '__user_id__';

      final context = TestRequestContext(
        path: 'http://localhost/',
        headers: {'Authorization': 'Bearer $userId'},
      );
      final requestUser = _MockRequestUser();
      when(() => requestUser.id).thenReturn(userId);

      context.mockProvide<RequestUser>(requestUser);

      RequestUser? value;
      final handler = userProvider()(
        (_) {
          value = context.read<RequestUser>();
          return Response(body: '');
        },
      );

      await handler(context);

      await expectLater(
        value,
        isA<RequestUser>().having((r) => r.id, 'id', userId),
      );
    });
  });
}
