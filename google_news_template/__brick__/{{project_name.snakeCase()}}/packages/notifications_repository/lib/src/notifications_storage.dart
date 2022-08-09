part of 'notifications_repository.dart';

/// Storage keys for the [NotificationsStorage].
abstract class NotificationsStorageKeys {
  /// Whether the notifications are enabled.
  static const notificationsEnabled = '__notifications_enabled_storage_key__';

  /// The list of user's categories preferences.
  static const categoriesPreferences = '__categories_preferences_storage_key__';
}

/// {@template notifications_storage}
/// Storage for the [NotificationsRepository].
/// {@endtemplate}
class NotificationsStorage {
  /// {@macro notifications_storage}
  const NotificationsStorage({
    required Storage storage,
  }) : _storage = storage;

  final Storage _storage;

  /// Sets the notifications enabled to [enabled] in Storage.
  Future<void> setNotificationsEnabled({required bool enabled}) =>
      _storage.write(
        key: NotificationsStorageKeys.notificationsEnabled,
        value: enabled.toString(),
      );

  /// Fetches the notifications enabled value from Storage.
  Future<bool> fetchNotificationsEnabled() async =>
      (await _storage.read(key: NotificationsStorageKeys.notificationsEnabled))
          ?.parseBool() ??
      false;

  /// Sets the categories preferences to [categories] in Storage.
  Future<void> setCategoriesPreferences({
    required Set<Category> categories,
  }) async {
    final categoriesEncoded = json.encode(
      categories.map((category) => category.name).toList(),
    );
    await _storage.write(
      key: NotificationsStorageKeys.categoriesPreferences,
      value: categoriesEncoded,
    );
  }

  /// Fetches the categories preferences value from Storage.
  Future<Set<Category>?> fetchCategoriesPreferences() async {
    final categories = await _storage.read(
      key: NotificationsStorageKeys.categoriesPreferences,
    );
    if (categories == null) {
      return null;
    }
    return List<String>.from(json.decode(categories) as List)
        .map(Category.fromString)
        .toSet();
  }
}

extension _BoolFromStringParsing on String {
  bool parseBool() {
    return toLowerCase() == 'true';
  }
}
