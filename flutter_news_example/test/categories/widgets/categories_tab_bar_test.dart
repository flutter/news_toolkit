// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_news_example/categories/categories.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_repository/news_repository.dart';

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
      final sportsCategory = Category(id: 'sports', name: 'Sports');
      final healthCategory = Category(id: 'health', name: 'Health');

      final tabs = [
        CategoryTab(
          key: ValueKey(sportsCategory),
          categoryName: sportsCategory.name,
        ),
        CategoryTab(
          key: ValueKey(healthCategory),
          categoryName: healthCategory.name,
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
      final sportsCategory = Category(id: 'sports', name: 'Sports');

      await tester.pumpApp(
        CategoryTab(
          categoryName: sportsCategory.name,
        ),
      );

      expect(find.text(sportsCategory.name.toUpperCase()), findsOneWidget);
    });
  });
}
