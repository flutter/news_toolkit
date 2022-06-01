// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/notification_preferences/notification_preferences.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_repository/news_repository.dart';
import 'package:notifications_repository/notifications_repository.dart';

class MockNotificationsRepository extends Mock
    implements NotificationsRepository {}

class MockNewsRepository extends Mock implements NewsRepository {}

void main() {
  final categories = {Category.business, Category.entertainment};
  final initialState = NotificationPreferencesState.initial();

  final notificationsRepository = MockNotificationsRepository();
  final newsRepository = MockNewsRepository();

  group('NotificationPreferencesBloc', () {
    group('on CategoriesPreferenceToggled ', () {
      blocTest<NotificationPreferencesBloc, NotificationPreferencesState>(
        'emits [loading, success, loading, success] '
        'with updated selectedCategories '
        'when toggled category twice ',
        setUp: () => when(
          () => notificationsRepository.setCategoriesPreferences(any()),
        ).thenAnswer((_) async {}),
        build: () => NotificationPreferencesBloc(
          newsRepository: newsRepository,
          notificationsRepository: notificationsRepository,
        ),
        seed: () => initialState,
        act: (bloc) => bloc
          ..add(CategoriesPreferenceToggled(category: Category.business))
          ..add(CategoriesPreferenceToggled(category: Category.business)),
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

      blocTest<NotificationPreferencesBloc, NotificationPreferencesState>(
        'emits [loading, failed] '
        'when toggled category '
        'and setCategoriesPreferences throws',
        setUp: () => when(
          () => notificationsRepository.setCategoriesPreferences(any()),
        ).thenThrow(Exception()),
        build: () => NotificationPreferencesBloc(
          newsRepository: newsRepository,
          notificationsRepository: notificationsRepository,
        ),
        seed: () => initialState,
        act: (bloc) =>
            bloc..add(CategoriesPreferenceToggled(category: Category.business)),
        expect: () => <NotificationPreferencesState>[
          initialState.copyWith(
            status: NotificationPreferencesStatus.loading,
          ),
          initialState.copyWith(
            status: NotificationPreferencesStatus.failure,
          ),
        ],
      );
    });

    group('on InitialCategoriesPreferencesRequested ', () {
      blocTest<NotificationPreferencesBloc, NotificationPreferencesState>(
        'emits [loading, success] '
        'with updated selectedCategories and categories ',
        setUp: () {
          when(
            notificationsRepository.fetchCategoriesPreferences,
          ).thenAnswer((_) async => {Category.business});
          when(newsRepository.getCategories).thenAnswer(
            (_) async => CategoriesResponse(
              categories: const [
                Category.business,
                Category.entertainment,
              ],
            ),
          );
        },
        build: () => NotificationPreferencesBloc(
          newsRepository: newsRepository,
          notificationsRepository: notificationsRepository,
        ),
        seed: () => initialState,
        act: (bloc) => bloc..add(InitialCategoriesPreferencesRequested()),
        expect: () => <NotificationPreferencesState>[
          initialState.copyWith(
            status: NotificationPreferencesStatus.loading,
          ),
          initialState.copyWith(
            selectedCategories: {Category.business},
            status: NotificationPreferencesStatus.success,
          ),
        ],
      );

      blocTest<NotificationPreferencesBloc, NotificationPreferencesState>(
        'emits [loading, failed] '
        'when fetchCategoriesPreferences throws',
        setUp: () => when(
          notificationsRepository.fetchCategoriesPreferences,
        ).thenThrow(Exception()),
        build: () => NotificationPreferencesBloc(
          newsRepository: newsRepository,
          notificationsRepository: notificationsRepository,
        ),
        seed: () => initialState,
        act: (bloc) => bloc..add(InitialCategoriesPreferencesRequested()),
        expect: () => <NotificationPreferencesState>[
          initialState.copyWith(
            status: NotificationPreferencesStatus.loading,
          ),
          initialState.copyWith(
            status: NotificationPreferencesStatus.failure,
          ),
        ],
      );
    });
  });
}
