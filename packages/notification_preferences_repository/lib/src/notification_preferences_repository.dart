import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:storage/storage.dart';

/// {@template notification_preferences_failure}
/// A base failure for the notification preferences repository failures.
/// {@endtemplate}
abstract class NotificationPreferencesFailure
    with EquatableMixin
    implements Exception {
  /// {@macro notification_preferences_failure}
  const NotificationPreferencesFailure(this.error);

  /// The error which was caught.
  final Object error;

  @override
  List<Object> get props => [error];
}

/// {@template fetch_categories_preferences_failure}
/// Thrown when fetching categories preferences fails.
/// {@endtemplate}
class FetchCategoriesPreferencesFailure extends NotificationPreferencesFailure {
  /// {@macro fetch_categories_preferences_failure}
  const FetchCategoriesPreferencesFailure(super.error);
}

/// {@template update_categories_preferences_failure}
/// Thrown when updating categories preferences fails.
/// {@endtemplate}
class SetCategoriesPreferencesFailure extends NotificationPreferencesFailure {
  /// {@macro update_categories_preferences_failure}
  const SetCategoriesPreferencesFailure(super.error);
}

/// {@template notification_preferences_repository}
/// A repository that manages notification preferences.
/// {@endtemplate}
class NotificationPreferencesRepository {
  /// {@macro notification_preferences_repository}
  const NotificationPreferencesRepository({
    required Storage storage,
  }) : _storage = storage;

  final Storage _storage;

  static const _categoriesPreferencesStorageKey = 'categories_preferences';

  /// Fetches the user's notification preferences for news categories.
  ///
  /// The result represents a set of categories the user has agreed to
  /// receive notifications from.
  ///
  /// Throws [FetchCategoriesPreferencesFailure] when fetching fails.
  Future<Set<Category>?> fetchCategoriesPreferences() async {
    try {
      final categories = await _storage.read(
        key: _categoriesPreferencesStorageKey,
      );
      if (categories == null) {
        return null;
      }
      return List<String>.from(json.decode(categories) as List)
          .map(Category.fromString)
          .toSet();
    } on StorageException catch (error, stackTrace) {
      Error.throwWithStackTrace(
        FetchCategoriesPreferencesFailure(error),
        stackTrace,
      );
    }
  }

  /// Updates the user's notification preferences for news categories.
  ///
  /// [categories] represents a set of categories the user has agreed to
  /// receive notifications from.
  ///
  /// Throws [SetCategoriesPreferencesFailure] when updating fails.
  Future<void> setCategoriesPreferences(Set<Category> categories) async {
    try {
      final preferencesEncoded =
          json.encode(categories.map((category) => category.name).toList());
      await _storage.write(
        key: _categoriesPreferencesStorageKey,
        value: preferencesEncoded,
      );
    } on StorageException catch (error, stackTrace) {
      Error.throwWithStackTrace(
        SetCategoriesPreferencesFailure(error),
        stackTrace,
      );
    }
  }
}
