// ignore_for_file: prefer_const_constructors

import 'package:google_news_template_api/api.dart';
import 'package:test/test.dart';

void main() {
  group('CategoriesResponse', () {
    test('can be (de)serialized', () {
      final response = CategoriesResponse(
        categories: const [Category.business, Category.entertainment],
      );

      expect(CategoriesResponse.fromJson(response.toJson()), equals(response));
    });
  });
}
