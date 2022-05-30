import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_news_template_api/client.dart';
import 'package:permission_client/permission_client.dart';
import 'package:storage/storage.dart';
import 'package:very_good_analysis/very_good_analysis.dart';

/// {@template notifications_failure}
/// A base failure for the notifications repository failures.
/// {@endtemplate}
abstract class NotificationsFailure with EquatableMixin implements Exception {
  /// {@macro notifications_failure}
  const NotificationsFailure(this.error);

  /// The error which was caught.
  final Object error;

  @override
  List<Object?> get props => [error];
}

/// {@template initialize_categories_preferences_failure}
/// Thrown when initializing categories preferences fails.
/// {@endtemplate}
class InitializeCategoriesPreferencesFailure extends NotificationsFailure {
  /// {@macro initialize_categories_preferences_failure}
  const InitializeCategoriesPreferencesFailure(super.error);
}

/// {@template toggle_notifications_failure}
/// Thrown when toggling notifications fails.
/// {@endtemplate}
class ToggleNotificationsFailure extends NotificationsFailure {
  /// {@macro toggle_notifications_failure}
  const ToggleNotificationsFailure(super.error);
}

/// {@template fetch_notifications_enabled_failure}
/// Thrown when fetching a notifications enabled status fails.
/// {@endtemplate}
class FetchNotificationsEnabledFailure extends NotificationsFailure {
  /// {@macro fetch_notifications_enabled_failure}
  const FetchNotificationsEnabledFailure(super.error);
}

/// {@template set_categories_preferences_failure}
/// Thrown when setting categories preferences fails.
/// {@endtemplate}
class SetCategoriesPreferencesFailure extends NotificationsFailure {
  /// {@macro set_categories_preferences_failure}
  const SetCategoriesPreferencesFailure(super.error);
}

/// {@template fetch_categories_preferences_failure}
/// Thrown when fetching categories preferences fails.
/// {@endtemplate}
class FetchCategoriesPreferencesFailure extends NotificationsFailure {
  /// {@macro fetch_categories_preferences_failure}
  const FetchCategoriesPreferencesFailure(super.error);
}

/// Storage keys of the notifications repository.
@visibleForTesting
abstract class StorageKeys {
  /// Whether the notifications are enabled.
  static const notificationsEnabled = '__notifications_enabled_storage_key__';

  /// The list of user's categories preferences.
  static const categoriesPreferences = '__categories_preferences_storage_key__';
}

/// {@template notifications_repository}
/// A repository that manages notification permissions and topic subscriptions.
///
/// Access to the device's notifications can be toggled with
/// [toggleNotifications] and checked with [fetchNotificationsEnabled].
///
/// Notification preferences for topic subscriptions related to news categories
/// may be updated with [setCategoriesPreferences] and checked with
/// [fetchCategoriesPreferences].
/// {@endtemplate}
class NotificationsRepository {
  /// {@macro notifications_repository}
  NotificationsRepository({
    required PermissionClient permissionClient,
    required Storage storage,
    required FirebaseMessaging firebaseMessaging,
    required GoogleNewsTemplateApiClient apiClient,
  })  : _permissionClient = permissionClient,
        _storage = storage,
        _firebaseMessaging = firebaseMessaging,
        _apiClient = apiClient {
    unawaited(_initializeCategoriesPreferences());
  }

  final PermissionClient _permissionClient;
  final Storage _storage;
  final FirebaseMessaging _firebaseMessaging;
  final GoogleNewsTemplateApiClient _apiClient;

  /// Toggles the notifications based on the [enable].
  ///
  /// When [enable] is true, request the notification permission if not granted
  /// and marks the notification setting as enabled. Subscribes the user to
  /// notifications related to user's categories preferences.
  ///
  /// When [enable] is false, marks notification setting as disabled and
  /// unsubscribes the user from notifications related to user's categories
  /// preferences.
  Future<void> toggleNotifications({required bool enable}) async {
    try {
      // Request the notification permission when turning notifications on.
      if (enable) {
        // Find the current notification permission status.
        final permissionStatus = await _permissionClient.notificationsStatus();

        // Navigate the user to permission settings
        // if the permission status is permanently denied or restricted.
        if (permissionStatus.isPermanentlyDenied ||
            permissionStatus.isRestricted) {
          await _permissionClient.openPermissionSettings();
          return;
        }

        // Request the permission if the permission status is denied.
        if (permissionStatus.isDenied) {
          final updatedPermissionStatus =
              await _permissionClient.requestNotifications();
          if (!updatedPermissionStatus.isGranted) {
            return;
          }
        }
      }

      // Toggle categories preferences notification subscriptions.
      await _toggleCategoriesPreferencesSubscriptions(enable: enable);

      // Update the notifications enabled in Storage.
      await _storage.write(
        key: StorageKeys.notificationsEnabled,
        value: enable.toString(),
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(ToggleNotificationsFailure(error), stackTrace);
    }
  }

  /// Returns true when the notification permission is granted
  /// and the notification setting is enabled.
  Future<bool> fetchNotificationsEnabled() async {
    try {
      final permissionStatus = await _permissionClient.notificationsStatus();
      final notificationsEnabled =
          (await _storage.read(key: StorageKeys.notificationsEnabled))
                  ?.parseBool() ??
              false;
      return permissionStatus.isGranted && notificationsEnabled;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        FetchNotificationsEnabledFailure(error),
        stackTrace,
      );
    }
  }

  /// Updates the user's notification preferences and subscribes the user to
  /// receive notifications related to [categories].
  ///
  /// [categories] represents a set of categories the user has agreed to
  /// receive notifications from.
  ///
  /// Throws [SetCategoriesPreferencesFailure] when updating fails.
  Future<void> setCategoriesPreferences(Set<Category> categories) async {
    try {
      // Disable notification subscriptions for previous categories preferences.
      await _toggleCategoriesPreferencesSubscriptions(enable: false);

      // Update categories preferences in Storage.
      final preferencesEncoded =
          json.encode(categories.map((category) => category.name).toList());
      await _storage.write(
        key: StorageKeys.categoriesPreferences,
        value: preferencesEncoded,
      );

      // Enable notification subscriptions for updated categories preferences.
      if (await fetchNotificationsEnabled()) {
        await _toggleCategoriesPreferencesSubscriptions(enable: true);
      }
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        SetCategoriesPreferencesFailure(error),
        stackTrace,
      );
    }
  }

  /// Fetches the user's notification preferences for news categories.
  ///
  /// The result represents a set of categories the user has agreed to
  /// receive notifications from.
  ///
  /// Throws [FetchCategoriesPreferencesFailure] when fetching fails.
  Future<Set<Category>?> fetchCategoriesPreferences() async {
    try {
      final categories = await _storage.read(
        key: StorageKeys.categoriesPreferences,
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

  /// Toggles notification subscriptions based on user's categories preferences.
  Future<void> _toggleCategoriesPreferencesSubscriptions({
    required bool enable,
  }) async {
    final categoriesPreferences = await fetchCategoriesPreferences() ?? {};
    await Future.wait(
      categoriesPreferences.map((category) {
        return enable
            ? _firebaseMessaging.subscribeToTopic(category.name)
            : _firebaseMessaging.unsubscribeFromTopic(category.name);
      }),
    );
  }

  /// Initializes categories preferences to all categories
  /// if they have not been set before.
  Future<void> _initializeCategoriesPreferences() async {
    try {
      final categoriesPreferences = await fetchCategoriesPreferences();
      if (categoriesPreferences == null) {
        final categoriesResponse = await _apiClient.getCategories();
        await setCategoriesPreferences(categoriesResponse.categories.toSet());
      }
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        InitializeCategoriesPreferencesFailure(error),
        stackTrace,
      );
    }
  }
}

extension _BoolFromStringParsing on String {
  bool parseBool() {
    return toLowerCase() == 'true';
  }
}
