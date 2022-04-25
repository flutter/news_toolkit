// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_client/package_info_client.dart';

void main() {
  group('PackageInfo', () {
    test('supports referencing by value', () async {
      expect(
        PackageInfo(
          packageName: 'com.example.app',
          appName: 'App',
          buildNumber: '1',
          version: '1.0.0',
        ),
        equals(
          PackageInfo(
            packageName: 'com.example.app',
            appName: 'App',
            buildNumber: '1',
            version: '1.0.0',
          ),
        ),
      );
    });

    test('has correct props', () async {
      final packageInfo = PackageInfo(
        packageName: 'com.example.app',
        appName: 'App',
        buildNumber: '1',
        version: '1.0.0',
      );
      expect(
        packageInfo.props,
        equals([
          packageInfo.packageName,
          packageInfo.appName,
          packageInfo.buildNumber,
          packageInfo.version,
        ]),
      );
    });
  });
}
