// ignore_for_file: prefer_const_constructors

import 'package:package_info_client/package_info_client.dart';
import 'package:test/test.dart';

void main() {
  group('PackageInfoClient', () {
    test('returns correct package info', () async {
      const appName = 'App';
      const packageName = 'com.example.app';
      const packageVersion = '1.0.0';

      final packageInfoClient = PackageInfoClient(
        appName: appName,
        packageName: packageName,
        packageVersion: packageVersion,
      );

      expect(packageInfoClient.appName, appName);
      expect(packageInfoClient.packageName, packageName);
      expect(packageInfoClient.packageVersion, packageVersion);
    });
  });
}
