// ignore_for_file: prefer_const_constructors

import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/categories/categories.dart';
import 'package:google_news_template/navigation/navigation.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_repository/news_repository.dart';

import '../../helpers/helpers.dart';

class MockCategoriesBloc extends MockBloc<CategoriesEvent, CategoriesState>
    implements CategoriesBloc {}

const _scaffoldKey = Key('__scaffold__');

extension on WidgetTester {
  Future<void> pumpDrawer({
    required CategoriesBloc categoriesBloc,
  }) async {
    await pumpApp(
      BlocProvider.value(
        value: categoriesBloc,
        child: Scaffold(
          key: _scaffoldKey,
          drawer: NavigationDrawer(),
          body: Container(),
        ),
      ),
    );

    firstState<ScaffoldState>(find.byKey(_scaffoldKey)).openDrawer();
    await pumpAndSettle();
  }
}

void main() {
  group('NavigationDrawer', () {
    late CategoriesBloc categoriesBloc;

    const categories = [Category.top, Category.health];

    setUp(() {
      categoriesBloc = MockCategoriesBloc();
      when(() => categoriesBloc.state).thenReturn(
        CategoriesState.initial().copyWith(categories: categories),
      );
    });

    testWidgets('renders Drawer', (tester) async {
      await tester.pumpDrawer(
        categoriesBloc: categoriesBloc,
      );
      expect(find.byType(Drawer), findsOneWidget);
    });

    testWidgets('renders AppLogo', (tester) async {
      await tester.pumpDrawer(
        categoriesBloc: categoriesBloc,
      );
      expect(find.byType(AppLogo), findsOneWidget);
    });

    testWidgets('renders NavigationDrawerSections', (tester) async {
      await tester.pumpDrawer(
        categoriesBloc: categoriesBloc,
      );
      expect(find.byType(NavigationDrawerSections), findsOneWidget);
    });

    testWidgets('renders NavigationDrawerSubscribe', (tester) async {
      await tester.pumpDrawer(
        categoriesBloc: categoriesBloc,
      );
      expect(find.byType(NavigationDrawerSubscribe), findsOneWidget);
    });

    group('when NavigationDrawerSectionItem is tapped', () {
      testWidgets('closes drawer', (tester) async {
        await tester.pumpDrawer(
          categoriesBloc: categoriesBloc,
        );

        await tester.tap(
          find.byWidgetPredicate(
            (widget) =>
                widget is NavigationDrawerSectionItem &&
                widget.key == ValueKey(categories.first),
          ),
        );

        await tester.pump(kThemeAnimationDuration);

        final scaffoldState =
            tester.firstState<ScaffoldState>(find.byKey(_scaffoldKey));

        expect(scaffoldState.isDrawerOpen, isFalse);
      });

      testWidgets('adds CategorySelected to CategoriesBloc', (tester) async {
        final category = categories.first;

        await tester.pumpDrawer(
          categoriesBloc: categoriesBloc,
        );

        await tester.tap(
          find.byWidgetPredicate(
            (widget) =>
                widget is NavigationDrawerSectionItem &&
                widget.key == ValueKey(category),
          ),
        );

        await tester.pump(kThemeAnimationDuration);

        verify(() => categoriesBloc.add(CategorySelected(category: category)))
            .called(1);
      });
    });
  });
}
