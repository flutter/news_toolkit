part of 'user_repository.dart';

/// Storage keys for the [UserStorage].
abstract class UserStorageKeys {
  /// Number of times that a user opened the application.
  static const appOpenedCount = '__app_opened_count_key__';

  /// Number of overall articles views.
  static const overallArticlesViews = '__overall_articles_views_key__';
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

  /// Sets the number of times the app was opened.
  Future<void> setAppOpenedCount({required int count}) => _storage.write(
        key: UserStorageKeys.appOpenedCount,
        value: count.toString(),
      );

  /// Fetches the number of times the app was opened value from Storage.
  Future<int> fetchAppOpenedCount() async {
    final count = await _storage.read(key: UserStorageKeys.appOpenedCount);
    return int.parse(count ?? '0');
  }

  /// Sets the number of overall articles views.
  Future<void> setOverallArticlesViews(int count) => _storage.write(
        key: UserStorageKeys.overallArticlesViews,
        value: count.toString(),
      );

  /// Fetches the number of overall articles views value from Storage.
  Future<int> fetchOverallArticlesViews() async {
    final count =
        await _storage.read(key: UserStorageKeys.overallArticlesViews);
    return int.parse(count ?? '0');
  }
}
