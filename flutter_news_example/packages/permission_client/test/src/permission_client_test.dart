// ignore_for_file: prefer_const_constructors

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:permission_client/permission_client.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  final binding = TestWidgetsFlutterBinding.ensureInitialized();

  group('PermissionClient', () {
    late PermissionClient permissionClient;
    late List<MethodCall> calls;
    const methodChannelName = 'flutter.baseflow.com/permissions/methods';

    setUp(() {
      permissionClient = PermissionClient();
      calls = [];

      binding.defaultBinaryMessenger.setMockMethodCallHandler(
        MethodChannel(methodChannelName),
        (call) async {
          calls.add(call);

          if (call.method == 'checkPermissionStatus') {
            return PermissionStatus.granted.index;
          } else if (call.method == 'requestPermissions') {
            return <dynamic, dynamic>{
              for (final key in call.arguments as List<dynamic>)
                key: PermissionStatus.granted.index,
            };
          } else if (call.method == 'openAppSettings') {
            return true;
          }

          return null;
        },
      );
    });

    tearDown(() {
      binding.defaultBinaryMessenger.setMockMethodCallHandler(
        MethodChannel(methodChannelName),
        (call) async => null,
      );
    });

    Matcher permissionWasRequested(Permission permission) => contains(
          isA<MethodCall>()
              .having(
                (c) => c.method,
                'method',
                'requestPermissions',
              )
              .having(
                (c) => c.arguments,
                'arguments',
                contains(permission.value),
              ),
        );

    Matcher permissionWasChecked(Permission permission) => contains(
          isA<MethodCall>()
              .having(
                (c) => c.method,
                'method',
                'checkPermissionStatus',
              )
              .having(
                (c) => c.arguments,
                'arguments',
                equals(permission.value),
              ),
        );

    group('requestNotifications', () {
      test('calls correct method', () async {
        await permissionClient.requestNotifications();
        expect(calls, permissionWasRequested(Permission.notification));
      });
    });

    group('notificationsStatus', () {
      test('calls correct method', () async {
        await permissionClient.notificationsStatus();
        expect(calls, permissionWasChecked(Permission.notification));
      });
    });

    group('openPermissionSettings', () {
      test('calls correct method', () async {
        await permissionClient.openPermissionSettings();

        expect(
          calls,
          contains(
            isA<MethodCall>().having(
              (c) => c.method,
              'method',
              'openAppSettings',
            ),
          ),
        );
      });
    });
  });
}
