import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

/// This method checks between platforms to use `Intent` on `Android`
/// or launchUrl with the scheme `message` on iOS.
Future<void> launchEmail() async {
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
