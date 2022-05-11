// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/categories/categories.dart';

void main() {
  group('CategoriesEvent', () {
    group('CategoriesRequested', () {
      test('supports value comparisons', () {
        final event1 = CategoriesRequested();
        final event2 = CategoriesRequested();

        expect(event1, equals(event2));
      });
    });
  });
}
