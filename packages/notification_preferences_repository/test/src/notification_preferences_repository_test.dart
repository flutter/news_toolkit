// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:mocktail/mocktail.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:notification_preferences_repository/notification_preferences_repository.dart';
import 'package:storage/storage.dart';
import 'package:test/test.dart';

class MockStorage extends Mock implements Storage {}

void main() {
  group('NotificationPreferencesRepository', () {
    final storage = MockStorage();
    final notificationPreferencesRepository =
        NotificationPreferencesRepository(storage: storage);
    final storageException = StorageException('error');

    const categoriesPreferences = <Category>{
      Category.top,
      Category.technology,
    };

    setUp(() {
      when(() => storage.read(key: any(named: 'key')))
          .thenThrow(storageException);
      when(
        () => storage.write(
          key: any(named: 'key'),
          value: any(named: 'value'),
        ),
      ).thenThrow(storageException);
    });

    test('can be instantiated', () {
      expect(
        NotificationPreferencesRepository(storage: storage),
        isNotNull,
      );
    });

    group('fetchCategoriesPreferences', () {
      test(
          'returns categories preferences '
          'when read succeeds with encoded preferences', () async {
        when(() => storage.read(key: any(named: 'key'))).thenAnswer(
          (_) async => json.encode(
            categoriesPreferences.map((preference) => preference.name).toList(),
          ),
        );

        final actualPreferences = await notificationPreferencesRepository
            .fetchCategoriesPreferences();

        expect(actualPreferences, equals(categoriesPreferences));
      });

      test(
          'returns null '
          'when read succeeds with null', () async {
        when(() => storage.read(key: any(named: 'key')))
            .thenAnswer((_) async => null);

        final preferences = await notificationPreferencesRepository
            .fetchCategoriesPreferences();

        expect(preferences, isNull);
      });

      test(
          'throws FetchCategoriesPreferencesFailure '
          'when read fails', () async {
        when(() => storage.read(key: any(named: 'key')))
            .thenThrow(storageException);

        expect(
          notificationPreferencesRepository.fetchCategoriesPreferences,
          throwsA(isA<FetchCategoriesPreferencesFailure>()),
        );
      });
    });

    group('updateCategoriesPreferences', () {
      test(
          'succeeds '
          'when write succeeds with encoded preferences', () async {
        when(
          () => storage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          ),
        ).thenAnswer((_) async {});

        expect(
          notificationPreferencesRepository
              .updateCategoriesPreferences(categoriesPreferences),
          completes,
        );

        verify(
          () => storage.write(
            key: any(named: 'key'),
            value: json.encode(
              categoriesPreferences.map((category) => category.name).toList(),
            ),
          ),
        ).called(1);
      });

      test(
          'throws UpdateCategoriesPreferencesFailure '
          'when write fails', () async {
        expect(
          notificationPreferencesRepository
              .updateCategoriesPreferences(categoriesPreferences),
          throwsA(isA<UpdateCategoriesPreferencesFailure>()),
        );
      });
    });

    group('NotificationPreferencesFailure', () {
      final error = Exception('errorMessage');

      group('NotificationPreferencesFetchStarsFailure', () {
        test('has correct props', () {
          expect(FetchCategoriesPreferencesFailure(error).props, [error]);
        });
      });

      group('UpdateCategoriesPreferencesFailure', () {
        test('has correct props', () {
          expect(UpdateCategoriesPreferencesFailure(error).props, [error]);
        });
      });
    });
  });
}
