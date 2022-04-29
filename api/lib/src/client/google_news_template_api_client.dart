import 'dart:convert';
import 'dart:io';

import 'package:google_news_template_api/client.dart';
import 'package:http/http.dart' as http;

/// {@template google_news_template_api_malformed_response}
/// An exception thrown when there is a problem decoded the response body.
/// {@endtemplate}
class GoogleNewsTemplateApiMalformedResponse implements Exception {
  /// {@macro google_news_template_api_malformed_response}
  const GoogleNewsTemplateApiMalformedResponse({required this.error});

  /// The associated error.
  final Object error;
}

/// {@template google_news_template_api_request_failure}
/// An exception thrown when an http request failure occurs.
/// {@endtemplate}
class GoogleNewsTemplateApiRequestFailure implements Exception {
  /// {@macro google_news_template_api_request_failure}
  const GoogleNewsTemplateApiRequestFailure({
    required this.statusCode,
    required this.body,
  });

  /// The associated http status code.
  final int statusCode;

  /// The associated response body.
  final Map<String, dynamic> body;
}

/// {@template google_news_template_api_client}
/// A Dart API client for the Google News Template API.
/// {@endtemplate}
class GoogleNewsTemplateApiClient {
  /// Create an instance of [GoogleNewsTemplateApiClient] that integrates
  /// with the remote API.
  ///
  /// {@macro google_news_template_api_client}
  GoogleNewsTemplateApiClient({http.Client? httpClient})
      : this._(
          baseUrl: 'https://google-news-template-api-q66trdlzja-uc.a.run.app',
          httpClient: httpClient,
        );

  /// Create an instance of [GoogleNewsTemplateApiClient] that integrates
  /// with a local instance of the API (http://localhost:8080).
  ///
  /// {@macro google_news_template_api_client}
  GoogleNewsTemplateApiClient.localhost({http.Client? httpClient})
      : this._(
          baseUrl: 'http://localhost:8080',
          httpClient: httpClient,
        );

  /// {@macro google_news_template_api_client}
  GoogleNewsTemplateApiClient._({
    required String baseUrl,
    http.Client? httpClient,
  })  : _baseUrl = baseUrl,
        _httpClient = httpClient ?? http.Client();

  final String _baseUrl;
  final http.Client _httpClient;

  /// GET /api/v1/feed
  /// Requests news feed metadata.
  Future<FeedResponse> getFeed() async {
    final uri = Uri.parse('$_baseUrl/api/v1/feed');
    final response = await _httpClient.get(uri);
    final body = response.json();

    if (response.statusCode != HttpStatus.ok) {
      throw GoogleNewsTemplateApiRequestFailure(
        body: body,
        statusCode: response.statusCode,
      );
    }

    return FeedResponse.fromJson(body);
  }
}

extension on http.Response {
  Map<String, dynamic> json() {
    try {
      return jsonDecode(body) as Map<String, dynamic>;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        GoogleNewsTemplateApiMalformedResponse(error: error),
        stackTrace,
      );
    }
  }
}
