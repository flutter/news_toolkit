// ignore_for_file: prefer_const_constructors

import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:{{project_name.snakeCase()}}/app/app.dart';
import 'package:{{project_name.snakeCase()}}/categories/categories.dart';
import 'package:{{project_name.snakeCase()}}/home/home.dart';
import 'package:{{project_name.snakeCase()}}/navigation/navigation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_purchase_repository/in_app_purchase_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_repository/news_repository.dart';
import 'package:user_repository/user_repository.dart';

import '../../helpers/helpers.dart';

class MockCategoriesBloc extends MockBloc<CategoriesEvent, CategoriesState>
    implements CategoriesBloc {}

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

class MockUser extends Mock implements User {}

class MockHomeCubit extends MockCubit<HomeState> implements HomeCubit {}

const _scaffoldKey = Key('__scaffold__');

extension on WidgetTester {
  Future<void> pumpDrawer({
    required CategoriesBloc categoriesBloc,
    required AppBloc appBloc,
    required HomeCubit homeCubit,
  }) async {
    await pumpApp(
      MultiBlocProvider(
        providers: [
          BlocProvider.value(
            value: categoriesBloc,
          ),
          BlocProvider.value(
            value: appBloc,
          ),
          BlocProvider.value(
            value: homeCubit,
          ),
        ],
        child: Scaffold(
          key: _scaffoldKey,
          drawer: NavDrawer(),
          body: Container(),
        ),
      ),
    );

    firstState<ScaffoldState>(find.byKey(_scaffoldKey)).openDrawer();
    await pumpAndSettle();
  }
}

void main() {
  group('NavDrawer', () {
    late CategoriesBloc categoriesBloc;
    late AppBloc appBloc;
    late HomeCubit homeCubit;
    late User user;

    const categories = [Category.top, Category.health];

    setUp(() {
      categoriesBloc = MockCategoriesBloc();
      appBloc = MockAppBloc();
      homeCubit = MockHomeCubit();
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
        homeCubit: homeCubit,
      );
      expect(find.byType(Drawer), findsOneWidget);
    });

    testWidgets('renders AppLogo', (tester) async {
      await tester.pumpDrawer(
        categoriesBloc: categoriesBloc,
        appBloc: appBloc,
        homeCubit: homeCubit,
      );
      expect(find.byType(AppLogo), findsOneWidget);
    });

    testWidgets('renders NavDrawerSections', (tester) async {
      await tester.pumpDrawer(
        categoriesBloc: categoriesBloc,
        appBloc: appBloc,
        homeCubit: homeCubit,
      );
      expect(find.byType(NavDrawerSections), findsOneWidget);
    });

    testWidgets(
        'renders NavDrawerSubscribe '
        'when user is not subscribed', (tester) async {
      final user = MockUser();
      when(() => user.subscriptionPlan).thenReturn(SubscriptionPlan.none);
      when(() => appBloc.state).thenReturn(
        AppState.authenticated(user),
      );
      await tester.pumpDrawer(
        categoriesBloc: categoriesBloc,
        appBloc: appBloc,
        homeCubit: homeCubit,
      );
      expect(find.byType(NavDrawerSubscribe), findsOneWidget);
    });

    testWidgets(
        'does not render NavDrawerSubscribe '
        'when user is subscribed', (tester) async {
      final user = MockUser();
      when(() => user.subscriptionPlan).thenReturn(SubscriptionPlan.premium);
      when(() => appBloc.state).thenReturn(
        AppState.authenticated(user),
      );
      await tester.pumpDrawer(
        categoriesBloc: categoriesBloc,
        appBloc: appBloc,
        homeCubit: homeCubit,
      );
      expect(find.byType(NavDrawerSubscribe), findsNothing);
    });

    group('when NavDrawerSectionItem is tapped', () {
      testWidgets('closes drawer', (tester) async {
        await tester.pumpDrawer(
          categoriesBloc: categoriesBloc,
          appBloc: appBloc,
          homeCubit: homeCubit,
        );

        await tester.tap(
          find.byWidgetPredicate(
            (widget) =>
                widget is NavDrawerSectionItem &&
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
          homeCubit: homeCubit,
        );

        await tester.tap(
          find.byWidgetPredicate(
            (widget) =>
                widget is NavDrawerSectionItem &&
                widget.key == ValueKey(category),
          ),
        );

        await tester.pump(kThemeAnimationDuration);

        verify(() => categoriesBloc.add(CategorySelected(category: category)))
            .called(1);
      });

      testWidgets(
        'sets tab to zero when NavDrawerSectionItem is tapped ',
        (tester) async {
          final category = categories.first;

          await tester.pumpDrawer(
            categoriesBloc: categoriesBloc,
            appBloc: appBloc,
            homeCubit: homeCubit,
          );

          await tester.tap(
            find.byWidgetPredicate(
              (widget) =>
                  widget is NavDrawerSectionItem &&
                  widget.key == ValueKey(category),
            ),
          );

          await tester.pump(kThemeAnimationDuration);

          verify(() => homeCubit.setTab(0)).called(1);
        },
      );
    });
  });
}
