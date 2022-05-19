// ignore_for_file: prefer_const_constructors

import 'package:google_news_template_api/api.dart';
import 'package:test/test.dart';

void main() {
  group('PopularSearchResponse', () {
    test('can be (de)serialized', () {
      final response = PopularSearchResponse(
        articles: const [],
        topics: const [],
      );

      expect(
        PopularSearchResponse.fromJson(response.toJson()),
        equals(response),
      );
    });
  });
}
