// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template_api/client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notifications_repository/notifications_repository.dart';
import 'package:permission_client/permission_client.dart';
import 'package:storage/storage.dart';

class MockPermissionClient extends Mock implements PermissionClient {}

class MockStorage extends Mock implements Storage {}

class MockFirebaseMessaging extends Mock implements FirebaseMessaging {}

class MockGoogleNewsTemplateApiClient extends Mock
    implements GoogleNewsTemplateApiClient {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('NotificationsRepository', () {
    late PermissionClient permissionClient;
    late Storage storage;
    late FirebaseMessaging firebaseMessaging;
    late GoogleNewsTemplateApiClient apiClient;

    setUp(() {
      permissionClient = MockPermissionClient();
      storage = MockStorage();
      firebaseMessaging = MockFirebaseMessaging();
      apiClient = MockGoogleNewsTemplateApiClient();

      when(permissionClient.notificationsStatus)
          .thenAnswer((_) async => PermissionStatus.denied);

      when(
        () => storage.read(key: StorageKeys.notificationsEnabled),
      ).thenAnswer((_) async => 'false');

      when(
        () => storage.read(key: StorageKeys.categoriesPreferences),
      ).thenAnswer((_) async => json.encode([Category.top.name]));

      when(
        () => storage.write(
          key: any(named: 'key'),
          value: any(named: 'value'),
        ),
      ).thenAnswer((_) async {});

      when(() => firebaseMessaging.subscribeToTopic(any()))
          .thenAnswer((_) async {});
      when(() => firebaseMessaging.unsubscribeFromTopic(any()))
          .thenAnswer((_) async {});

      when(apiClient.getCategories).thenAnswer(
        (_) async => CategoriesResponse(categories: []),
      );
    });

    group('constructor', () {
      test('can be instantiated', () {
        expect(
          NotificationsRepository(
            permissionClient: permissionClient,
            storage: storage,
            firebaseMessaging: firebaseMessaging,
            apiClient: apiClient,
          ),
          isNotNull,
        );
      });

      test(
          'initializes categories preferences '
          'from GoogleNewsTemplateApiClient.getCategories', () async {
        when(
          () => storage.read(key: StorageKeys.categoriesPreferences),
        ).thenAnswer((_) async => null);

        final completer = Completer<void>();
        const categories = [Category.top, Category.technology];

        when(apiClient.getCategories).thenAnswer(
          (_) async => CategoriesResponse(categories: categories),
        );

        when(
          () => storage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          ),
        ).thenAnswer((_) async => completer.complete());

        final _ = NotificationsRepository(
          permissionClient: permissionClient,
          storage: storage,
          firebaseMessaging: firebaseMessaging,
          apiClient: apiClient,
        );

        await expectLater(completer.future, completes);

        verify(
          () => storage.write(
            key: any(named: 'key'),
            value: json.encode(
              categories.map((category) => category.name).toList(),
            ),
          ),
        ).called(1);
      });

      test(
          'throws an InitializeCategoriesPreferencesFailure '
          'when initialization fails', () async {
        Object? caughtError;
        await runZonedGuarded(() async {
          when(
            () => storage.read(key: StorageKeys.categoriesPreferences),
          ).thenThrow(Exception());

          final _ = NotificationsRepository(
            permissionClient: permissionClient,
            storage: storage,
            firebaseMessaging: firebaseMessaging,
            apiClient: apiClient,
          );
        }, (error, stackTrace) {
          caughtError = error;
        });

        expect(
          caughtError,
          isA<InitializeCategoriesPreferencesFailure>(),
        );
      });
    });

    group('toggleNotifications', () {
      group('when enable is true', () {
        test(
            'calls openPermissionSettings on PermissionClient '
            'when PermissionStatus is permanentlyDenied', () async {
          when(permissionClient.notificationsStatus)
              .thenAnswer((_) async => PermissionStatus.permanentlyDenied);

          when(permissionClient.openPermissionSettings)
              .thenAnswer((_) async => true);

          await NotificationsRepository(
            permissionClient: permissionClient,
            storage: storage,
            firebaseMessaging: firebaseMessaging,
            apiClient: apiClient,
          ).toggleNotifications(enable: true);

          verify(permissionClient.openPermissionSettings).called(1);
        });

        test(
            'calls openPermissionSettings on PermissionClient '
            'when PermissionStatus is restricted', () async {
          when(permissionClient.notificationsStatus)
              .thenAnswer((_) async => PermissionStatus.restricted);

          when(permissionClient.openPermissionSettings)
              .thenAnswer((_) async => true);

          await NotificationsRepository(
            permissionClient: permissionClient,
            storage: storage,
            firebaseMessaging: firebaseMessaging,
            apiClient: apiClient,
          ).toggleNotifications(enable: true);

          verify(permissionClient.openPermissionSettings).called(1);
        });

        test(
            'calls requestNotifications on PermissionClient '
            'when PermissionStatus is denied', () async {
          when(permissionClient.requestNotifications)
              .thenAnswer((_) async => PermissionStatus.granted);

          when(permissionClient.notificationsStatus)
              .thenAnswer((_) async => PermissionStatus.denied);

          await NotificationsRepository(
            permissionClient: permissionClient,
            storage: storage,
            firebaseMessaging: firebaseMessaging,
            apiClient: apiClient,
          ).toggleNotifications(enable: true);

          verify(permissionClient.requestNotifications).called(1);
        });

        test('subscribes to categories preferences', () async {
          const categoriesPreferences = {
            Category.top,
            Category.technology,
          };

          when(
            () => storage.read(key: StorageKeys.categoriesPreferences),
          ).thenAnswer(
            (_) async => json.encode(
              categoriesPreferences
                  .map((preference) => preference.name)
                  .toList(),
            ),
          );

          when(permissionClient.notificationsStatus)
              .thenAnswer((_) async => PermissionStatus.granted);

          await NotificationsRepository(
            permissionClient: permissionClient,
            storage: storage,
            firebaseMessaging: firebaseMessaging,
            apiClient: apiClient,
          ).toggleNotifications(enable: true);

          for (final category in categoriesPreferences) {
            verify(() => firebaseMessaging.subscribeToTopic(category.name))
                .called(1);
          }
        });

        test(
            'sets the notifications enabled value to true '
            'in Storage', () async {
          when(permissionClient.notificationsStatus)
              .thenAnswer((_) async => PermissionStatus.granted);

          await NotificationsRepository(
            permissionClient: permissionClient,
            storage: storage,
            firebaseMessaging: firebaseMessaging,
            apiClient: apiClient,
          ).toggleNotifications(enable: true);

          verify(
            () => storage.write(
              key: any(named: 'key'),
              value: true.toString(),
            ),
          ).called(1);
        });
      });

      group('when enabled is false', () {
        test('unsubscribes from categories preferences', () async {
          const categoriesPreferences = {
            Category.top,
            Category.technology,
          };

          when(
            () => storage.read(key: StorageKeys.categoriesPreferences),
          ).thenAnswer(
            (_) async => json.encode(
              categoriesPreferences
                  .map((preference) => preference.name)
                  .toList(),
            ),
          );

          await NotificationsRepository(
            permissionClient: permissionClient,
            storage: storage,
            firebaseMessaging: firebaseMessaging,
            apiClient: apiClient,
          ).toggleNotifications(enable: false);

          for (final category in categoriesPreferences) {
            verify(() => firebaseMessaging.unsubscribeFromTopic(category.name))
                .called(1);
          }
        });

        test(
            'sets the notifications enabled value to false '
            'in Storage', () async {
          await NotificationsRepository(
            permissionClient: permissionClient,
            storage: storage,
            firebaseMessaging: firebaseMessaging,
            apiClient: apiClient,
          ).toggleNotifications(enable: false);

          verify(
            () => storage.write(
              key: any(named: 'key'),
              value: false.toString(),
            ),
          ).called(1);
        });
      });

      test(
          'throws a ToggleNotificationsFailure '
          'when toggling notifications fails', () async {
        when(permissionClient.notificationsStatus).thenThrow(Exception());

        expect(
          () => NotificationsRepository(
            permissionClient: permissionClient,
            storage: storage,
            firebaseMessaging: firebaseMessaging,
            apiClient: apiClient,
          ).toggleNotifications(enable: true),
          throwsA(isA<ToggleNotificationsFailure>()),
        );
      });
    });

    group('fetchNotificationsEnabled', () {
      test(
          'returns true '
          'when the notification permission is granted '
          'and the notification setting is enabled', () async {
        when(permissionClient.notificationsStatus)
            .thenAnswer((_) async => PermissionStatus.granted);
        when(
          () => storage.read(key: StorageKeys.notificationsEnabled),
        ).thenAnswer((_) async => 'true');

        final result = await NotificationsRepository(
          permissionClient: permissionClient,
          storage: storage,
          firebaseMessaging: firebaseMessaging,
          apiClient: apiClient,
        ).fetchNotificationsEnabled();

        expect(result, isTrue);
      });

      test(
          'returns false '
          'when the notification permission is not granted '
          'and the notification setting is enabled', () async {
        when(permissionClient.notificationsStatus)
            .thenAnswer((_) async => PermissionStatus.denied);
        when(
          () => storage.read(key: StorageKeys.notificationsEnabled),
        ).thenAnswer((_) async => 'true');

        final result = await NotificationsRepository(
          permissionClient: permissionClient,
          storage: storage,
          firebaseMessaging: firebaseMessaging,
          apiClient: apiClient,
        ).fetchNotificationsEnabled();

        expect(result, isFalse);
      });

      test(
          'returns false '
          'when the notification permission is not granted '
          'and the notification setting is disabled', () async {
        when(permissionClient.notificationsStatus)
            .thenAnswer((_) async => PermissionStatus.denied);
        when(
          () => storage.read(key: StorageKeys.notificationsEnabled),
        ).thenAnswer((_) async => 'false');

        final result = await NotificationsRepository(
          permissionClient: permissionClient,
          storage: storage,
          firebaseMessaging: firebaseMessaging,
          apiClient: apiClient,
        ).fetchNotificationsEnabled();

        expect(result, isFalse);
      });

      test(
          'returns false '
          'when the notification permission is granted '
          'and the notification setting is disabled', () async {
        when(permissionClient.notificationsStatus)
            .thenAnswer((_) async => PermissionStatus.granted);
        when(
          () => storage.read(key: StorageKeys.notificationsEnabled),
        ).thenAnswer((_) async => 'false');

        final result = await NotificationsRepository(
          permissionClient: permissionClient,
          storage: storage,
          firebaseMessaging: firebaseMessaging,
          apiClient: apiClient,
        ).fetchNotificationsEnabled();

        expect(result, isFalse);
      });

      test(
          'throws a FetchNotificationsEnabledFailure '
          'when fetching notifications enabled fails', () async {
        when(permissionClient.notificationsStatus).thenThrow(Exception());

        expect(
          NotificationsRepository(
            permissionClient: permissionClient,
            storage: storage,
            firebaseMessaging: firebaseMessaging,
            apiClient: apiClient,
          ).fetchNotificationsEnabled(),
          throwsA(isA<FetchNotificationsEnabledFailure>()),
        );
      });
    });

    group('setCategoriesPreferences', () {
      const categoriesPreferences = {
        Category.top,
        Category.technology,
      };

      test('sets categories preferences in Storage', () async {
        when(
          () => storage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          ),
        ).thenAnswer((_) async {});

        await expectLater(
          NotificationsRepository(
            permissionClient: permissionClient,
            storage: storage,
            firebaseMessaging: firebaseMessaging,
            apiClient: apiClient,
          ).setCategoriesPreferences(categoriesPreferences),
          completes,
        );

        verify(
          () => storage.write(
            key: StorageKeys.categoriesPreferences,
            value: json.encode(
              categoriesPreferences.map((category) => category.name).toList(),
            ),
          ),
        ).called(1);
      });

      test('unsubscribes from previous categories preferences', () async {
        const previousCategoriesPreferences = {
          Category.health,
          Category.entertainment,
        };

        when(
          () => storage.read(key: StorageKeys.categoriesPreferences),
        ).thenAnswer(
          (_) async => json.encode(
            previousCategoriesPreferences
                .map((preference) => preference.name)
                .toList(),
          ),
        );

        await NotificationsRepository(
          permissionClient: permissionClient,
          storage: storage,
          firebaseMessaging: firebaseMessaging,
          apiClient: apiClient,
        ).setCategoriesPreferences(categoriesPreferences);

        for (final category in previousCategoriesPreferences) {
          verify(() => firebaseMessaging.unsubscribeFromTopic(category.name))
              .called(1);
        }
      });

      test(
          'subscribes to categories preferences '
          'when notifications are enabled', () async {
        when(
          () => storage.read(key: StorageKeys.categoriesPreferences),
        ).thenAnswer(
          (_) async => json.encode(
            categoriesPreferences.map((preference) => preference.name).toList(),
          ),
        );

        when(permissionClient.notificationsStatus)
            .thenAnswer((_) async => PermissionStatus.granted);
        when(
          () => storage.read(key: StorageKeys.notificationsEnabled),
        ).thenAnswer((_) async => 'true');

        await NotificationsRepository(
          permissionClient: permissionClient,
          storage: storage,
          firebaseMessaging: firebaseMessaging,
          apiClient: apiClient,
        ).setCategoriesPreferences(categoriesPreferences);

        for (final category in categoriesPreferences) {
          verify(() => firebaseMessaging.subscribeToTopic(category.name))
              .called(1);
        }
      });

      test(
          'throws a SetCategoriesPreferencesFailure '
          'when setting categories preferences fails', () async {
        when(
          () => storage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          ),
        ).thenThrow(Exception());

        expect(
          NotificationsRepository(
            permissionClient: permissionClient,
            storage: storage,
            firebaseMessaging: firebaseMessaging,
            apiClient: apiClient,
          ).setCategoriesPreferences(categoriesPreferences),
          throwsA(isA<SetCategoriesPreferencesFailure>()),
        );
      });
    });

    group('fetchCategoriesPreferences', () {
      const categoriesPreferences = {
        Category.top,
        Category.technology,
      };

      test(
          'returns categories preferences '
          'when read succeeds with encoded preferences', () async {
        when(
          () => storage.read(key: StorageKeys.categoriesPreferences),
        ).thenAnswer(
          (_) async => json.encode(
            categoriesPreferences.map((preference) => preference.name).toList(),
          ),
        );

        final actualPreferences = await NotificationsRepository(
          permissionClient: permissionClient,
          storage: storage,
          firebaseMessaging: firebaseMessaging,
          apiClient: apiClient,
        ).fetchCategoriesPreferences();

        expect(actualPreferences, equals(categoriesPreferences));
      });

      test(
          'returns null '
          'when read succeeds with null', () async {
        when(
          () => storage.read(key: StorageKeys.categoriesPreferences),
        ).thenAnswer((_) async => null);

        final preferences = await NotificationsRepository(
          permissionClient: permissionClient,
          storage: storage,
          firebaseMessaging: firebaseMessaging,
          apiClient: apiClient,
        ).fetchCategoriesPreferences();

        expect(preferences, isNull);
      });

      test(
          'throws a FetchCategoriesPreferencesFailure '
          'when read fails', () async {
        final notificationsRepository = NotificationsRepository(
          permissionClient: permissionClient,
          storage: storage,
          firebaseMessaging: firebaseMessaging,
          apiClient: apiClient,
        );

        when(
          () => storage.read(key: StorageKeys.categoriesPreferences),
        ).thenThrow(StorageException(Error()));

        expect(
          notificationsRepository.fetchCategoriesPreferences,
          throwsA(isA<FetchCategoriesPreferencesFailure>()),
        );
      });
    });
  });

  group('NotificationsFailure', () {
    final error = Exception('errorMessage');

    group('InitializeCategoriesPreferencesFailure', () {
      test('has correct props', () {
        expect(InitializeCategoriesPreferencesFailure(error).props, [error]);
      });
    });

    group('ToggleNotificationsFailure', () {
      test('has correct props', () {
        expect(ToggleNotificationsFailure(error).props, [error]);
      });
    });

    group('FetchNotificationsEnabledFailure', () {
      test('has correct props', () {
        expect(FetchNotificationsEnabledFailure(error).props, [error]);
      });
    });

    group('SetCategoriesPreferencesFailure', () {
      test('has correct props', () {
        expect(SetCategoriesPreferencesFailure(error).props, [error]);
      });
    });

    group('FetchCategoriesPreferencesFailure', () {
      test('has correct props', () {
        expect(FetchCategoriesPreferencesFailure(error).props, [error]);
      });
    });
  });
}
