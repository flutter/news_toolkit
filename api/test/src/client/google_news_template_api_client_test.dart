import 'dart:convert';
import 'dart:io';

import 'package:google_news_template_api/client.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:token_storage/token_storage.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockTokenStorage extends Mock implements TokenStorage {}

void main() {
  Matcher isAUriHaving({String? authority, String? path, String? query}) {
    return predicate<Uri>((uri) {
      authority ??= uri.authority;
      path ??= uri.path;
      query ??= uri.query;

      return uri.authority == authority &&
          uri.path == path &&
          uri.query == query;
    });
  }

  Matcher areJsonHeaders({String? authorizationToken}) {
    return predicate<Map<String, String>?>((headers) {
      if (headers?[HttpHeaders.contentTypeHeader] != ContentType.json.value ||
          headers?[HttpHeaders.acceptHeader] != ContentType.json.value) {
        return false;
      }
      if (authorizationToken != null &&
          headers?[HttpHeaders.authorizationHeader] !=
              'Bearer $authorizationToken') {
        return false;
      }
      return true;
    });
  }

  group('GoogleNewsTemplateApiClient', () {
    late http.Client httpClient;
    late GoogleNewsTemplateApiClient apiClient;
    late TokenStorage tokenStorage;

    const token = 'token';

    setUpAll(() {
      registerFallbackValue(Uri());
    });

    setUp(() {
      httpClient = MockHttpClient();
      tokenStorage = MockTokenStorage();
      when(tokenStorage.readToken).thenAnswer((_) async => null);
      apiClient = GoogleNewsTemplateApiClient(
        httpClient: httpClient,
        tokenStorage: tokenStorage,
      );
    });

    group('localhost constructor', () {
      test('can be instantiated (no params)', () {
        expect(
          () =>
              GoogleNewsTemplateApiClient.localhost(tokenStorage: tokenStorage),
          returnsNormally,
        );
      });

      test('has correct baseUrl', () async {
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer(
          (_) async => http.Response(
            jsonEncode(const FeedResponse(feed: [], totalCount: 0)),
            HttpStatus.ok,
          ),
        );
        final apiClient = GoogleNewsTemplateApiClient.localhost(
          httpClient: httpClient,
          tokenStorage: tokenStorage,
        );

        await apiClient.getFeed();

        verify(
          () => httpClient.get(
            any(that: isAUriHaving(authority: 'localhost:8080')),
            headers: any(named: 'headers', that: areJsonHeaders()),
          ),
        ).called(1);
      });
    });

    group('default constructor', () {
      test('can be instantiated (no params).', () {
        expect(
          () => GoogleNewsTemplateApiClient(tokenStorage: tokenStorage),
          returnsNormally,
        );
      });

      test('has correct baseUrl.', () async {
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer(
          (_) async => http.Response(
            jsonEncode(const FeedResponse(feed: [], totalCount: 0)),
            HttpStatus.ok,
          ),
        );
        final apiClient = GoogleNewsTemplateApiClient(
          httpClient: httpClient,
          tokenStorage: tokenStorage,
        );

        await apiClient.getFeed();
        verify(
          () => httpClient.get(
            any(
              that: isAUriHaving(
                authority: 'google-news-template-api-q66trdlzja-uc.a.run.app',
              ),
            ),
            headers: any(named: 'headers', that: areJsonHeaders()),
          ),
        ).called(1);
      });
    });

    group('getArticle', () {
      final articleResponse = ArticleResponse(
        content: const [],
        totalCount: 0,
        url: Uri.parse('https://dailyglobe.com'),
      );

      test('makes correct http request (no query params).', () async {
        const articleId = '__article_id__';
        const path = '/api/v1/articles/$articleId';
        const query = '';

        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer(
          (_) async =>
              http.Response(jsonEncode(articleResponse), HttpStatus.ok),
        );

        await apiClient.getArticle(id: articleId);

        verify(
          () => httpClient.get(
            any(that: isAUriHaving(path: path, query: query)),
            headers: any(named: 'headers', that: areJsonHeaders()),
          ),
        ).called(1);
      });

      test('makes correct http request (with query params).', () async {
        const limit = 42;
        const offset = 7;
        const articleId = '__article_id__';
        const path = '/api/v1/articles/$articleId';
        const query = 'limit=$limit&offset=$offset';

        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer(
          (_) async =>
              http.Response(jsonEncode(articleResponse), HttpStatus.ok),
        );

        await apiClient.getArticle(id: articleId, limit: limit, offset: offset);

        verify(
          () => httpClient.get(
            any(that: isAUriHaving(path: path, query: query)),
            headers: any(named: 'headers', that: areJsonHeaders()),
          ),
        ).called(1);
      });

      test('makes correct http request (with authorization token).', () async {
        const articleId = '__article_id__';
        const path = '/api/v1/articles/$articleId';
        const query = '';

        when(tokenStorage.readToken).thenAnswer((_) async => token);

        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer(
          (_) async =>
              http.Response(jsonEncode(articleResponse), HttpStatus.ok),
        );

        await apiClient.getArticle(id: articleId);

        verify(
          () => httpClient.get(
            any(that: isAUriHaving(path: path, query: query)),
            headers: any(
              named: 'headers',
              that: areJsonHeaders(authorizationToken: token),
            ),
          ),
        ).called(1);
      });

      test(
          'throws GoogleNewsTemplateApiMalformedResponse '
          'when response body is malformed.', () {
        const articleId = '__article_id__';
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer(
          (_) async => http.Response('', HttpStatus.ok),
        );

        expect(
          () => apiClient.getArticle(id: articleId),
          throwsA(isA<GoogleNewsTemplateApiMalformedResponse>()),
        );
      });

      test(
          'throws GoogleNewsTemplateApiRequestFailure '
          'when response has a non-200 status code.', () {
        const articleId = '__article_id__';
        const statusCode = HttpStatus.internalServerError;
        final body = <String, dynamic>{};
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer(
          (_) async => http.Response(json.encode(body), statusCode),
        );

        expect(
          () => apiClient.getArticle(id: articleId),
          throwsA(
            isA<GoogleNewsTemplateApiRequestFailure>()
                .having((f) => f.statusCode, 'statusCode', statusCode)
                .having((f) => f.body, 'body', body),
          ),
        );
      });

      test('returns a ArticleResponse on a 200 response.', () {
        const articleId = '__article_id__';
        final expectedResponse = ArticleResponse(
          content: const [],
          totalCount: 0,
          url: Uri.parse('http://dailyglobe.com'),
        );
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer(
          (_) async => http.Response(
            json.encode(expectedResponse.toJson()),
            HttpStatus.ok,
          ),
        );

        expect(
          apiClient.getArticle(id: articleId),
          completion(equals(expectedResponse)),
        );
      });
    });

    group('getRelatedArticles', () {
      const relatedArticlesResponse = RelatedArticlesResponse(
        relatedArticles: [],
        totalCount: 0,
      );

      test('makes correct http request (no query params).', () async {
        const articleId = '__article_id__';
        const path = '/api/v1/articles/$articleId/related';
        const query = '';

        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer(
          (_) async =>
              http.Response(jsonEncode(relatedArticlesResponse), HttpStatus.ok),
        );

        await apiClient.getRelatedArticles(id: articleId);

        verify(
          () => httpClient.get(
            any(that: isAUriHaving(path: path, query: query)),
            headers: any(named: 'headers', that: areJsonHeaders()),
          ),
        ).called(1);
      });

      test('makes correct http request (with query params).', () async {
        const limit = 42;
        const offset = 7;
        const articleId = '__article_id__';
        const path = '/api/v1/articles/$articleId/related';
        const query = 'limit=$limit&offset=$offset';

        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer(
          (_) async =>
              http.Response(jsonEncode(relatedArticlesResponse), HttpStatus.ok),
        );

        await apiClient.getRelatedArticles(
          id: articleId,
          limit: limit,
          offset: offset,
        );

        verify(
          () => httpClient.get(
            any(that: isAUriHaving(path: path, query: query)),
            headers: any(named: 'headers', that: areJsonHeaders()),
          ),
        ).called(1);
      });

      test('makes correct http request (with authorization token).', () async {
        const articleId = '__article_id__';
        const path = '/api/v1/articles/$articleId/related';
        const query = '';

        when(tokenStorage.readToken).thenAnswer((_) async => token);

        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer(
          (_) async =>
              http.Response(jsonEncode(relatedArticlesResponse), HttpStatus.ok),
        );

        await apiClient.getRelatedArticles(id: articleId);

        verify(
          () => httpClient.get(
            any(that: isAUriHaving(path: path, query: query)),
            headers: any(
              named: 'headers',
              that: areJsonHeaders(authorizationToken: token),
            ),
          ),
        ).called(1);
      });

      test(
          'throws GoogleNewsTemplateApiMalformedResponse '
          'when response body is malformed.', () {
        const articleId = '__article_id__';
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer(
          (_) async => http.Response('', HttpStatus.ok),
        );

        expect(
          () => apiClient.getRelatedArticles(id: articleId),
          throwsA(isA<GoogleNewsTemplateApiMalformedResponse>()),
        );
      });

      test(
          'throws GoogleNewsTemplateApiRequestFailure '
          'when response has a non-200 status code.', () {
        const articleId = '__article_id__';
        const statusCode = HttpStatus.internalServerError;
        final body = <String, dynamic>{};
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer(
          (_) async => http.Response(json.encode(body), statusCode),
        );

        expect(
          () => apiClient.getRelatedArticles(id: articleId),
          throwsA(
            isA<GoogleNewsTemplateApiRequestFailure>()
                .having((f) => f.statusCode, 'statusCode', statusCode)
                .having((f) => f.body, 'body', body),
          ),
        );
      });

      test('returns a RelatedArticlesResponse on a 200 response.', () {
        const articleId = '__article_id__';
        const expectedResponse = RelatedArticlesResponse(
          relatedArticles: [],
          totalCount: 0,
        );
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer(
          (_) async => http.Response(
            json.encode(expectedResponse.toJson()),
            HttpStatus.ok,
          ),
        );

        expect(
          apiClient.getRelatedArticles(id: articleId),
          completion(equals(expectedResponse)),
        );
      });
    });

    group('getFeed', () {
      const feedResponse = FeedResponse(
        feed: [],
        totalCount: 0,
      );

      test('makes correct http request (no query params).', () async {
        const path = '/api/v1/feed';
        const query = '';

        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer(
          (_) async => http.Response(jsonEncode(feedResponse), HttpStatus.ok),
        );

        await apiClient.getFeed();

        verify(
          () => httpClient.get(
            any(that: isAUriHaving(path: path, query: query)),
            headers: any(named: 'headers', that: areJsonHeaders()),
          ),
        ).called(1);
      });

      test('makes correct http request (with query params).', () async {
        const category = Category.science;
        const limit = 42;
        const offset = 7;
        const path = '/api/v1/feed';
        final query = 'category=${category.name}&limit=$limit&offset=$offset';

        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer(
          (_) async => http.Response(jsonEncode(feedResponse), HttpStatus.ok),
        );

        await apiClient.getFeed(
          category: category,
          limit: limit,
          offset: offset,
        );

        verify(
          () => httpClient.get(
            any(that: isAUriHaving(path: path, query: query)),
            headers: any(named: 'headers', that: areJsonHeaders()),
          ),
        ).called(1);
      });

      test('makes correct http request (with authorization token).', () async {
        const path = '/api/v1/feed';
        const query = '';

        when(tokenStorage.readToken).thenAnswer((_) async => token);

        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer(
          (_) async => http.Response(jsonEncode(feedResponse), HttpStatus.ok),
        );

        await apiClient.getFeed();

        verify(
          () => httpClient.get(
            any(that: isAUriHaving(path: path, query: query)),
            headers: any(
              named: 'headers',
              that: areJsonHeaders(authorizationToken: token),
            ),
          ),
        ).called(1);
      });

      test(
          'throws GoogleNewsTemplateApiMalformedResponse '
          'when response body is malformed.', () {
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer(
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
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer(
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
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer(
          (_) async => http.Response(
            json.encode(expectedResponse.toJson()),
            HttpStatus.ok,
          ),
        );

        expect(apiClient.getFeed(), completion(equals(expectedResponse)));
      });
    });

    group('getCategories', () {
      const categoriesResponse = CategoriesResponse(categories: []);

      test('makes correct http request.', () async {
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer(
          (_) async =>
              http.Response(jsonEncode(categoriesResponse), HttpStatus.ok),
        );

        await apiClient.getCategories();

        verify(
          () => httpClient.get(
            any(that: isAUriHaving(path: '/api/v1/categories')),
            headers: any(named: 'headers', that: areJsonHeaders()),
          ),
        ).called(1);
      });

      test('makes correct http request (with authorization token).', () async {
        when(tokenStorage.readToken).thenAnswer((_) async => token);

        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer(
          (_) async =>
              http.Response(jsonEncode(categoriesResponse), HttpStatus.ok),
        );

        await apiClient.getCategories();

        verify(
          () => httpClient.get(
            any(that: isAUriHaving(path: '/api/v1/categories')),
            headers: any(
              named: 'headers',
              that: areJsonHeaders(authorizationToken: token),
            ),
          ),
        ).called(1);
      });

      test(
          'throws GoogleNewsTemplateApiMalformedResponse '
          'when response body is malformed.', () {
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer(
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
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer(
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
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer(
          (_) async => http.Response(
            json.encode(expectedResponse.toJson()),
            HttpStatus.ok,
          ),
        );

        expect(apiClient.getCategories(), completion(equals(expectedResponse)));
      });
    });

    group('popularSearch', () {
      const popularSearchResponse = PopularSearchResponse(
        articles: [],
        topics: [],
      );

      test('makes correct http request.', () async {
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer(
          (_) async =>
              http.Response(jsonEncode(popularSearchResponse), HttpStatus.ok),
        );

        await apiClient.popularSearch();

        verify(
          () => httpClient.get(
            any(that: isAUriHaving(path: '/api/v1/search/popular')),
            headers: any(named: 'headers', that: areJsonHeaders()),
          ),
        ).called(1);
      });

      test('makes correct http request (with authorization token).', () async {
        when(tokenStorage.readToken).thenAnswer((_) async => token);

        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer(
          (_) async =>
              http.Response(jsonEncode(popularSearchResponse), HttpStatus.ok),
        );

        await apiClient.popularSearch();

        verify(
          () => httpClient.get(
            any(that: isAUriHaving(path: '/api/v1/search/popular')),
            headers: any(
              named: 'headers',
              that: areJsonHeaders(authorizationToken: token),
            ),
          ),
        ).called(1);
      });

      test(
          'throws GoogleNewsTemplateApiMalformedResponse '
          'when response body is malformed.', () {
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer(
          (_) async => http.Response('', HttpStatus.ok),
        );

        expect(
          apiClient.popularSearch,
          throwsA(isA<GoogleNewsTemplateApiMalformedResponse>()),
        );
      });

      test(
          'throws GoogleNewsTemplateApiRequestFailure '
          'when response has a non-200 status code.', () {
        const statusCode = HttpStatus.internalServerError;
        final body = <String, dynamic>{};
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer(
          (_) async => http.Response(json.encode(body), statusCode),
        );

        expect(
          apiClient.popularSearch,
          throwsA(
            isA<GoogleNewsTemplateApiRequestFailure>()
                .having((f) => f.statusCode, 'statusCode', statusCode)
                .having((f) => f.body, 'body', body),
          ),
        );
      });

      test('returns a PopularSearchResponse on a 200 response.', () {
        const expectedResponse = PopularSearchResponse(
          articles: [],
          topics: [],
        );
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer(
          (_) async => http.Response(
            json.encode(expectedResponse.toJson()),
            HttpStatus.ok,
          ),
        );

        expect(apiClient.popularSearch(), completion(equals(expectedResponse)));
      });
    });

    group('relevantSearch', () {
      const term = '__test_term__';

      const relevantSearchResponse = RelevantSearchResponse(
        articles: [],
        topics: [],
      );

      test('makes correct http request.', () async {
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer(
          (_) async =>
              http.Response(jsonEncode(relevantSearchResponse), HttpStatus.ok),
        );

        await apiClient.relevantSearch(term: term);

        verify(
          () => httpClient.get(
            any(
              that: isAUriHaving(
                path: '/api/v1/search/relevant',
                query: 'q=$term',
              ),
            ),
            headers: any(named: 'headers', that: areJsonHeaders()),
          ),
        ).called(1);
      });

      test('makes correct http request (with authorization token).', () async {
        when(tokenStorage.readToken).thenAnswer((_) async => token);

        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer(
          (_) async =>
              http.Response(jsonEncode(relevantSearchResponse), HttpStatus.ok),
        );

        await apiClient.relevantSearch(term: term);

        verify(
          () => httpClient.get(
            any(
              that: isAUriHaving(
                path: '/api/v1/search/relevant',
                query: 'q=$term',
              ),
            ),
            headers: any(
              named: 'headers',
              that: areJsonHeaders(authorizationToken: token),
            ),
          ),
        ).called(1);
      });

      test(
          'throws GoogleNewsTemplateApiMalformedResponse '
          'when response body is malformed.', () {
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer(
          (_) async => http.Response('', HttpStatus.ok),
        );

        expect(
          () => apiClient.relevantSearch(term: term),
          throwsA(isA<GoogleNewsTemplateApiMalformedResponse>()),
        );
      });

      test(
          'throws GoogleNewsTemplateApiRequestFailure '
          'when response has a non-200 status code.', () {
        const statusCode = HttpStatus.internalServerError;
        final body = <String, dynamic>{};
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer(
          (_) async => http.Response(json.encode(body), statusCode),
        );

        expect(
          () => apiClient.relevantSearch(term: term),
          throwsA(
            isA<GoogleNewsTemplateApiRequestFailure>()
                .having((f) => f.statusCode, 'statusCode', statusCode)
                .having((f) => f.body, 'body', body),
          ),
        );
      });

      test('returns a RelevantSearchResponse on a 200 response.', () {
        const expectedResponse = RelevantSearchResponse(
          articles: [],
          topics: [],
        );
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer(
          (_) async => http.Response(
            json.encode(expectedResponse.toJson()),
            HttpStatus.ok,
          ),
        );

        expect(
          apiClient.relevantSearch(term: term),
          completion(equals(expectedResponse)),
        );
      });
    });

    group('subscribeToNewsletter', () {
      const email = 'test@gmail.com';

      test('makes correct http request.', () async {
        when(
          () => httpClient.post(
            any(),
            body: any(named: 'body'),
            headers: any(named: 'headers'),
          ),
        ).thenAnswer(
          (_) async => http.Response('', HttpStatus.created),
        );

        await apiClient.subscribeToNewsletter(email: email);

        verify(
          () => httpClient.post(
            any(that: isAUriHaving(path: '/api/v1/newsletter/subscription')),
            headers: any(named: 'headers', that: areJsonHeaders()),
            body: json.encode({'email': email}),
          ),
        ).called(1);
      });

      test('makes correct http request (with authorization token).', () async {
        when(tokenStorage.readToken).thenAnswer((_) async => token);

        when(
          () => httpClient.post(
            any(),
            body: any(named: 'body'),
            headers: any(named: 'headers'),
          ),
        ).thenAnswer(
          (_) async => http.Response('', HttpStatus.created),
        );

        await apiClient.subscribeToNewsletter(email: email);

        verify(
          () => httpClient.post(
            any(that: isAUriHaving(path: '/api/v1/newsletter/subscription')),
            headers: any(
              named: 'headers',
              that: areJsonHeaders(authorizationToken: token),
            ),
            body: json.encode({'email': email}),
          ),
        ).called(1);
      });

      test(
          'throws GoogleNewsTemplateApiRequestFailure '
          'when response has a non-201 status code.', () {
        const statusCode = HttpStatus.internalServerError;
        when(
          () => httpClient.post(
            any(),
            body: any(named: 'body'),
            headers: any(named: 'headers'),
          ),
        ).thenAnswer(
          (_) async => http.Response('', statusCode),
        );

        expect(
          () => apiClient.subscribeToNewsletter(email: email),
          throwsA(
            isA<GoogleNewsTemplateApiRequestFailure>()
                .having((f) => f.statusCode, 'statusCode', statusCode)
                .having((f) => f.body, 'body', isEmpty),
          ),
        );
      });

      test('resolves on a 201 response.', () {
        when(
          () => httpClient.post(
            any(),
            body: any(named: 'body'),
            headers: any(named: 'headers'),
          ),
        ).thenAnswer(
          (_) async => http.Response('', HttpStatus.created),
        );

        expect(apiClient.subscribeToNewsletter(email: email), completes);
      });
    });

    group('createSubscription', () {
      test('makes correct http request.', () async {
        when(
          () => httpClient.post(any(), headers: any(named: 'headers')),
        ).thenAnswer(
          (_) async => http.Response('', HttpStatus.created),
        );

        await apiClient.createSubscription();

        verify(
          () => httpClient.post(
            any(that: isAUriHaving(path: '/api/v1/subscriptions')),
            headers: any(named: 'headers', that: areJsonHeaders()),
          ),
        ).called(1);
      });

      test('makes correct http request (with authorization token).', () async {
        when(tokenStorage.readToken).thenAnswer((_) async => token);

        when(
          () => httpClient.post(any(), headers: any(named: 'headers')),
        ).thenAnswer(
          (_) async => http.Response('', HttpStatus.created),
        );

        await apiClient.createSubscription();

        verify(
          () => httpClient.post(
            any(that: isAUriHaving(path: '/api/v1/subscriptions')),
            headers: any(
              named: 'headers',
              that: areJsonHeaders(authorizationToken: token),
            ),
          ),
        ).called(1);
      });

      test(
          'throws GoogleNewsTemplateApiRequestFailure '
          'when response has a non-201 status code.', () {
        const statusCode = HttpStatus.internalServerError;
        when(() => httpClient.post(any(), headers: any(named: 'headers')))
            .thenAnswer(
          (_) async => http.Response('', statusCode),
        );

        expect(
          () => apiClient.createSubscription(),
          throwsA(
            isA<GoogleNewsTemplateApiRequestFailure>()
                .having((f) => f.statusCode, 'statusCode', statusCode)
                .having((f) => f.body, 'body', isEmpty),
          ),
        );
      });

      test('resolves on a 201 response.', () {
        when(() => httpClient.post(any(), headers: any(named: 'headers')))
            .thenAnswer(
          (_) async => http.Response('', HttpStatus.created),
        );

        expect(apiClient.createSubscription(), completes);
      });
    });
  });
}
