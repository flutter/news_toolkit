import 'package:equatable/equatable.dart';
import 'package:package_info_plus/package_info_plus.dart' as plugin;

/// {@template package_info}
/// A class that represents information about the app's package metadata
/// like app name, package name, version or build number.
/// {@endtemplate}
class PackageInfo extends Equatable {
  /// {@macro package_info}
  const PackageInfo({
    required this.appName,
    required this.packageName,
    required this.version,
    required this.buildNumber,
  });

  /// Creates an instance of [PackageInfo] from [plugin.PackageInfo] object.
  factory PackageInfo.from(plugin.PackageInfo packageInfo) {
    return PackageInfo(
      appName: packageInfo.appName,
      packageName: packageInfo.packageName,
      version: packageInfo.version,
      buildNumber: packageInfo.buildNumber,
    );
  }

  /// An empty [PackageInfo] object.
  static const PackageInfo empty = PackageInfo(
    appName: '',
    packageName: '',
    version: '',
    buildNumber: '',
  );

  /// The package name.
  /// - `bundleIdentifier` on iOS.
  /// - `getPackageName` on Android.
  final String packageName;

  /// The app name.
  /// - `CFBundleDisplayName` on iOS.
  /// - `application/label` on Android.
  final String appName;

  /// The build number.
  /// - `CFBundleVersion` on iOS.
  /// - `versionCode` on Android.
  final String buildNumber;

  /// The package version.
  /// - `CFBundleShortVersionString` on iOS.
  /// - `versionName` on Android.
  final String version;

  @override
  List<Object> get props => [
        packageName,
        appName,
        buildNumber,
        version,
      ];
}
