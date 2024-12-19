// ignore_for_file: prefer_const_constructors

import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_example/categories/categories.dart';
import 'package:flutter_news_example/notification_preferences/notification_preferences.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_repository/news_repository.dart';
import 'package:notifications_repository/notifications_repository.dart';

import '../../helpers/helpers.dart';

class MockNotificationPreferencesBloc extends Mock
    implements NotificationPreferencesBloc {}

class MockNotificationPreferencesRepository extends Mock
    implements NotificationsRepository {}

class MockCategoriesBloc extends Mock implements CategoriesBloc {}

void main() {
  final NotificationPreferencesBloc bloc = MockNotificationPreferencesBloc();
  final NotificationsRepository repository =
      MockNotificationPreferencesRepository();
  final CategoriesBloc categoryBloc = MockCategoriesBloc();

  final entertainmentCategory = Category(
    id: 'entertainment',
    name: 'Entertainment',
  );
  final healthCategory = Category(id: 'health', name: 'Health');

  group('NotificationPreferencesPage', () {
    final populatedState = CategoriesState(
      status: CategoriesStatus.populated,
      categories: [entertainmentCategory, healthCategory],
    );

    test('has a route', () {
      expect(
        NotificationPreferencesPage.route(),
        isA<MaterialPageRoute<void>>(),
      );
    });

    testWidgets('renders NotificationPreferencesView', (tester) async {
      whenListen(
        categoryBloc,
        Stream.value(populatedState),
        initialState: populatedState,
      );

      await tester.pumpApp(
        RepositoryProvider.value(
          value: repository,
          child: BlocProvider.value(
            value: categoryBloc,
            child: const NotificationPreferencesPage(),
          ),
        ),
      );

      expect(find.byType(NotificationPreferencesView), findsOneWidget);
    });
  });

  group('NotificationPreferencesView', () {
    testWidgets('renders AppSwitch with state value', (tester) async {
      final notificationState = NotificationPreferencesState(
        selectedCategories: {entertainmentCategory},
        status: NotificationPreferencesStatus.success,
        categories: {
          entertainmentCategory,
          healthCategory,
        },
      );

      whenListen(
        bloc,
        Stream.value(notificationState),
        initialState: notificationState,
      );

      await tester.pumpApp(
        BlocProvider.value(
          value: bloc,
          child: const NotificationPreferencesView(),
        ),
      );

      final appSwitch = find.byType(AppSwitch).first;
      final appSwitchWidget = tester.firstWidget<AppSwitch>(appSwitch);

      expect(appSwitchWidget.value, true);

      final appSwitch2 = find.byType(AppSwitch).last;
      final appSwitchWidget2 = tester.firstWidget<AppSwitch>(appSwitch2);

      expect(appSwitchWidget2.value, false);
    });

    testWidgets(
        'adds CategoriesPreferenceToggled to NotificationPreferencesBloc '
        'on AppSwitch toggled', (tester) async {
      final notificationState = NotificationPreferencesState(
        selectedCategories: {entertainmentCategory},
        status: NotificationPreferencesStatus.success,
        categories: {entertainmentCategory},
      );

      whenListen(
        bloc,
        Stream.value(notificationState),
        initialState: notificationState,
      );

      await tester.pumpApp(
        BlocProvider.value(
          value: bloc,
          child: const NotificationPreferencesView(),
        ),
      );

      await tester.tap(find.byType(AppSwitch));

      verify(
        () => bloc.add(
          CategoriesPreferenceToggled(category: entertainmentCategory),
        ),
      ).called(1);
    });
  });
}
