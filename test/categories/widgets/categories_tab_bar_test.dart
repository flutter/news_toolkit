// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/categories/categories.dart';
import 'package:news_blocks/news_blocks.dart';

import '../../helpers/helpers.dart';

void main() {
  group('CategoriesTabBar', () {
    testWidgets('has correct preferredSize', (tester) async {
      expect(
        CategoriesTabBar(
          controller: TabController(length: 0, vsync: tester),
          tabs: const [],
        ).preferredSize,
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

      final tabController = TabController(length: tabs.length, vsync: tester);

      await tester.pumpApp(
        CategoriesTabBar(
          controller: tabController,
          tabs: tabs,
        ),
      );

      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is TabBar &&
              widget.controller == tabController &&
              widget.isScrollable == true,
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
