// ignore_for_file: prefer_const_constructors

import 'package:email_launcher/email_launcher.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

import '../helpers/helpers.dart';

void main() {
  final mock = MockUrlLauncher();
  final emailLauncher = EmailLauncher();

  setUp(() {
    UrlLauncherPlatform.instance = mock;
  });

  group('EmailLauncher', () {
    group('launchEmailApp', () {
      group('when platform is Android', () {
        test('completes', () {
          debugDefaultTargetPlatformOverride = TargetPlatform.android;
          expect(defaultTargetPlatform, TargetPlatform.android);
          expect(emailLauncher.launchEmailApp(), completes);
          debugDefaultTargetPlatformOverride = null;
        });
      });

      group('when platform is iOS', () {
        test('completes', () {
          final emailLauncher = EmailLauncher(
            launchUrlProvider: (_) => Future.value(true),
            canLaunchProvider: (_) => Future.value(true),
          );
          debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
          expect(defaultTargetPlatform, TargetPlatform.iOS);
          expect(emailLauncher.launchEmailApp(), completes);
          WidgetsFlutterBinding.ensureInitialized();
          debugDefaultTargetPlatformOverride = null;
        });

        group('calls canLaunch and launchUrl', () {
          test('when target platform is iOS', () async {
            debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
            expect(defaultTargetPlatform, TargetPlatform.iOS);
            final url = Uri(scheme: 'message');
            mock
              ..canLaunchUrl = url.toString()
              ..response = true;

            final result = await canLaunchUrl(url);
            mock
              ..setLaunchUrlExpectations(
                url: url.toString(),
              )
              ..response = true;
            final launch = await launchUrl(url);
            await emailLauncher.launchEmailApp();
            expect(result, isTrue);
            expect(launch, isTrue);
            debugDefaultTargetPlatformOverride = null;
          });
        });
      });

      test(
          'throws LaunchEmailAppFailure '
          'on generic exception', () async {
        debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
        final emailLauncher = EmailLauncher(
          launchUrlProvider: (_) => throw Exception(),
        );
        expect(
          emailLauncher.launchEmailApp,
          throwsA(isA<LaunchEmailAppFailure>()),
        );
        debugDefaultTargetPlatformOverride = null;
      });
    });
  });
}
