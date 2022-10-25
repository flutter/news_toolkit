// ignore_for_file: prefer_const_constructors

import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/categories/categories.dart';
import 'package:google_news_template/notification_preferences/notification_preferences.dart';
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

  group('NotificationPreferencesPage', () {
    const populatedState = CategoriesState(
      status: CategoriesStatus.populated,
      categories: [Category.business, Category.entertainment],
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
      const notificationState = NotificationPreferencesState(
        selectedCategories: {Category.business},
        status: NotificationPreferencesStatus.success,
        categories: {
          Category.business,
          Category.entertainment,
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
      const notificationState = NotificationPreferencesState(
        selectedCategories: {Category.business},
        status: NotificationPreferencesStatus.success,
        categories: {Category.business},
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
          CategoriesPreferenceToggled(category: Category.business),
        ),
      ).called(1);
    });
  });
}
