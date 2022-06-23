part of 'user_repository.dart';

/// Storage keys for the [UserStorage].
abstract class UserStorageKeys {
  /// Number of times that an anonymous user opens the application.
  static const numberOfTimesAppOpened = '__number_of_times_app_opened_key__';
}

/// {@template user_storage}
/// Storage for the [UserRepository].
/// {@endtemplate}
class UserStorage {
  /// {@macro user_storage}
  const UserStorage({
    required Storage storage,
  }) : _storage = storage;

  final Storage _storage;

  /// Sets the number of times app opened.
  ///
  /// Adds one to the exisiting value.
  Future<void> setNumberOfTimesAppOpened({required int value}) =>
      _storage.write(
        key: UserStorageKeys.numberOfTimesAppOpened,
        value: value.toString(),
      );

  /// Fetches the number of times app opened value from Storage.
  Future<String> fetchNumberOfTimesAppOpened() async =>
      await _storage.read(key: UserStorageKeys.numberOfTimesAppOpened) ?? '0';
}
