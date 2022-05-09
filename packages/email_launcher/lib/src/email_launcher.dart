import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

/// {@template email_launcher_exception}
/// Exceptions from the email launcher.
/// {@endtemplate}
class EmailLauncherException implements Exception {
  /// {@macro email_launcher_exception}
  const EmailLauncherException(this.error, this.stackTrace);

  /// The error which was caught.
  final Object error;

  /// The stack trace associated with the [error].
  final StackTrace stackTrace;
}

/// This method checks between platforms to use `Intent` on `Android`
/// or launchUrl with the scheme `message` on iOS.
Future<void> emailLauncher() async {
  try {
    if (defaultTargetPlatform == TargetPlatform.android) {
      const intent = AndroidIntent(
        action: 'android.intent.action.MAIN',
        category: 'android.intent.category.APP_EMAIL',
      );
      await intent.launch();
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      final url = Uri(scheme: 'message');
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      }
    }
  } catch (error, stackTrace) {
    throw EmailLauncherException(error, stackTrace);
  }
}
