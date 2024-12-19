import 'dart:convert';
import 'dart:io';

import 'package:{{project_name.snakeCase()}}_api/client.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockHttpClient extends Mock implements http.Client {}

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

  group('{{project_name.pascalCase()}}ApiClient', () {
    late http.Client httpClient;
    late {{project_name.pascalCase()}}ApiClient apiClient;
    late TokenProvider tokenProvider;

    const token = 'token';

    setUpAll(() {
      registerFallbackValue(Uri());
    });

    setUp(() {
      httpClient = MockHttpClient();
      tokenProvider = () async => null;
      apiClient = {{project_name.pascalCase()}}ApiClient(
        httpClient: httpClient,
        tokenProvider: tokenProvider,
      );
    });

    group('localhost constructor', () {
      test('can be instantiated (no params)', () {
        expect(
          () => {{project_name.pascalCase()}}ApiClient.localhost(
            tokenProvider: tokenProvider,
          ),
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
        final apiClient = {{project_name.pascalCase()}}ApiClient.localhost(
          httpClient: httpClient,
          tokenProvider: tokenProvider,
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
          () => {{project_name.pascalCase()}}ApiClient(tokenProvider: tokenProvider),
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
        final apiClient = {{project_name.pascalCase()}}ApiClient(
          httpClient: httpClient,
          tokenProvider: tokenProvider,
        );

        await apiClient.getFeed();
        verify(
          () => httpClient.get(
            any(
              that: isAUriHaving(
                authority: '{{api_url}}',
              ),
            ),
            headers: any(named: 'headers', that: areJsonHeaders()),
          ),
        ).called(1);
      });
    });

    group('getArticle', () {
      final articleResponse = ArticleResponse(
        title: 'title',
        content: const [],
        totalCount: 0,
        url: Uri.parse('https://dailyglobe.com'),
        isPremium: false,
        isPreview: false,
      );

      test('makes correct http request (no query params).', () async {
        const articleId = '__article_id__';
        const path = '/api/v1/articles/$articleId';
        const query = 'preview=false';

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
        const query = 'limit=$limit&offset=$offset&preview=true';

        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer(
          (_) async =>
              http.Response(jsonEncode(articleResponse), HttpStatus.ok),
        );

        await apiClient.getArticle(
          id: articleId,
          limit: limit,
          offset: offset,
          preview: true,
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
        const path = '/api/v1/articles/$articleId';
        const query = 'preview=false';

        tokenProvider = () async => token;

        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer(
          (_) async =>
              http.Response(jsonEncode(articleResponse), HttpStatus.ok),
        );

        await {{project_name.pascalCase()}}ApiClient(
          httpClient: httpClient,
          tokenProvider: tokenProvider,
        ).getArticle(id: articleId);

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
          'throws {{project_name.pascalCase()}}ApiMalformedResponse '
          'when response body is malformed.', () {
        const articleId = '__article_id__';
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer(
          (_) async => http.Response('', HttpStatus.ok),
        );

        expect(
          () => apiClient.getArticle(id: articleId),
          throwsA(isA<{{project_name.pascalCase()}}ApiMalformedResponse>()),
        );
      });

      test(
          'throws {{project_name.pascalCase()}}ApiRequestFailure '
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
            isA<{{project_name.pascalCase()}}ApiRequestFailure>()
                .having((f) => f.statusCode, 'statusCode', statusCode)
                .having((f) => f.body, 'body', body),
          ),
        );
      });

      test('returns a ArticleResponse on a 200 response.', () {
        const articleId = '__article_id__';
        final expectedResponse = ArticleResponse(
          title: 'title',
          content: const [],
          totalCount: 0,
          url: Uri.parse('http://dailyglobe.com'),
          isPremium: false,
          isPreview: false,
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

        tokenProvider = () async => token;

        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer(
          (_) async =>
              http.Response(jsonEncode(relatedArticlesResponse), HttpStatus.ok),
        );

        await {{project_name.pascalCase()}}ApiClient(
          httpClient: httpClient,
          tokenProvider: tokenProvider,
        ).getRelatedArticles(id: articleId);

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
          'throws {{project_name.pascalCase()}}ApiMalformedResponse '
          'when response body is malformed.', () {
        const articleId = '__article_id__';
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer(
          (_) async => http.Response('', HttpStatus.ok),
        );

        expect(
          () => apiClient.getRelatedArticles(id: articleId),
          throwsA(isA<{{project_name.pascalCase()}}ApiMalformedResponse>()),
        );
      });

      test(
          'throws {{project_name.pascalCase()}}ApiRequestFailure '
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
            isA<{{project_name.pascalCase()}}ApiRequestFailure>()
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
        const category = Category(id: 'sports', name: 'Sports');
        const limit = 42;
        const offset = 7;
        const path = '/api/v1/feed';
        final query = 'category=${category.id}&limit=$limit&offset=$offset';

        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer(
          (_) async => http.Response(jsonEncode(feedResponse), HttpStatus.ok),
        );

        await apiClient.getFeed(
          categoryId: category.id,
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

        tokenProvider = () async => token;

        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer(
          (_) async => http.Response(jsonEncode(feedResponse), HttpStatus.ok),
        );

        await {{project_name.pascalCase()}}ApiClient(
          httpClient: httpClient,
          tokenProvider: tokenProvider,
        ).getFeed();

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
          'throws {{project_name.pascalCase()}}ApiMalformedResponse '
          'when response body is malformed.', () {
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer(
          (_) async => http.Response('', HttpStatus.ok),
        );

        expect(
          apiClient.getFeed,
          throwsA(isA<{{project_name.pascalCase()}}ApiMalformedResponse>()),
        );
      });

      test(
          'throws {{project_name.pascalCase()}}ApiRequestFailure '
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
            isA<{{project_name.pascalCase()}}ApiRequestFailure>()
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
        tokenProvider = () async => token;

        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer(
          (_) async =>
              http.Response(jsonEncode(categoriesResponse), HttpStatus.ok),
        );

        await {{project_name.pascalCase()}}ApiClient(
          httpClient: httpClient,
          tokenProvider: tokenProvider,
        ).getCategories();

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
          'throws {{project_name.pascalCase()}}ApiMalformedResponse '
          'when response body is malformed.', () {
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer(
          (_) async => http.Response('', HttpStatus.ok),
        );

        expect(
          apiClient.getCategories,
          throwsA(isA<{{project_name.pascalCase()}}ApiMalformedResponse>()),
        );
      });

      test(
          'throws {{project_name.pascalCase()}}ApiRequestFailure '
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
            isA<{{project_name.pascalCase()}}ApiRequestFailure>()
                .having((f) => f.statusCode, 'statusCode', statusCode)
                .having((f) => f.body, 'body', body),
          ),
        );
      });

      test('returns a CategoriesResponse on a 200 response.', () {
        const sportsCategory = Category(id: 'sports', name: 'Sports');
        const topCategory = Category(id: 'top', name: 'Top');

        const expectedResponse = CategoriesResponse(
          categories: [sportsCategory, topCategory],
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

    group('getCurrentUser', () {
      const currentUserResponse = CurrentUserResponse(
        user: User(id: 'id', subscription: SubscriptionPlan.basic),
      );

      test('makes correct http request.', () async {
        when(
          () => httpClient.get(any(), headers: any(named: 'headers')),
        ).thenAnswer(
          (_) async => http.Response(
            jsonEncode(currentUserResponse),
            HttpStatus.ok,
          ),
        );

        await apiClient.getCurrentUser();

        verify(
          () => httpClient.get(
            any(that: isAUriHaving(path: '/api/v1/users/me')),
            headers: any(named: 'headers', that: areJsonHeaders()),
          ),
        ).called(1);
      });

      test('makes correct http request (with authorization token).', () async {
        tokenProvider = () async => token;

        when(
          () => httpClient.get(any(), headers: any(named: 'headers')),
        ).thenAnswer(
          (_) async => http.Response(
            jsonEncode(currentUserResponse),
            HttpStatus.ok,
          ),
        );

        await {{project_name.pascalCase()}}ApiClient(
          httpClient: httpClient,
          tokenProvider: tokenProvider,
        ).getCurrentUser();

        verify(
          () => httpClient.get(
            any(that: isAUriHaving(path: '/api/v1/users/me')),
            headers: any(
              named: 'headers',
              that: areJsonHeaders(authorizationToken: token),
            ),
          ),
        ).called(1);
      });

      test(
          'throws {{project_name.pascalCase()}}ApiMalformedResponse '
          'when response body is malformed.', () {
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer(
          (_) async => http.Response('', HttpStatus.ok),
        );

        expect(
          apiClient.getCurrentUser,
          throwsA(isA<{{project_name.pascalCase()}}ApiMalformedResponse>()),
        );
      });

      test(
          'throws {{project_name.pascalCase()}}ApiRequestFailure '
          'when response has a non-200 status code.', () {
        const statusCode = HttpStatus.internalServerError;
        final body = <String, dynamic>{};
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer(
          (_) async => http.Response(json.encode(body), statusCode),
        );

        expect(
          apiClient.getCurrentUser,
          throwsA(
            isA<{{project_name.pascalCase()}}ApiRequestFailure>()
                .having((f) => f.statusCode, 'statusCode', statusCode)
                .having((f) => f.body, 'body', body),
          ),
        );
      });

      test('returns a CurrentUserResponse on a 200 response.', () {
        const expectedResponse = CurrentUserResponse(
          user: User(id: 'id', subscription: SubscriptionPlan.basic),
        );
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer(
          (_) async => http.Response(
            json.encode(expectedResponse.toJson()),
            HttpStatus.ok,
          ),
        );

        expect(
          apiClient.getCurrentUser(),
          completion(equals(expectedResponse)),
        );
      });
    });

    group('getSubscriptions', () {
      const subscriptionsResponse = SubscriptionsResponse(subscriptions: []);

      test('makes correct http request.', () async {
        when(() => httpClient.get(any())).thenAnswer(
          (_) async => http.Response(
            jsonEncode(subscriptionsResponse),
            HttpStatus.ok,
          ),
        );

        await apiClient.getSubscriptions();

        verify(
          () => httpClient.get(
            any(that: isAUriHaving(path: '/api/v1/subscriptions')),
          ),
        ).called(1);
      });

      test(
          'throws {{project_name.pascalCase()}}ApiMalformedResponse '
          'when response body is malformed.', () {
        when(() => httpClient.get(any())).thenAnswer(
          (_) async => http.Response('', HttpStatus.ok),
        );

        expect(
          apiClient.getSubscriptions,
          throwsA(isA<{{project_name.pascalCase()}}ApiMalformedResponse>()),
        );
      });

      test(
          'throws {{project_name.pascalCase()}}ApiRequestFailure '
          'when response has a non-200 status code.', () {
        const statusCode = HttpStatus.internalServerError;
        final body = <String, dynamic>{};
        when(() => httpClient.get(any())).thenAnswer(
          (_) async => http.Response(json.encode(body), statusCode),
        );

        expect(
          apiClient.getSubscriptions,
          throwsA(
            isA<{{project_name.pascalCase()}}ApiRequestFailure>()
                .having((f) => f.statusCode, 'statusCode', statusCode)
                .having((f) => f.body, 'body', body),
          ),
        );
      });

      test('returns a SubscriptionsResponse on a 200 response.', () {
        const expectedResponse = SubscriptionsResponse(
          subscriptions: [
            Subscription(
              id: 'id',
              name: SubscriptionPlan.premium,
              cost: SubscriptionCost(annual: 4200, monthly: 42),
              benefits: ['benefit'],
            ),
          ],
        );
        when(() => httpClient.get(any())).thenAnswer(
          (_) async => http.Response(
            json.encode(expectedResponse.toJson()),
            HttpStatus.ok,
          ),
        );

        expect(
          apiClient.getSubscriptions(),
          completion(equals(expectedResponse)),
        );
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
        tokenProvider = () async => token;

        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer(
          (_) async =>
              http.Response(jsonEncode(popularSearchResponse), HttpStatus.ok),
        );

        await {{project_name.pascalCase()}}ApiClient(
          httpClient: httpClient,
          tokenProvider: tokenProvider,
        ).popularSearch();

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
          'throws {{project_name.pascalCase()}}ApiMalformedResponse '
          'when response body is malformed.', () {
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer(
          (_) async => http.Response('', HttpStatus.ok),
        );

        expect(
          apiClient.popularSearch,
          throwsA(isA<{{project_name.pascalCase()}}ApiMalformedResponse>()),
        );
      });

      test(
          'throws {{project_name.pascalCase()}}ApiRequestFailure '
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
            isA<{{project_name.pascalCase()}}ApiRequestFailure>()
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
        tokenProvider = () async => token;

        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer(
          (_) async =>
              http.Response(jsonEncode(relevantSearchResponse), HttpStatus.ok),
        );

        await {{project_name.pascalCase()}}ApiClient(
          httpClient: httpClient,
          tokenProvider: tokenProvider,
        ).relevantSearch(term: term);

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
          'throws {{project_name.pascalCase()}}ApiMalformedResponse '
          'when response body is malformed.', () {
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer(
          (_) async => http.Response('', HttpStatus.ok),
        );

        expect(
          () => apiClient.relevantSearch(term: term),
          throwsA(isA<{{project_name.pascalCase()}}ApiMalformedResponse>()),
        );
      });

      test(
          'throws {{project_name.pascalCase()}}ApiRequestFailure '
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
            isA<{{project_name.pascalCase()}}ApiRequestFailure>()
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
        tokenProvider = () async => token;

        when(
          () => httpClient.post(
            any(),
            body: any(named: 'body'),
            headers: any(named: 'headers'),
          ),
        ).thenAnswer(
          (_) async => http.Response('', HttpStatus.created),
        );

        await {{project_name.pascalCase()}}ApiClient(
          httpClient: httpClient,
          tokenProvider: tokenProvider,
        ).subscribeToNewsletter(email: email);

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
          'throws {{project_name.pascalCase()}}ApiRequestFailure '
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
            isA<{{project_name.pascalCase()}}ApiRequestFailure>()
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
        const subscriptionId = 'subscriptionId';
        const query = 'subscriptionId=$subscriptionId';

        when(
          () => httpClient.post(any(), headers: any(named: 'headers')),
        ).thenAnswer(
          (_) async => http.Response('', HttpStatus.created),
        );

        await apiClient.createSubscription(subscriptionId: subscriptionId);

        verify(
          () => httpClient.post(
            any(
              that: isAUriHaving(path: '/api/v1/subscriptions', query: query),
            ),
            headers: any(named: 'headers', that: areJsonHeaders()),
          ),
        ).called(1);
      });

      test('makes correct http request (with authorization token).', () async {
        const subscriptionId = 'subscriptionId';
        const query = 'subscriptionId=$subscriptionId';

        tokenProvider = () async => token;

        when(
          () => httpClient.post(any(), headers: any(named: 'headers')),
        ).thenAnswer(
          (_) async => http.Response('', HttpStatus.created),
        );

        await {{project_name.pascalCase()}}ApiClient(
          httpClient: httpClient,
          tokenProvider: tokenProvider,
        ).createSubscription(subscriptionId: subscriptionId);

        verify(
          () => httpClient.post(
            any(
              that: isAUriHaving(path: '/api/v1/subscriptions', query: query),
            ),
            headers: any(
              named: 'headers',
              that: areJsonHeaders(authorizationToken: token),
            ),
          ),
        ).called(1);
      });

      test(
          'throws {{project_name.pascalCase()}}ApiRequestFailure '
          'when response has a non-201 status code.', () {
        const statusCode = HttpStatus.internalServerError;
        when(() => httpClient.post(any(), headers: any(named: 'headers')))
            .thenAnswer(
          (_) async => http.Response('', statusCode),
        );

        expect(
          () => apiClient.createSubscription(subscriptionId: 'subscriptionId'),
          throwsA(
            isA<{{project_name.pascalCase()}}ApiRequestFailure>()
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

        expect(
          apiClient.createSubscription(subscriptionId: 'subscriptionId'),
          completes,
        );
      });
    });
  });
}
