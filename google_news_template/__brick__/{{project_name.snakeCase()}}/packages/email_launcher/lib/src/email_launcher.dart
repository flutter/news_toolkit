import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

/// {@template email_launcher_exception}
/// Exceptions from the email launcher.
/// {@endtemplate}
abstract class EmailLauncherException implements Exception {
  /// {@macro email_launcher_exception}
  const EmailLauncherException(this.error);

  /// The error which was caught.
  final Object error;
}

/// {@template launch_email_app_failure}
/// Thrown during the launching email app process if a failure occurs.
/// {@endtemplate}
class LaunchEmailAppFailure extends EmailLauncherException {
  /// {@macro launch_email_app_failure}
  const LaunchEmailAppFailure(super.error);
}

/// Provider to inject `launchUrl`.
typedef LaunchUrlProvider = Future<bool> Function(Uri url);

/// Provider to inject `canLaunchUrl`.
typedef CanLaunchUrlProvider = Future<bool> Function(Uri url);

/// {@template email_launcher}
/// Class which manages the email launcher logic.
/// {@endtemplate}
class EmailLauncher {
  /// {@macro email_launcher}
  EmailLauncher({
    LaunchUrlProvider? launchUrlProvider,
    CanLaunchUrlProvider? canLaunchProvider,
  })  : _launchUrlProvider = launchUrlProvider ?? launchUrl,
        _canLaunchUrlProvider = canLaunchProvider ?? canLaunchUrl;

  final LaunchUrlProvider _launchUrlProvider;
  final CanLaunchUrlProvider _canLaunchUrlProvider;

  /// Launches a default email app on `Android` and `iOS`.
  Future<void> launchEmailApp() async {
    try {
      if (defaultTargetPlatform == TargetPlatform.android) {
        const intent = AndroidIntent(
          action: 'android.intent.action.MAIN',
          category: 'android.intent.category.APP_EMAIL',
        );
        await intent.launch();
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        final url = Uri(scheme: 'message');
        if (await _canLaunchUrlProvider(url)) {
          await _launchUrlProvider(url);
        }
      }
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(LaunchEmailAppFailure(error), stackTrace);
    }
  }
}
