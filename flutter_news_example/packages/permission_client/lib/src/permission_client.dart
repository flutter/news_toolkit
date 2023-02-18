import 'package:permission_handler/permission_handler.dart';

export 'package:permission_handler/permission_handler.dart'
    show PermissionStatus, PermissionStatusGetters;

/// {@template permission_client}
/// A client that handles requesting permissions on a device.
/// {@endtemplate}
class PermissionClient {
  /// {@macro permission_client}
  const PermissionClient();

  /// Request access to the device's notifications,
  /// if access hasn't been previously granted.
  Future<PermissionStatus> requestNotifications() =>
      Permission.notification.request();

  /// Returns a permission status for the device's notifications.
  Future<PermissionStatus> notificationsStatus() =>
      Permission.notification.status;

  /// Opens the app settings page.
  ///
  /// Returns true if the settings could be opened, otherwise false.
  Future<bool> openPermissionSettings() => openAppSettings();
}
