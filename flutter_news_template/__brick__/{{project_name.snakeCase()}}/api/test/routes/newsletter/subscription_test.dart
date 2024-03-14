import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../routes/api/v1/newsletter/subscription.dart' as route;

class _MockRequestContext extends Mock implements RequestContext {}

void main() {
  group('POST /api/v1/newsletter/subscription', () {
    test('responds with a 201.', () {
      final request = Request('POST', Uri.parse('http://127.0.0.1/'));
      final context = _MockRequestContext();
      when(() => context.request).thenReturn(request);
      final response = route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.created));
    });
  });

  test('responds with 405 when method is not POST.', () {
    final request = Request('GET', Uri.parse('http://127.0.0.1/'));
    final context = _MockRequestContext();
    when(() => context.request).thenReturn(request);
    final response = route.onRequest(context);
    expect(response.statusCode, equals(HttpStatus.methodNotAllowed));
  });
}
