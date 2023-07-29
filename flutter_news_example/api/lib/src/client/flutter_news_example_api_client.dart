import 'dart:convert';
import 'dart:io';

import 'package:flutter_news_example_api/client.dart';
import 'package:http/http.dart' as http;

/// {@template flutter_news_example_api_malformed_response}
/// An exception thrown when there is a problem decoded the response body.
/// {@endtemplate}
class FlutterNewsExampleApiMalformedResponse implements Exception {
  /// {@macro flutter_news_example_api_malformed_response}
  const FlutterNewsExampleApiMalformedResponse({required this.error});

  /// The associated error.
  final Object error;
}

/// {@template flutter_news_example_api_request_failure}
/// An exception thrown when an http request failure occurs.
/// {@endtemplate}
class FlutterNewsExampleApiRequestFailure implements Exception {
  /// {@macro flutter_news_example_api_request_failure}
  const FlutterNewsExampleApiRequestFailure({
    required this.statusCode,
    required this.body,
  });

  /// The associated http status code.
  final int statusCode;

  /// The associated response body.
  final Map<String, dynamic> body;
}

/// Signature for the authentication token provider.
typedef TokenProvider = Future<String?> Function();

/// {@template flutter_news_example_api_client}
/// A Dart API client for the Flutter News Example API.
/// {@endtemplate}
class FlutterNewsExampleApiClient {
  /// Create an instance of [FlutterNewsExampleApiClient] that integrates
  /// with the remote API.
  ///
  /// {@macro flutter_news_example_api_client}
  FlutterNewsExampleApiClient({
    required TokenProvider tokenProvider,
    http.Client? httpClient,
  }) : this._(
          baseUrl: 'https://example-api.a.run.app',
          httpClient: httpClient,
          tokenProvider: tokenProvider,
        );

  /// Create an instance of [FlutterNewsExampleApiClient] that integrates
  /// with a local instance of the API (http://localhost:8080).
  ///
  /// {@macro flutter_news_example_api_client}
  FlutterNewsExampleApiClient.localhost({
    required TokenProvider tokenProvider,
    http.Client? httpClient,
  }) : this._(
          baseUrl: 'http://localhost:8080',
          httpClient: httpClient,
          tokenProvider: tokenProvider,
        );

  /// {@macro flutter_news_example_api_client}
  FlutterNewsExampleApiClient._({
    required String baseUrl,
    required TokenProvider tokenProvider,
    http.Client? httpClient,
  })  : _baseUrl = baseUrl,
        _httpClient = httpClient ?? http.Client(),
        _tokenProvider = tokenProvider;

  final String _baseUrl;
  final http.Client _httpClient;
  final TokenProvider _tokenProvider;

  /// GET /api/v1/articles/<id>
  /// Requests article content metadata.
  ///
  /// Supported parameters:
  /// * [id] - Article id for which content is requested.
  /// * [limit] - The number of results to return.
  /// * [offset] - The (zero-based) offset of the first item
  /// in the collection to return.
  /// * [preview] - Whether to return a preview of the article.
  Future<ArticleResponse> getArticle({
    required String id,
    int? limit,
    int? offset,
    bool preview = false,
  }) async {
    final uri = Uri.parse('$_baseUrl/api/v1/articles/$id').replace(
      queryParameters: <String, String>{
        if (limit != null) 'limit': '$limit',
        if (offset != null) 'offset': '$offset',
        'preview': '$preview',
      },
    );
    final response = await _httpClient.get(
      uri,
      headers: await _getRequestHeaders(),
    );
    final body = response.json();

    if (response.statusCode != HttpStatus.ok) {
      throw FlutterNewsExampleApiRequestFailure(
        body: body,
        statusCode: response.statusCode,
      );
    }

    return ArticleResponse.fromJson(body);
  }

  /// GET /api/v1/articles/<id>/related
  /// Requests related articles.
  ///
  /// Supported parameters:
  /// * [id] - Article id for which related content is requested.
  /// * [limit] - The number of results to return.
  /// * [offset] - The (zero-based) offset of the first item
  /// in the collection to return.
  Future<RelatedArticlesResponse> getRelatedArticles({
    required String id,
    int? limit,
    int? offset,
  }) async {
    final uri = Uri.parse('$_baseUrl/api/v1/articles/$id/related').replace(
      queryParameters: <String, String>{
        if (limit != null) 'limit': '$limit',
        if (offset != null) 'offset': '$offset',
      },
    );
    final response = await _httpClient.get(
      uri,
      headers: await _getRequestHeaders(),
    );
    final body = response.json();

    if (response.statusCode != HttpStatus.ok) {
      throw FlutterNewsExampleApiRequestFailure(
        body: body,
        statusCode: response.statusCode,
      );
    }

    return RelatedArticlesResponse.fromJson(body);
  }

  /// GET /api/v1/feed
  /// Requests news feed metadata.
  ///
  /// Supported parameters:
  /// * [category] - The desired news [Category].
  /// * [limit] - The number of results to return.
  /// * [offset] - The (zero-based) offset of the first item
  /// in the collection to return.
  Future<FeedResponse> getFeed({
    Category? category,
    int? limit,
    int? offset,
  }) async {
    final uri = Uri.parse('$_baseUrl/api/v1/feed').replace(
      queryParameters: <String, String>{
        if (category != null) 'category': category.name,
        if (limit != null) 'limit': '$limit',
        if (offset != null) 'offset': '$offset',
      },
    );
    final response = await _httpClient.get(
      uri,
      headers: await _getRequestHeaders(),
    );
    final body = response.json();

    if (response.statusCode != HttpStatus.ok) {
      throw FlutterNewsExampleApiRequestFailure(
        body: body,
        statusCode: response.statusCode,
      );
    }

    return FeedResponse.fromJson(body);
  }

  /// GET /api/v1/categories
  /// Requests the available news categories.
  Future<CategoriesResponse> getCategories() async {
    final uri = Uri.parse('$_baseUrl/api/v1/categories');
    final response = await _httpClient.get(
      uri,
      headers: await _getRequestHeaders(),
    );
    final body = response.json();

    if (response.statusCode != HttpStatus.ok) {
      throw FlutterNewsExampleApiRequestFailure(
        body: body,
        statusCode: response.statusCode,
      );
    }

    return CategoriesResponse.fromJson(body);
  }

  /// GET /api/v1/users/me
  /// Requests the current user.
  Future<CurrentUserResponse> getCurrentUser() async {
    final uri = Uri.parse('$_baseUrl/api/v1/users/me');
    final response = await _httpClient.get(
      uri,
      headers: await _getRequestHeaders(),
    );
    final body = response.json();

    if (response.statusCode != HttpStatus.ok) {
      throw FlutterNewsExampleApiRequestFailure(
        body: body,
        statusCode: response.statusCode,
      );
    }

    return CurrentUserResponse.fromJson(body);
  }

  /// GET /api/v1/search/popular
  /// Requests current, popular content.
  Future<PopularSearchResponse> popularSearch() async {
    final uri = Uri.parse('$_baseUrl/api/v1/search/popular');
    final response = await _httpClient.get(
      uri,
      headers: await _getRequestHeaders(),
    );
    final body = response.json();

    if (response.statusCode != HttpStatus.ok) {
      throw FlutterNewsExampleApiRequestFailure(
        body: body,
        statusCode: response.statusCode,
      );
    }

    return PopularSearchResponse.fromJson(body);
  }

  /// GET /api/v1/search/relevant?q=term
  /// Requests relevant content based on the provided search [term].
  Future<RelevantSearchResponse> relevantSearch({required String term}) async {
    final uri = Uri.parse('$_baseUrl/api/v1/search/relevant').replace(
      queryParameters: <String, String>{'q': term},
    );
    final response = await _httpClient.get(
      uri,
      headers: await _getRequestHeaders(),
    );
    final body = response.json();

    if (response.statusCode != HttpStatus.ok) {
      throw FlutterNewsExampleApiRequestFailure(
        body: body,
        statusCode: response.statusCode,
      );
    }

    return RelevantSearchResponse.fromJson(body);
  }

  /// POST /api/v1/newsletter/subscription
  /// Subscribes the provided [email] to the newsletter.
  Future<void> subscribeToNewsletter({required String email}) async {
    final uri = Uri.parse('$_baseUrl/api/v1/newsletter/subscription');
    final response = await _httpClient.post(
      uri,
      headers: await _getRequestHeaders(),
      body: json.encode(<String, String>{'email': email}),
    );

    if (response.statusCode != HttpStatus.created) {
      throw FlutterNewsExampleApiRequestFailure(
        body: const <String, dynamic>{},
        statusCode: response.statusCode,
      );
    }
  }

  /// POST /api/v1/subscriptions
  /// Creates a new subscription for the associated user.
  Future<void> createSubscription({
    required String subscriptionId,
  }) async {
    final uri = Uri.parse('$_baseUrl/api/v1/subscriptions').replace(
      queryParameters: <String, String>{'subscriptionId': subscriptionId},
    );
    final response = await _httpClient.post(
      uri,
      headers: await _getRequestHeaders(),
    );

    if (response.statusCode != HttpStatus.created) {
      throw FlutterNewsExampleApiRequestFailure(
        body: const <String, dynamic>{},
        statusCode: response.statusCode,
      );
    }
  }

  /// GET /api/v1/subscriptions
  /// Requests a list of all available subscriptions.
  Future<SubscriptionsResponse> getSubscriptions() async {
    final uri = Uri.parse('$_baseUrl/api/v1/subscriptions');
    final response = await _httpClient.get(uri);
    final body = response.json();

    if (response.statusCode != HttpStatus.ok) {
      throw FlutterNewsExampleApiRequestFailure(
        body: const <String, dynamic>{},
        statusCode: response.statusCode,
      );
    }

    return SubscriptionsResponse.fromJson(body);
  }

  Future<Map<String, String>> _getRequestHeaders() async {
    final token = await _tokenProvider();
    return <String, String>{
      HttpHeaders.contentTypeHeader: ContentType.json.value,
      HttpHeaders.acceptHeader: ContentType.json.value,
      if (token != null) HttpHeaders.authorizationHeader: 'Bearer $token',
    };
  }
}

extension on http.Response {
  Map<String, dynamic> json() {
    try {
      final decodedBody = utf8.decode(bodyBytes);
      return jsonDecode(decodedBody) as Map<String, dynamic>;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        FlutterNewsExampleApiMalformedResponse(error: error),
        stackTrace,
      );
    }
  }
}
