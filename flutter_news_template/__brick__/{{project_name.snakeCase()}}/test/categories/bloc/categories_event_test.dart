// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:{{project_name.snakeCase()}}/categories/categories.dart';
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
        final event1 = CategorySelected(category: Category.top);
        final event2 = CategorySelected(category: Category.top);

        expect(event1, equals(event2));
      });
    });
  });
}
