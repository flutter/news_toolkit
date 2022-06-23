import 'package:mocktail/mocktail.dart';
import 'package:storage/storage.dart';
import 'package:test/test.dart';
import 'package:user_repository/user_repository.dart';

class MockStorage extends Mock implements Storage {}

void main() {
  group('UserStorage', () {
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

    group('setNumberOfTimesAppOpened', () {
      test('saves the value in Storage', () async {
        const value = 1;

        await UserStorage(storage: storage)
            .setNumberOfTimesAppOpened(value: value);

        verify(
          () => storage.write(
            key: UserStorageKeys.numberOfTimesAppOpened,
            value: value.toString(),
          ),
        ).called(1);
      });
    });

    group('fetchNumberOfTimesAppOpened', () {
      test('returns the value from Storage', () async {
        const value = '1';
        when(
          () => storage.read(key: UserStorageKeys.numberOfTimesAppOpened),
        ).thenAnswer((_) async => value);

        final result =
            await UserStorage(storage: storage).fetchNumberOfTimesAppOpened();

        verify(
          () => storage.read(
            key: UserStorageKeys.numberOfTimesAppOpened,
          ),
        ).called(1);

        expect(result, value);
      });

      test('returns 0 when no value exists in Storage', () async {
        when(
          () => storage.read(key: UserStorageKeys.numberOfTimesAppOpened),
        ).thenAnswer((_) async => null);

        final result =
            await UserStorage(storage: storage).fetchNumberOfTimesAppOpened();

        verify(
          () => storage.read(
            key: UserStorageKeys.numberOfTimesAppOpened,
          ),
        ).called(1);

        expect(result, '0');
      });
    });
  });
}
