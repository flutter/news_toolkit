// ignore_for_file: prefer_const_constructors

import 'package:flutter_news_example/categories/categories.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_blocks/news_blocks.dart';

void main() {
  group('CategoriesEvent', () {
    group('CategoriesRequested', () {
      test('supports value comparisons', () {
        final event1 = CategoriesRequested();
        final event2 = CategoriesRequested();

        expect(event1, equals(event2));
      });
    });

    group('CategorySelected', () {
      test('supports value comparisons', () {
        final sportsCategory = Category(id: 'sports', name: 'Sports');

        final event1 = CategorySelected(category: sportsCategory);
        final event2 = CategorySelected(category: sportsCategory);

        expect(event1, equals(event2));
      });
    });
  });
}
