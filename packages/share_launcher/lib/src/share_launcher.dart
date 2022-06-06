import 'package:equatable/equatable.dart';
import 'package:share_plus/share_plus.dart';

/// {@template share_failure}
/// A failure for the share launcher failures.
/// {@endtemplate}
class ShareFailure with EquatableMixin implements Exception {
  /// {@macro share_failure}
  const ShareFailure(this.error);

  /// The error which was caught.
  final Object error;

  @override
  List<Object?> get props => [error];
}

/// {@template share_launcher}
/// A class allowing opening native share bottom sheet.
/// {@endtemplate}
class ShareLauncher {
  /// {@macro share_launcher}

  /// Method for opening native share bottom sheet.
  Future<void> share({required String text}) async {
    try {
      return Share.share(text);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(ShareFailure(error), stackTrace);
    }
  }
}
