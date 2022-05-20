// ignore_for_file: prefer_const_constructors

import 'package:google_news_template_api/api.dart';
import 'package:test/test.dart';

void main() {
  group('RelevantSearchResponse', () {
    test('can be (de)serialized', () {
      final response = RelevantSearchResponse(
        articles: const [],
        topics: const [],
      );

      expect(
        RelevantSearchResponse.fromJson(response.toJson()),
        equals(response),
      );
    });
  });
}
