// ignore_for_file: prefer_const_constructors

import 'package:{{project_name.snakeCase()}}/categories/categories.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_repository/news_repository.dart';

void main() {
  group('CategoriesState', () {
    test('initial has correct status', () {
      expect(
        CategoriesState.initial().status,
        equals(CategoriesStatus.initial),
      );
    });

    test('supports value comparisons', () {
      expect(
        CategoriesState.initial(),
        equals(CategoriesState.initial()),
      );
    });

    group('copyWith', () {
      test(
          'returns same object '
          'when no properties are passed', () {
        expect(
          CategoriesState.initial().copyWith(),
          equals(CategoriesState.initial()),
        );
      });

      test(
          'returns object with updated status '
          'when status is passed', () {
        expect(
          CategoriesState.initial().copyWith(
            status: CategoriesStatus.loading,
          ),
          equals(
            CategoriesState(
              status: CategoriesStatus.loading,
            ),
          ),
        );
      });

      test(
          'returns object with updated categories '
          'when categories is passed', () {
        final categories = [Category.top, Category.health];

        expect(
          CategoriesState(status: CategoriesStatus.populated)
              .copyWith(categories: categories),
          equals(
            CategoriesState(
              status: CategoriesStatus.populated,
              categories: categories,
            ),
          ),
        );
      });

      test(
          'returns object with updated selectedCategory '
          'when selectedCategory is passed', () {
        const selectedCategory = Category.top;

        expect(
          CategoriesState(status: CategoriesStatus.populated)
              .copyWith(selectedCategory: selectedCategory),
          equals(
            CategoriesState(
              status: CategoriesStatus.populated,
              selectedCategory: selectedCategory,
            ),
          ),
        );
      });
    });
  });
}
