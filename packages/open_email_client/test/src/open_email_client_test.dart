// ignore_for_file: prefer_const_constructors
import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:mocktail/mocktail.dart';
import 'package:open_email_client/open_email_client.dart';
import 'package:test/test.dart';
import 'package:url_launcher/url_launcher.dart';

class MockMethodChannel extends Mock implements MethodChannel {}

void main() {
  AndroidIntent androidIntent;
  late MethodChannel mockChannel;
  setUp(() {
    mockChannel = MockMethodChannel();
  });

  group('OpenEmailClient', () {
    test('can be instantiated', () {
      expect(OpenEmailClient(), isNotNull);
    });

    group('TargetPlatform', () {
      test('is Android', () {
        debugDefaultTargetPlatformOverride = TargetPlatform.android;
        expect(defaultTargetPlatform, TargetPlatform.android);
        expect(OpenEmailClient().openEmailApp(), completes);
        debugDefaultTargetPlatformOverride = null;
      });

      test('is iOS', () {
        debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
        expect(defaultTargetPlatform, TargetPlatform.iOS);
        expect(OpenEmailClient().openEmailApp(), completes);
        debugDefaultTargetPlatformOverride = null;
      });

      group('launchUrl', () {
        test('when platform is iOS', () {
          debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
          expect(defaultTargetPlatform, TargetPlatform.iOS);
          expect(launchUrl(Uri(scheme: 'message')), completes);
          debugDefaultTargetPlatformOverride = null;
        });
      });
    });
  });
}
