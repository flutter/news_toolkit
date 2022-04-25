import 'package:equatable/equatable.dart';
import 'package:package_info_client/package_info_client.dart';
import 'package:package_info_plus/package_info_plus.dart' as plugin;

/// {@template package_info_failure}
/// Base class for failures thrown from the package info client.
/// {@endtemplate}
abstract class PackageInfoFailure with EquatableMixin implements Exception {
  /// {@macro package_info_failure}
  const PackageInfoFailure(this.error, this.stackTrace);

  /// The error which was caught.
  final Object error;

  /// The stack trace associated with the [error].
  final StackTrace stackTrace;

  @override
  List<Object?> get props => [error, stackTrace];
}

/// {@template package_info_fetch_failure}
/// Default failure thrown when fetching the package info fails.
/// {@endtemplate}
class PackageInfoFetchFailure extends PackageInfoFailure {
  /// {@macro package_info_fetch_failure}
  const PackageInfoFetchFailure(Object error, StackTrace stackTrace)
      : super(error, stackTrace);
}

/// A type definition for [plugin.PackageInfo] provider.
typedef PackageInfoProvider = Future<plugin.PackageInfo> Function();

/// {@template package_info_client}
/// A client that provides information about the app's package metadata
/// like app name, package name, version or build number.
/// {@endtemplate}
class PackageInfoClient {
  /// {@macro package_info_client}
  PackageInfoClient({
    required PackageInfoProvider packageInfoProvider,
  }) : _packageInfoProvider = packageInfoProvider;

  final PackageInfoProvider _packageInfoProvider;

  PackageInfo? _cachedPackageInfo;

  /// Provides provides information about the app's package metadata
  /// like app name, package name, version or build number.
  ///
  /// Throws [PackageInfoFetchFailure] when fetching operation fails.
  Future<PackageInfo> fetchPackageInfo() async {
    if (_cachedPackageInfo != null) {
      return _cachedPackageInfo!;
    }

    try {
      final _packageInfo = await _packageInfoProvider();
      return _cachedPackageInfo ??= PackageInfo.from(_packageInfo);
    } catch (error, stackTrace) {
      throw PackageInfoFetchFailure(error, stackTrace);
    }
  }
}
