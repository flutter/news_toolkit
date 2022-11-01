// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:flutter_news_example_api/client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notifications_client/notifications_client.dart';
import 'package:notifications_repository/notifications_repository.dart';
import 'package:permission_client/permission_client.dart';
import 'package:storage/storage.dart';

class MockPermissionClient extends Mock implements PermissionClient {}

class MockNotificationsStorage extends Mock implements NotificationsStorage {}

class MockNotificationsClient extends Mock implements NotificationsClient {}

class MockFlutterNewsExampleApiClient extends Mock
    implements FlutterNewsExampleApiClient {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('NotificationsRepository', () {
    late PermissionClient permissionClient;
    late NotificationsStorage storage;
    late NotificationsClient notificationsClient;
    late FlutterNewsExampleApiClient apiClient;

    setUp(() {
      permissionClient = MockPermissionClient();
      storage = MockNotificationsStorage();
      notificationsClient = MockNotificationsClient();
      apiClient = MockFlutterNewsExampleApiClient();

      when(permissionClient.notificationsStatus)
          .thenAnswer((_) async => PermissionStatus.denied);

      when(
        () => storage.setNotificationsEnabled(
          enabled: any(named: 'enabled'),
        ),
      ).thenAnswer((_) async {});

      when(
        () => storage.setCategoriesPreferences(
          categories: any(named: 'categories'),
        ),
      ).thenAnswer((_) async {});

      when(storage.fetchNotificationsEnabled).thenAnswer((_) async => false);

      when(storage.fetchCategoriesPreferences)
          .thenAnswer((_) async => {Category.top});

      when(() => notificationsClient.subscribeToCategory(any()))
          .thenAnswer((_) async {});
      when(() => notificationsClient.unsubscribeFromCategory(any()))
          .thenAnswer((_) async {});

      when(apiClient.getCategories).thenAnswer(
        (_) async => CategoriesResponse(categories: []),
      );
    });

    group('constructor', () {
      test(
          'initializes categories preferences '
          'from FlutterNewsExampleApiClient.getCategories', () async {
        when(storage.fetchCategoriesPreferences).thenAnswer((_) async => null);

        final completer = Completer<void>();
        const categories = [Category.top, Category.technology];

        when(apiClient.getCategories).thenAnswer(
          (_) async => CategoriesResponse(categories: categories),
        );

        when(
          () => storage.setCategoriesPreferences(
            categories: any(named: 'categories'),
          ),
        ).thenAnswer((_) async => completer.complete());

        final _ = NotificationsRepository(
          permissionClient: permissionClient,
          storage: storage,
          notificationsClient: notificationsClient,
          apiClient: apiClient,
        );

        await expectLater(completer.future, completes);

        verify(
          () => storage.setCategoriesPreferences(
            categories: categories.toSet(),
          ),
        ).called(1);
      });

      test(
          'throws an InitializeCategoriesPreferencesFailure '
          'when initialization fails', () async {
        Object? caughtError;
        await runZonedGuarded(() async {
          when(storage.fetchCategoriesPreferences).thenThrow(Exception());

          final _ = NotificationsRepository(
            permissionClient: permissionClient,
            storage: storage,
            notificationsClient: notificationsClient,
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
            notificationsClient: notificationsClient,
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
            notificationsClient: notificationsClient,
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
            notificationsClient: notificationsClient,
            apiClient: apiClient,
          ).toggleNotifications(enable: true);

          verify(permissionClient.requestNotifications).called(1);
        });

        test('subscribes to categories preferences', () async {
          const categoriesPreferences = {
            Category.top,
            Category.technology,
          };

          when(storage.fetchCategoriesPreferences)
              .thenAnswer((_) async => categoriesPreferences);

          when(permissionClient.notificationsStatus)
              .thenAnswer((_) async => PermissionStatus.granted);

          await NotificationsRepository(
            permissionClient: permissionClient,
            storage: storage,
            notificationsClient: notificationsClient,
            apiClient: apiClient,
          ).toggleNotifications(enable: true);

          for (final category in categoriesPreferences) {
            verify(() => notificationsClient.subscribeToCategory(category.name))
                .called(1);
          }
        });

        test(
            'calls setNotificationsEnabled with true '
            'on NotificationsStorage', () async {
          when(permissionClient.notificationsStatus)
              .thenAnswer((_) async => PermissionStatus.granted);

          await NotificationsRepository(
            permissionClient: permissionClient,
            storage: storage,
            notificationsClient: notificationsClient,
            apiClient: apiClient,
          ).toggleNotifications(enable: true);

          verify(
            () => storage.setNotificationsEnabled(enabled: true),
          ).called(1);
        });
      });

      group('when enabled is false', () {
        test('unsubscribes from categories preferences', () async {
          const categoriesPreferences = {
            Category.top,
            Category.technology,
          };

          when(storage.fetchCategoriesPreferences)
              .thenAnswer((_) async => categoriesPreferences);

          await NotificationsRepository(
            permissionClient: permissionClient,
            storage: storage,
            notificationsClient: notificationsClient,
            apiClient: apiClient,
          ).toggleNotifications(enable: false);

          for (final category in categoriesPreferences) {
            verify(
              () => notificationsClient.unsubscribeFromCategory(category.name),
            ).called(1);
          }
        });

        test(
            'calls setNotificationsEnabled with false '
            'on NotificationsStorage', () async {
          await NotificationsRepository(
            permissionClient: permissionClient,
            storage: storage,
            notificationsClient: notificationsClient,
            apiClient: apiClient,
          ).toggleNotifications(enable: false);

          verify(
            () => storage.setNotificationsEnabled(enabled: false),
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
            notificationsClient: notificationsClient,
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

        when(storage.fetchNotificationsEnabled).thenAnswer((_) async => true);

        final result = await NotificationsRepository(
          permissionClient: permissionClient,
          storage: storage,
          notificationsClient: notificationsClient,
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

        when(storage.fetchNotificationsEnabled).thenAnswer((_) async => true);

        final result = await NotificationsRepository(
          permissionClient: permissionClient,
          storage: storage,
          notificationsClient: notificationsClient,
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

        when(storage.fetchNotificationsEnabled).thenAnswer((_) async => false);

        final result = await NotificationsRepository(
          permissionClient: permissionClient,
          storage: storage,
          notificationsClient: notificationsClient,
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

        when(storage.fetchNotificationsEnabled).thenAnswer((_) async => false);

        final result = await NotificationsRepository(
          permissionClient: permissionClient,
          storage: storage,
          notificationsClient: notificationsClient,
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
            notificationsClient: notificationsClient,
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

      test('calls setCategoriesPreferences on NotificationsStorage', () async {
        when(
          () => storage.setCategoriesPreferences(
            categories: any(named: 'categories'),
          ),
        ).thenAnswer((_) async {});

        await expectLater(
          NotificationsRepository(
            permissionClient: permissionClient,
            storage: storage,
            notificationsClient: notificationsClient,
            apiClient: apiClient,
          ).setCategoriesPreferences(categoriesPreferences),
          completes,
        );

        verify(
          () => storage.setCategoriesPreferences(
            categories: categoriesPreferences,
          ),
        ).called(1);
      });

      test('unsubscribes from previous categories preferences', () async {
        const previousCategoriesPreferences = {
          Category.health,
          Category.entertainment,
        };

        when(storage.fetchCategoriesPreferences)
            .thenAnswer((_) async => previousCategoriesPreferences);

        await NotificationsRepository(
          permissionClient: permissionClient,
          storage: storage,
          notificationsClient: notificationsClient,
          apiClient: apiClient,
        ).setCategoriesPreferences(categoriesPreferences);

        for (final category in previousCategoriesPreferences) {
          verify(
            () => notificationsClient.unsubscribeFromCategory(category.name),
          ).called(1);
        }
      });

      test(
          'subscribes to categories preferences '
          'when notifications are enabled', () async {
        when(storage.fetchCategoriesPreferences)
            .thenAnswer((_) async => categoriesPreferences);

        when(storage.fetchNotificationsEnabled).thenAnswer((_) async => true);

        when(permissionClient.notificationsStatus)
            .thenAnswer((_) async => PermissionStatus.granted);

        await NotificationsRepository(
          permissionClient: permissionClient,
          storage: storage,
          notificationsClient: notificationsClient,
          apiClient: apiClient,
        ).setCategoriesPreferences(categoriesPreferences);

        for (final category in categoriesPreferences) {
          verify(() => notificationsClient.subscribeToCategory(category.name))
              .called(1);
        }
      });

      test(
          'throws a SetCategoriesPreferencesFailure '
          'when setting categories preferences fails', () async {
        when(
          () => storage.setCategoriesPreferences(
            categories: any(named: 'categories'),
          ),
        ).thenThrow(Exception());

        expect(
          NotificationsRepository(
            permissionClient: permissionClient,
            storage: storage,
            notificationsClient: notificationsClient,
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

      test('returns categories preferences from NotificationsStorage',
          () async {
        when(storage.fetchCategoriesPreferences)
            .thenAnswer((_) async => categoriesPreferences);

        final actualPreferences = await NotificationsRepository(
          permissionClient: permissionClient,
          storage: storage,
          notificationsClient: notificationsClient,
          apiClient: apiClient,
        ).fetchCategoriesPreferences();

        expect(actualPreferences, equals(categoriesPreferences));
      });

      test(
          'returns null '
          'when categories preferences do not exist in NotificationsStorage',
          () async {
        when(storage.fetchCategoriesPreferences).thenAnswer((_) async => null);

        final preferences = await NotificationsRepository(
          permissionClient: permissionClient,
          storage: storage,
          notificationsClient: notificationsClient,
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
          notificationsClient: notificationsClient,
          apiClient: apiClient,
        );

        when(storage.fetchCategoriesPreferences)
            .thenThrow(StorageException(Error()));

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
