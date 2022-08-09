// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide Spacer;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:{{project_name.snakeCase()}}/categories/categories.dart';
import 'package:{{project_name.snakeCase()}}/feed/feed.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_blocks_ui/news_blocks_ui.dart';

import '../../helpers/helpers.dart';

class MockFeedBloc extends MockBloc<FeedEvent, FeedState> implements FeedBloc {}

class MockCategoriesBloc extends MockBloc<CategoriesEvent, CategoriesState>
    implements CategoriesBloc {}

void main() {
  group('FeedView', () {
    late CategoriesBloc categoriesBloc;
    late FeedBloc feedBloc;

    const categories = [Category.top, Category.technology];

    final feed = <Category, List<NewsBlock>>{
      Category.top: [
        SectionHeaderBlock(title: 'Top'),
        SpacerBlock(spacing: Spacing.medium),
        SpacerBlock(spacing: Spacing.extraLarge),
        SpacerBlock(spacing: Spacing.extraLarge),
        SpacerBlock(spacing: Spacing.extraLarge),
        SpacerBlock(spacing: Spacing.extraLarge),
        SpacerBlock(spacing: Spacing.extraLarge),
        SpacerBlock(spacing: Spacing.extraLarge),
        SpacerBlock(spacing: Spacing.extraLarge),
        SpacerBlock(spacing: Spacing.extraLarge),
        SpacerBlock(spacing: Spacing.extraLarge),
        SpacerBlock(spacing: Spacing.extraLarge),
        SpacerBlock(spacing: Spacing.extraLarge),
        DividerHorizontalBlock(),
      ],
      Category.technology: [
        SectionHeaderBlock(title: 'Technology'),
        DividerHorizontalBlock(),
        SpacerBlock(spacing: Spacing.medium),
      ],
    };

    setUp(() {
      categoriesBloc = MockCategoriesBloc();
      feedBloc = MockFeedBloc();

      when(() => categoriesBloc.state).thenReturn(
        CategoriesState(
          categories: categories,
          status: CategoriesStatus.populated,
        ),
      );

      when(() => feedBloc.state).thenReturn(
        FeedState(
          feed: feed,
          status: FeedStatus.populated,
        ),
      );
    });

    testWidgets(
        'renders empty feed '
        'when categories are empty', (tester) async {
      when(() => categoriesBloc.state).thenReturn(
        CategoriesState(
          categories: const [],
          status: CategoriesStatus.populated,
        ),
      );

      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: categoriesBloc),
            BlocProvider.value(value: feedBloc),
          ],
          child: FeedView(),
        ),
      );

      expect(find.byKey(Key('feedView_empty')), findsOneWidget);
      expect(find.byType(FeedViewPopulated), findsNothing);
    });

    testWidgets(
        'renders FeedViewPopulated '
        'when categories are available', (tester) async {
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: categoriesBloc),
            BlocProvider.value(value: feedBloc),
          ],
          child: FeedView(),
        ),
      );

      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is FeedViewPopulated && widget.categories == categories,
        ),
        findsOneWidget,
      );
      expect(find.byKey(Key('feedView_empty')), findsNothing);
    });

    group('FeedViewPopulated', () {
      testWidgets('renders CategoryTabBar with CategoryTab for each category',
          (tester) async {
        await tester.pumpApp(
          MultiBlocProvider(
            providers: [
              BlocProvider.value(value: categoriesBloc),
              BlocProvider.value(value: feedBloc),
            ],
            child: FeedViewPopulated(categories: categories),
          ),
        );

        expect(find.byType(CategoriesTabBar), findsOneWidget);

        for (final category in categories) {
          expect(
            find.descendant(
              of: find.byType(CategoriesTabBar),
              matching: find.byWidgetPredicate(
                (widget) =>
                    widget is CategoryTab &&
                    widget.categoryName == category.name,
              ),
            ),
            findsOneWidget,
          );
        }
      });

      testWidgets('renders TabBarView', (tester) async {
        await tester.pumpApp(
          MultiBlocProvider(
            providers: [
              BlocProvider.value(value: categoriesBloc),
              BlocProvider.value(value: feedBloc),
            ],
            child: FeedViewPopulated(categories: categories),
          ),
        );

        expect(find.byType(TabBarView), findsOneWidget);
        expect(find.byType(CategoryFeed), findsOneWidget);
      });

      testWidgets(
          'adds CategorySelected to CategoriesBloc '
          'when CategoryTab is tapped', (tester) async {
        final selectedCategory = categories[1];

        await tester.pumpApp(
          MultiBlocProvider(
            providers: [
              BlocProvider.value(value: categoriesBloc),
              BlocProvider.value(value: feedBloc),
            ],
            child: FeedViewPopulated(categories: categories),
          ),
        );

        final categoryTab = find.byWidgetPredicate(
          (widget) =>
              widget is CategoryTab &&
              widget.categoryName == selectedCategory.name,
        );

        await tester.ensureVisible(categoryTab);
        await tester.tap(categoryTab);
        await tester.pump(kTabScrollDuration);

        verify(
          () => categoriesBloc.add(
            CategorySelected(category: selectedCategory),
          ),
        ).called(1);
      });

      testWidgets(
          'animates to CategoryFeed in TabBarView '
          'when selectedCategory changes', (tester) async {
        final categoriesStateController =
            StreamController<CategoriesState>.broadcast();

        final categoriesState = CategoriesState(
          categories: categories,
          status: CategoriesStatus.populated,
        );

        whenListen(
          categoriesBloc,
          categoriesStateController.stream,
          initialState: categoriesState,
        );

        final defaultCategory = categories.first;
        final selectedCategory = categories[1];

        await tester.pumpApp(
          MultiBlocProvider(
            providers: [
              BlocProvider.value(value: categoriesBloc),
              BlocProvider.value(value: feedBloc),
            ],
            child: FeedViewPopulated(categories: categories),
          ),
        );

        Finder findCategoryFeed(Category category) => find.byWidgetPredicate(
              (widget) => widget is CategoryFeed && widget.category == category,
            );

        expect(findCategoryFeed(defaultCategory), findsOneWidget);
        expect(findCategoryFeed(selectedCategory), findsNothing);

        categoriesStateController.add(
          categoriesState.copyWith(selectedCategory: selectedCategory),
        );

        await tester.pump(kTabScrollDuration);
        await tester.pump(kTabScrollDuration);

        expect(findCategoryFeed(defaultCategory), findsNothing);
        expect(findCategoryFeed(selectedCategory), findsOneWidget);
      });

      testWidgets(
        'scrolls to the top of CategoryFeed on double tap on CategoryTab',
        (tester) async {
          await tester.pumpApp(
            MultiBlocProvider(
              providers: [
                BlocProvider.value(value: categoriesBloc),
                BlocProvider.value(value: feedBloc),
              ],
              child: FeedViewPopulated(categories: categories),
            ),
          );

          expect(
            find.byType(DividerHorizontal),
            findsNothing,
          );
          expect(
            find.text('Top'),
            findsOneWidget,
          );

          await tester.dragUntilVisible(
            find.byType(DividerHorizontal),
            find.byType(FeedViewPopulated),
            Offset(0, -100),
            duration: Duration.zero,
          );

          expect(
            find.byType(DividerHorizontal),
            findsOneWidget,
          );

          final tab = find.widgetWithText(
            CategoryTab,
            categories.first.name.toUpperCase(),
          );

          await tester.tap(tab);
          await tester.pump(kDoubleTapMinTime);
          await tester.tap(tab);

          await tester.pump(Duration(milliseconds: 300));
          await tester.pump(Duration(milliseconds: 300));

          expect(
            find.byType(DividerHorizontal),
            findsNothing,
          );
          expect(
            find.text('Top'),
            findsOneWidget,
          );
        },
      );
    });
  });
}
