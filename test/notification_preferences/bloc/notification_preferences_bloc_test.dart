// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/notification_preferences/notification_preferences.dart';
import 'package:news_repository/news_repository.dart';

void main() {
  final categories = [Category.business, Category.entertainment];
  final initialState =
      NotificationPreferencesState.initial(categories: categories);
  final initialToggles = {for (final category in categories) category: false};

  group('NotificationPreferencesBloc', () {
    group(' on NotificationPreferencesToggled ', () {
      blocTest<NotificationPreferencesBloc, NotificationPreferencesState>(
        'emits [loading, success, loading, success] '
        'when toggled category twice ',
        build: () => NotificationPreferencesBloc(categories: categories),
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
            togglesState: Map.from(initialToggles)
              ..update(Category.business, (value) => true),
            status: NotificationPreferencesStatus.success,
          ),
          initialState.copyWith(
            togglesState: Map.from(initialToggles)
              ..update(Category.business, (value) => true),
            status: NotificationPreferencesStatus.loading,
          ),
          initialState.copyWith(
            togglesState: initialToggles,
            status: NotificationPreferencesStatus.success,
          ),
        ],
      );
    });
  });
}
