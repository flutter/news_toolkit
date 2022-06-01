import 'package:share_plus/share_plus.dart';

/// {@template share_launcher}
/// A class allowing opening native share bottom sheet.
/// {@endtemplate}
abstract class ShareLauncher {
  /// {@macro share_launcher}

  /// Method for opening native share bottom sheet.
  static Future<void> share({
    required String text,
    String? url,
    String? subject,
  }) async {
    return Share.share('$text \n\n $url');
  }
}
