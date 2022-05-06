import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

/// {@template open_email_client}
/// A package to open an external email app on Android and iOS
/// {@endtemplate}
class OpenEmailClient {
  /// {@macro open_email_client}
  const OpenEmailClient();

  /// Open email app method
  /// This method check between platforms to use `Intent` on `Android`
  /// or launchUrl with the scheme `message` on iOS.
  Future<void> openEmailApp() async {
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
  }
}
