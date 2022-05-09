import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';

/// {@template json_response}
/// A [Response] which includes a json response body.
/// {@endtemplate}
class JsonResponse extends Response {
  JsonResponse._({
    int statusCode = HttpStatus.ok,
    Map<String, dynamic>? body = const <String, dynamic>{},
    Map<String, String> headers = const <String, String>{},
  }) : super(
          statusCode,
          body: body != null ? json.encode(body) : null,
          headers: {
            ...headers,
            HttpHeaders.contentTypeHeader: ContentType.json.value,
          },
        );

  /// {@macro json_response}
  JsonResponse.ok({
    Map<String, dynamic> body = const <String, dynamic>{},
    Map<String, String> headers = const <String, String>{},
  }) : this._(statusCode: HttpStatus.ok, body: body, headers: headers);

  /// {@macro json_response}
  JsonResponse.noContent({
    Map<String, String> headers = const <String, String>{},
  }) : this._(
          statusCode: HttpStatus.noContent,
          body: null,
          headers: headers,
        );

  /// {@macro json_response}
  JsonResponse.created({
    Map<String, dynamic> body = const <String, dynamic>{},
    Map<String, String> headers = const <String, String>{},
  }) : this._(statusCode: HttpStatus.created, body: body, headers: headers);
}
