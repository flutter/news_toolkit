import 'package:dart_frog/dart_frog.dart';
import 'package:google_news_template_api/api.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockRequestContext extends Mock implements RequestContext {}

void main() {
  group('userProvider', () {
    test(
        'provides RequestUser.anonymous '
        'when authorization header is missing.', () async {
      RequestUser? value;
      final handler = userProvider()(
        (context) {
          value = context.read<RequestUser>();
          return Response(body: '');
        },
      );
      final request = Request.get(Uri.parse('http://localhost/'));
      final context = _MockRequestContext();
      when(() => context.request).thenReturn(request);
      await handler(context);
      expect(value, equals(RequestUser.anonymous));
    });

    test(
        'provides RequestUser.anonymous '
        'when authorization header is malformed (no bearer).', () async {
      RequestUser? value;
      final handler = userProvider()(
        (context) {
          value = context.read<RequestUser>();
          return Response(body: '');
        },
      );
      final request = Request.get(
        Uri.parse('http://localhost/'),
        headers: {'Authorization': 'some token'},
      );
      final context = _MockRequestContext();
      when(() => context.request).thenReturn(request);
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
        (context) {
          value = context.read<RequestUser>();
          return Response(body: '');
        },
      );
      final request = Request.get(
        Uri.parse('http://localhost/'),
        headers: {'Authorization': 'bearer some token'},
      );
      final context = _MockRequestContext();
      when(() => context.request).thenReturn(request);
      await handler(context);
      expect(value, equals(RequestUser.anonymous));
      expect(value!.isAnonymous, isTrue);
    });

    test(
        'provides correct RequestUser '
        'when authorization header is valid.', () async {
      const userId = '__user_id__';
      RequestUser? value;
      final handler = userProvider()(
        (context) {
          value = context.read<RequestUser>();
          return Response(body: '');
        },
      );
      final request = Request.get(
        Uri.parse('http://localhost/'),
        headers: {'Authorization': 'Bearer $userId'},
      );
      final context = _MockRequestContext();
      when(() => context.request).thenReturn(request);
      await handler(context);
      expect(value, isA<RequestUser>().having((r) => r.id, 'id', userId));
    });
  });
}
