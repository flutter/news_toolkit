// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/notification_preferences/notification_preferences.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_repository/news_repository.dart';
import 'package:notification_preferences_repository/notification_preferences_repository.dart';

class MockNotificationPreferencesRepository extends Mock
    implements NotificationPreferencesRepository {}

void main() {
  final categories = {Category.business, Category.entertainment};
  final initialState =
      NotificationPreferencesState.initial(categories: categories);
  final notificationPreferencesRepository =
      MockNotificationPreferencesRepository();

  group('NotificationPreferencesBloc', () {
    group(' on NotificationPreferencesToggled ', () {
      when(
        () => notificationPreferencesRepository.setCategoriesPreferences(any()),
      ).thenAnswer((_) async {});

      blocTest<NotificationPreferencesBloc, NotificationPreferencesState>(
        'emits [loading, success, loading, success] '
        'when toggled category twice ',
        build: () => NotificationPreferencesBloc(
          categories: categories,
          notificationPreferencesRepository: notificationPreferencesRepository,
        ),
        seed: () => initialState,
        act: (bloc) => bloc
          ..add(
            NotificationPreferencesToggled(
              category: Category.business,
            ),
          )
          ..add(
            NotificationPreferencesToggled(
              category: Category.business,
            ),
          ),
        expect: () => <NotificationPreferencesState>[
          initialState.copyWith(
            status: NotificationPreferencesStatus.loading,
          ),
          initialState.copyWith(
            selectedCategories: Set.from(categories)..remove(Category.business),
            status: NotificationPreferencesStatus.success,
          ),
          initialState.copyWith(
            selectedCategories: Set.from(categories)..remove(Category.business),
            status: NotificationPreferencesStatus.loading,
          ),
          initialState.copyWith(
            selectedCategories: categories,
            status: NotificationPreferencesStatus.success,
          ),
        ],
      );
    });
  });
}
