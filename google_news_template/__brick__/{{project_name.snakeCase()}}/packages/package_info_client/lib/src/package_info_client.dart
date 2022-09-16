/// {@template package_info_client}
/// A client that provides information about the app's package metadata
/// like app name, package name or version.
/// {@endtemplate}
class PackageInfoClient {
  /// {@macro package_info_client}
  PackageInfoClient({
    required this.appName,
    required this.packageName,
    required this.packageVersion,
  });

  /// The app name.
  final String appName;

  /// The package name.
  final String packageName;

  /// The package version.
  final String packageVersion;
}
