// ignore_for_file: prefer_const_constructors

import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/categories/categories.dart';
import 'package:google_news_template/feed/feed.dart';
import 'package:google_news_template/navigation/navigation.dart';
import 'package:google_news_template/user_profile/user_profile.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_blocks/news_blocks.dart';

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
        DividerHorizontalBlock(),
        SpacerBlock(spacing: Spacing.medium),
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

    testWidgets('renders AppBar with AppLogo', (tester) async {
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
          (widget) => widget is AppBar && widget.title is AppLogo,
        ),
        findsOneWidget,
      );
    });

    testWidgets('renders UserProfileButton', (tester) async {
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: categoriesBloc),
            BlocProvider.value(value: feedBloc),
          ],
          child: FeedView(),
        ),
      );
      expect(find.byType(UserProfileButton), findsOneWidget);
    });

    testWidgets('renders CategoryTabBar with CategoryTab for each category',
        (tester) async {
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: categoriesBloc),
            BlocProvider.value(value: feedBloc),
          ],
          child: FeedView(),
        ),
      );

      expect(find.byType(CategoriesTabBar), findsOneWidget);

      for (final category in categories) {
        expect(
          find.descendant(
            of: find.byType(CategoriesTabBar),
            matching: find.byWidgetPredicate(
              (widget) =>
                  widget is CategoryTab && widget.categoryName == category.name,
            ),
          ),
          findsOneWidget,
        );
      }
    });

    testWidgets(
        'renders NavigationDrawer '
        'when menu icon is tapped', (tester) async {
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: categoriesBloc),
            BlocProvider.value(value: feedBloc),
          ],
          child: FeedView(),
        ),
      );

      expect(find.byType(NavigationDrawer), findsNothing);

      await tester.tap(find.byIcon(Icons.menu));
      await tester.pump();

      expect(find.byType(NavigationDrawer), findsOneWidget);
    });

    testWidgets('renders TabBarView', (tester) async {
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: categoriesBloc),
            BlocProvider.value(value: feedBloc),
          ],
          child: FeedView(),
        ),
      );

      expect(find.byType(TabBarView), findsOneWidget);
      expect(find.byType(CategoryFeed), findsOneWidget);
    });
  });
}
