// ignore_for_file: prefer_const_constructors

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:permission_client/permission_client.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PermissionClient', () {
    late PermissionClient permissionClient;
    late List<MethodCall> calls;

    setUp(() {
      permissionClient = PermissionClient();
      calls = [];
    });

    void setMockPermissionsMethods(WidgetTester tester) {
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        MethodChannel('flutter.baseflow.com/permissions/methods'),
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
      addTearDown(
        () {
          tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
            MethodChannel('flutter.baseflow.com/permissions/methods'),
            (call) async => null,
          );
        },
      );
    }

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
      testWidgets('calls correct method', (tester) async {
        setMockPermissionsMethods(tester);
        await permissionClient.requestNotifications();
        expect(calls, permissionWasRequested(Permission.notification));
      });
    });

    group('notificationsStatus', () {
      testWidgets('calls correct method', (tester) async {
        setMockPermissionsMethods(tester);
        await permissionClient.notificationsStatus();
        expect(calls, permissionWasChecked(Permission.notification));
      });
    });

    group('openPermissionSettings', () {
      testWidgets('calls correct method', (tester) async {
        setMockPermissionsMethods(tester);
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
