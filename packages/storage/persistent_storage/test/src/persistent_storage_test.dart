import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:persistent_storage/persistent_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storage/storage.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  const mockKey = 'mock-key';
  const mockValue = 'mock-value';
  final mockException = Exception('oops');

  group('PersistentStorage', () {
    late SharedPreferences sharedPreferences;
    late PersistentStorage persistentStorage;

    setUp(() {
      sharedPreferences = MockSharedPreferences();
      persistentStorage = PersistentStorage(
        sharedPreferences: sharedPreferences,
      );
    });

    group('read', () {
      test(
          'returns value '
          'when SharedPreferences.getString returns successfully', () async {
        when(() => sharedPreferences.getString(any())).thenReturn(mockValue);
        final actualValue = await persistentStorage.read(key: mockKey);
        expect(actualValue, mockValue);
      });

      test(
          'returns null '
          'when sharedPreferences.getString returns null', () async {
        when(() => sharedPreferences.getString(any())).thenReturn(null);
        final actualValue = await persistentStorage.read(key: mockKey);
        expect(actualValue, isNull);
      });

      test(
          'throws a StorageException '
          'when sharedPreferences.getString fails', () async {
        when(() => sharedPreferences.getString(any())).thenThrow(mockException);

        expect(
          () => persistentStorage.read(key: mockKey),
          throwsA(
            isA<StorageException>().having(
              (exception) => exception.error,
              'error',
              equals(mockException),
            ),
          ),
        );
      });
    });

    group('write', () {
      test(
          'completes '
          'when sharedPreferences.setString completes', () async {
        when(() => sharedPreferences.setString(any(), any()))
            .thenAnswer((_) async => true);
        expect(
          persistentStorage.write(key: mockKey, value: mockValue),
          completes,
        );
      });

      test(
          'throws a StorageException '
          'when sharedPreferences.setString fails', () async {
        when(() => sharedPreferences.setString(any(), any()))
            .thenThrow(mockException);
        expect(
          () => persistentStorage.write(key: mockKey, value: mockValue),
          throwsA(
            isA<StorageException>().having(
              (exception) => exception.error,
              'error',
              equals(mockException),
            ),
          ),
        );
      });
    });

    group('delete', () {
      test(
          'completes '
          'when sharedPreferences.remove completes', () async {
        when(() => sharedPreferences.remove(any()))
            .thenAnswer((_) async => true);
        expect(
          persistentStorage.delete(key: mockKey),
          completes,
        );
      });

      test(
          'throws a StorageException '
          'when sharedPreferences.remove fails', () async {
        when(() => sharedPreferences.remove(any())).thenThrow(mockException);
        expect(
          () => persistentStorage.delete(key: mockKey),
          throwsA(
            isA<StorageException>().having(
              (exception) => exception.error,
              'error',
              equals(mockException),
            ),
          ),
        );
      });
    });

    group('clear', () {
      test(
          'completes '
          'when sharedPreferences.clear completes', () async {
        when(sharedPreferences.clear).thenAnswer((_) async => true);
        expect(persistentStorage.clear(), completes);
      });

      test(
          'throws a StorageException '
          'when sharedPreferences.clear fails', () async {
        when(sharedPreferences.clear).thenThrow(mockException);
        expect(
          persistentStorage.clear,
          throwsA(
            isA<StorageException>().having(
              (exception) => exception.error,
              'error',
              equals(mockException),
            ),
          ),
        );
      });
    });
  });
}
