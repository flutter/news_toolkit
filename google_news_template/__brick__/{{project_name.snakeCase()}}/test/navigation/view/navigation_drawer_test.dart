// ignore_for_file: prefer_const_constructors

import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:{{project_name.snakeCase()}}/app/app.dart';
import 'package:{{project_name.snakeCase()}}/categories/categories.dart';
import 'package:{{project_name.snakeCase()}}/navigation/navigation.dart';
import 'package:in_app_purchase_repository/in_app_purchase_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_repository/news_repository.dart';
import 'package:user_repository/user_repository.dart';

import '../../helpers/helpers.dart';

class MockCategoriesBloc extends MockBloc<CategoriesEvent, CategoriesState>
    implements CategoriesBloc {}

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

class MockUser extends Mock implements User {}

const _scaffoldKey = Key('__scaffold__');

extension on WidgetTester {
  Future<void> pumpDrawer({
    required CategoriesBloc categoriesBloc,
    required AppBloc appBloc,
  }) async {
    await pumpApp(
      MultiBlocProvider(
        providers: [
          BlocProvider.value(
            value: categoriesBloc,
          ),
          BlocProvider.value(
            value: appBloc,
          )
        ],
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
    late AppBloc appBloc;
    late User user;

    const categories = [Category.top, Category.health];

    setUp(() {
      categoriesBloc = MockCategoriesBloc();
      appBloc = MockAppBloc();
      user = MockUser();

      when(() => categoriesBloc.state).thenReturn(
        CategoriesState.initial().copyWith(categories: categories),
      );

      when(() => user.subscriptionPlan).thenReturn(SubscriptionPlan.none);
      when(() => appBloc.state).thenReturn(AppState.authenticated(user));
    });

    testWidgets('renders Drawer', (tester) async {
      await tester.pumpDrawer(
        categoriesBloc: categoriesBloc,
        appBloc: appBloc,
      );
      expect(find.byType(Drawer), findsOneWidget);
    });

    testWidgets('renders AppLogo', (tester) async {
      await tester.pumpDrawer(
        categoriesBloc: categoriesBloc,
        appBloc: appBloc,
      );
      expect(find.byType(AppLogo), findsOneWidget);
    });

    testWidgets('renders NavigationDrawerSections', (tester) async {
      await tester.pumpDrawer(
        categoriesBloc: categoriesBloc,
        appBloc: appBloc,
      );
      expect(find.byType(NavigationDrawerSections), findsOneWidget);
    });

    testWidgets(
        'renders NavigationDrawerSubscribe '
        'when user is not subscribed', (tester) async {
      final user = MockUser();
      when(() => user.subscriptionPlan).thenReturn(SubscriptionPlan.none);
      when(() => appBloc.state).thenReturn(
        AppState.authenticated(user),
      );
      await tester.pumpDrawer(
        categoriesBloc: categoriesBloc,
        appBloc: appBloc,
      );
      expect(find.byType(NavigationDrawerSubscribe), findsOneWidget);
    });

    testWidgets(
        'does not render NavigationDrawerSubscribe '
        'when user is subscribed', (tester) async {
      final user = MockUser();
      when(() => user.subscriptionPlan).thenReturn(SubscriptionPlan.premium);
      when(() => appBloc.state).thenReturn(
        AppState.authenticated(user),
      );
      await tester.pumpDrawer(
        categoriesBloc: categoriesBloc,
        appBloc: appBloc,
      );
      expect(find.byType(NavigationDrawerSubscribe), findsNothing);
    });

    group('when NavigationDrawerSectionItem is tapped', () {
      testWidgets('closes drawer', (tester) async {
        await tester.pumpDrawer(
          categoriesBloc: categoriesBloc,
          appBloc: appBloc,
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
          appBloc: appBloc,
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
