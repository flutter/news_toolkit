import 'dart:convert';
import 'dart:io';

import 'package:google_news_template_api/client.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  group('GoogleNewsTemplateApiClient', () {
    late http.Client httpClient;
    late GoogleNewsTemplateApiClient apiClient;

    setUpAll(() {
      registerFallbackValue(Uri());
    });

    setUp(() {
      httpClient = MockHttpClient();
      apiClient = GoogleNewsTemplateApiClient(httpClient: httpClient);
    });

    group('localhost constructor', () {
      test('can be instantiated (no params)', () {
        expect(GoogleNewsTemplateApiClient.localhost, returnsNormally);
      });

      test('has correct baseUrl', () {
        when(() => httpClient.get(any())).thenAnswer(
          (_) async => http.Response('', HttpStatus.ok),
        );
        final apiClient = GoogleNewsTemplateApiClient.localhost(
          httpClient: httpClient,
        );

        apiClient.getFeed().ignore();

        verify(
          () => httpClient.get(
            any(
              that: isA<Uri>().having(
                (u) => u.authority,
                'authority',
                'localhost:8080',
              ),
            ),
          ),
        ).called(1);
      });
    });

    group('default constructor', () {
      test('can be instantiated (no params).', () {
        expect(GoogleNewsTemplateApiClient.new, returnsNormally);
      });

      test('has correct baseUrl.', () {
        when(() => httpClient.get(any())).thenAnswer(
          (_) async => http.Response('', HttpStatus.ok),
        );
        final apiClient = GoogleNewsTemplateApiClient(
          httpClient: httpClient,
        );

        apiClient.getFeed().ignore();

        verify(
          () => httpClient.get(
            any(
              that: isA<Uri>().having(
                (u) => u.authority,
                'authority',
                'google-news-template-api-q66trdlzja-uc.a.run.app',
              ),
            ),
          ),
        ).called(1);
      });
    });

    group('getFeed', () {
      test('makes correct http request.', () {
        when(() => httpClient.get(any())).thenAnswer(
          (_) async => http.Response('', HttpStatus.ok),
        );

        apiClient.getFeed().ignore();

        verify(
          () => httpClient.get(
            any(
              that: isA<Uri>().having(
                (u) => u.path,
                'path',
                '/api/v1/feed',
              ),
            ),
          ),
        ).called(1);
      });

      test(
          'throws GoogleNewsTemplateApiMalformedResponse '
          'when response body is malformed.', () {
        when(() => httpClient.get(any())).thenAnswer(
          (_) async => http.Response('', HttpStatus.ok),
        );

        expect(
          apiClient.getFeed,
          throwsA(isA<GoogleNewsTemplateApiMalformedResponse>()),
        );
      });

      test(
          'throws GoogleNewsTemplateApiRequestFailure '
          'when response has a non-200 status code.', () {
        const statusCode = HttpStatus.internalServerError;
        final body = <String, dynamic>{};
        when(() => httpClient.get(any())).thenAnswer(
          (_) async => http.Response(json.encode(body), statusCode),
        );

        expect(
          apiClient.getFeed,
          throwsA(
            isA<GoogleNewsTemplateApiRequestFailure>()
                .having((f) => f.statusCode, 'statusCode', statusCode)
                .having((f) => f.body, 'body', body),
          ),
        );
      });

      test('returns a FeedResponse on a 200 response.', () {
        const expectedResponse = FeedResponse(feed: [], totalCount: 0);
        when(() => httpClient.get(any())).thenAnswer(
          (_) async => http.Response(
            json.encode(expectedResponse.toJson()),
            HttpStatus.ok,
          ),
        );

        expect(apiClient.getFeed(), completion(equals(expectedResponse)));
      });
    });

    group('getCategories', () {
      test('makes correct http request.', () {
        when(() => httpClient.get(any())).thenAnswer(
          (_) async => http.Response('', HttpStatus.ok),
        );

        apiClient.getCategories().ignore();

        verify(
          () => httpClient.get(
            any(
              that: isA<Uri>().having(
                (u) => u.path,
                'path',
                '/api/v1/categories',
              ),
            ),
          ),
        ).called(1);
      });

      test(
          'throws GoogleNewsTemplateApiMalformedResponse '
          'when response body is malformed.', () {
        when(() => httpClient.get(any())).thenAnswer(
          (_) async => http.Response('', HttpStatus.ok),
        );

        expect(
          apiClient.getCategories,
          throwsA(isA<GoogleNewsTemplateApiMalformedResponse>()),
        );
      });

      test(
          'throws GoogleNewsTemplateApiRequestFailure '
          'when response has a non-200 status code.', () {
        const statusCode = HttpStatus.internalServerError;
        final body = <String, dynamic>{};
        when(() => httpClient.get(any())).thenAnswer(
          (_) async => http.Response(json.encode(body), statusCode),
        );

        expect(
          apiClient.getCategories,
          throwsA(
            isA<GoogleNewsTemplateApiRequestFailure>()
                .having((f) => f.statusCode, 'statusCode', statusCode)
                .having((f) => f.body, 'body', body),
          ),
        );
      });

      test('returns a CategoriesResponse on a 200 response.', () {
        const expectedResponse = CategoriesResponse(
          categories: [Category.business, Category.top],
        );
        when(() => httpClient.get(any())).thenAnswer(
          (_) async => http.Response(
            json.encode(expectedResponse.toJson()),
            HttpStatus.ok,
          ),
        );

        expect(apiClient.getCategories(), completion(equals(expectedResponse)));
      });
    });
  });
}
