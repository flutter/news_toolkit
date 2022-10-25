import 'dart:convert';

import 'package:{{project_name.snakeCase()}}_api/client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notifications_repository/notifications_repository.dart';
import 'package:storage/storage.dart';
import 'package:test/test.dart';

class MockStorage extends Mock implements Storage {}

void main() {
  group('NotificationsStorage', () {
    late Storage storage;

    setUp(() {
      storage = MockStorage();

      when(
        () => storage.write(
          key: any(named: 'key'),
          value: any(named: 'value'),
        ),
      ).thenAnswer((_) async {});
    });

    group('setNotificationsEnabled', () {
      test('saves the value in Storage', () async {
        const enabled = true;

        await NotificationsStorage(storage: storage)
            .setNotificationsEnabled(enabled: enabled);

        verify(
          () => storage.write(
            key: NotificationsStorageKeys.notificationsEnabled,
            value: enabled.toString(),
          ),
        ).called(1);
      });
    });

    group('fetchNotificationsEnabled', () {
      test('returns the value from Storage', () async {
        when(
          () =>
              storage.read(key: NotificationsStorageKeys.notificationsEnabled),
        ).thenAnswer((_) async => 'true');

        final result = await NotificationsStorage(storage: storage)
            .fetchNotificationsEnabled();

        verify(
          () => storage.read(
            key: NotificationsStorageKeys.notificationsEnabled,
          ),
        ).called(1);

        expect(result, isTrue);
      });

      test('returns false when no value exists in Storage', () async {
        when(
          () =>
              storage.read(key: NotificationsStorageKeys.notificationsEnabled),
        ).thenAnswer((_) async => null);

        final result = await NotificationsStorage(storage: storage)
            .fetchNotificationsEnabled();

        verify(
          () => storage.read(
            key: NotificationsStorageKeys.notificationsEnabled,
          ),
        ).called(1);

        expect(result, isFalse);
      });
    });

    group('setCategoriesPreferences', () {
      test('saves the value in Storage', () async {
        const preferences = {
          Category.top,
          Category.health,
        };

        await NotificationsStorage(storage: storage).setCategoriesPreferences(
          categories: preferences,
        );

        verify(
          () => storage.write(
            key: NotificationsStorageKeys.categoriesPreferences,
            value: json.encode(
              preferences.map((category) => category.name).toList(),
            ),
          ),
        ).called(1);
      });
    });

    group('fetchCategoriesPreferences', () {
      test('returns the value from Storage', () async {
        const preferences = {
          Category.health,
          Category.entertainment,
        };

        when(
          () =>
              storage.read(key: NotificationsStorageKeys.categoriesPreferences),
        ).thenAnswer(
          (_) async => json.encode(
            preferences.map((preference) => preference.name).toList(),
          ),
        );

        final result = await NotificationsStorage(storage: storage)
            .fetchCategoriesPreferences();

        verify(
          () => storage.read(
            key: NotificationsStorageKeys.categoriesPreferences,
          ),
        ).called(1);

        expect(result, equals(preferences));
      });

      test('returns null when no value exists in Storage', () async {
        when(
          () =>
              storage.read(key: NotificationsStorageKeys.categoriesPreferences),
        ).thenAnswer((_) async => null);

        final result = await NotificationsStorage(storage: storage)
            .fetchCategoriesPreferences();

        verify(
          () => storage.read(
            key: NotificationsStorageKeys.categoriesPreferences,
          ),
        ).called(1);

        expect(result, isNull);
      });
    });
  });
}
