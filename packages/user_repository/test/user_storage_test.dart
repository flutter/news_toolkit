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

        await UserStorage(storage: storage).setAppOpenedCount(count: value);

        verify(
          () => storage.write(
            key: UserStorageKeys.appOpenedCount,
            value: value.toString(),
          ),
        ).called(1);
      });
    });

    group('fetchNumberOfTimesAppOpened', () {
      test('returns the value from Storage', () async {
        const value = 1;
        when(
          () => storage.read(key: UserStorageKeys.appOpenedCount),
        ).thenAnswer((_) async => 1.toString());

        final result =
            await UserStorage(storage: storage).fetchAppOpenedCount();

        verify(
          () => storage.read(
            key: UserStorageKeys.appOpenedCount,
          ),
        ).called(1);

        expect(result, value);
      });

      test('returns 0 when no value exists in UserStorage', () async {
        when(
          () => storage.read(key: UserStorageKeys.appOpenedCount),
        ).thenAnswer((_) async => null);

        final result =
            await UserStorage(storage: storage).fetchAppOpenedCount();

        verify(
          () => storage.read(
            key: UserStorageKeys.appOpenedCount,
          ),
        ).called(1);

        expect(result, 0);
      });
    });
  });
}
