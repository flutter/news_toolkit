// ignore_for_file: prefer_const_constructors

import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:{{project_name.snakeCase()}}/categories/categories.dart';
import 'package:{{project_name.snakeCase()}}/navigation/navigation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_repository/news_repository.dart';

import '../../helpers/helpers.dart';

class MockCategoriesBloc extends MockBloc<CategoriesEvent, CategoriesState>
    implements CategoriesBloc {}

void main() {
  group('NavDrawerSections', () {
    late CategoriesBloc categoriesBloc;

    const categories = [Category.top, Category.health];
    final selectedCategory = categories.first;

    setUp(() {
      categoriesBloc = MockCategoriesBloc();
      when(() => categoriesBloc.state).thenReturn(
        CategoriesState.initial().copyWith(
          categories: categories,
          selectedCategory: selectedCategory,
        ),
      );
    });

    testWidgets('renders NavDrawerSectionsTitle', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: categoriesBloc,
          child: NavDrawerSections(),
        ),
      );
      expect(find.byType(NavDrawerSectionsTitle), findsOneWidget);
    });

    testWidgets(
        'renders NavDrawerSectionItem '
        'for each category', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: categoriesBloc,
          child: NavDrawerSections(),
        ),
      );

      for (final category in categories) {
        expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is NavDrawerSectionItem &&
                widget.key == ValueKey(category) &&
                widget.selected == (category == selectedCategory),
          ),
          findsOneWidget,
        );
      }
    });

    group('NavDrawerSectionItem', () {
      testWidgets('renders ListTile with title', (tester) async {
        const title = 'title';
        await tester.pumpApp(
          NavDrawerSectionItem(
            title: title,
          ),
        );
        expect(find.widgetWithText(ListTile, title), findsOneWidget);
      });

      testWidgets('calls onTap when tapped', (tester) async {
        var tapped = false;
        await tester.pumpApp(
          NavDrawerSectionItem(
            title: 'title',
            onTap: () => tapped = true,
          ),
        );

        await tester.tap(find.byType(NavDrawerSectionItem));

        expect(tapped, isTrue);
      });

      testWidgets('has correct selected color', (tester) async {
        await tester.pumpApp(
          NavDrawerSectionItem(
            title: 'title',
            selected: true,
            onTap: () {},
          ),
        );

        final tile = tester.widget<ListTile>(find.byType(ListTile));

        expect(
          tile.selectedTileColor,
          equals(AppColors.white.withOpacity(0.08)),
        );

        expect(
          (tile.title! as Text).style?.color,
          equals(AppColors.highEmphasisPrimary),
        );
      });
    });
  });
}
