import 'package:share_plus/share_plus.dart';

/// {@template share_launcher}
/// A class allowing opening native share bottom sheet.
/// {@endtemplate}
class ShareLauncher {
  /// {@macro share_launcher}

  /// Method for opening native share bottom sheet.
  static Future<void> share({required String text}) async {
    return Share.share(text);
  }
}
