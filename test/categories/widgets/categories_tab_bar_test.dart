// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/categories/categories.dart';
import 'package:news_repository/news_repository.dart';

import '../../helpers/helpers.dart';

void main() {
  group('CategoriesTabBar', () {
    test('has correct preferredSize', () {
      expect(
        CategoriesTabBar(tabs: const []).preferredSize,
        equals(const Size(double.infinity, 48)),
      );
    });

    testWidgets('renders TabBar with tabs', (tester) async {
      final tabs = [
        CategoryTab(
          key: ValueKey(Category.top),
          categoryName: Category.top.name,
        ),
        CategoryTab(
          key: ValueKey(Category.technology),
          categoryName: Category.technology.name,
        ),
      ];

      await tester.pumpApp(
        DefaultTabController(
          length: tabs.length,
          child: CategoriesTabBar(tabs: tabs),
        ),
      );

      expect(
        find.byWidgetPredicate(
          (widget) => widget is TabBar && widget.isScrollable == true,
        ),
        findsOneWidget,
      );

      for (final tab in tabs) {
        expect(find.byWidget(tab), findsOneWidget);
      }
    });
  });

  group('CategoryTab', () {
    testWidgets('renders category name uppercased', (tester) async {
      await tester.pumpApp(
        CategoryTab(
          categoryName: Category.top.name,
        ),
      );

      expect(find.text(Category.top.name.toUpperCase()), findsOneWidget);
    });
  });
}
