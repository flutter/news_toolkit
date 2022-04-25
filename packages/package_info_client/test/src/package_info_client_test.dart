// ignore_for_file: prefer_const_constructors
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_client/package_info_client.dart';
import 'package:package_info_plus/package_info_plus.dart' as plugin;

void main() {
  group('PackageInfoClient', () {
    final pluginPackageInfo = plugin.PackageInfo(
      packageName: 'com.example.app',
      appName: 'App',
      buildNumber: '1',
      version: '1.0.0',
    );

    test('retrieves correct package info', () async {
      final repository = PackageInfoClient(
        packageInfoProvider: () async => pluginPackageInfo,
      );

      final packageInfo = await repository.fetchPackageInfo();

      expect(packageInfo.packageName, equals(pluginPackageInfo.packageName));
      expect(packageInfo.appName, equals(pluginPackageInfo.appName));
      expect(packageInfo.buildNumber, equals(pluginPackageInfo.buildNumber));
      expect(packageInfo.version, equals(pluginPackageInfo.version));
    });

    test('caches package info', () async {
      var callCounter = 0;
      final repository = PackageInfoClient(
        packageInfoProvider: () async {
          callCounter++;
          return pluginPackageInfo;
        },
      );

      await repository.fetchPackageInfo();
      await repository.fetchPackageInfo();
      await repository.fetchPackageInfo();

      expect(callCounter, equals(1));
    });

    test(
        'throws PackageInfoFetchFailure '
        'when package info provider fails', () async {
      final repository = PackageInfoClient(
        packageInfoProvider: () => throw Exception(),
      );

      await expectLater(
        () async => repository.fetchPackageInfo(),
        throwsA(isA<PackageInfoFetchFailure>()),
      );
    });
  });

  group('PackageInfoFailure', () {
    final error = Exception('errorMessage');
    const stackTrace = StackTrace.empty;

    group('PackageInfoFetchFailure', () {
      test('has correct props', () {
        expect(
          PackageInfoFetchFailure(error, stackTrace).props,
          [error, stackTrace],
        );
      });
    });
  });
}
