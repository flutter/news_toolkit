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

/// ShareProvider is a function type that provides the ability to share content.
typedef ShareProvider = Future<void> Function(String);

/// {@template share_launcher}
/// A class allowing opening native share bottom sheet.
/// {@endtemplate}
class ShareLauncher {
  /// {@macro share_launcher}

  const ShareLauncher({ShareProvider? shareProvider})
      : _shareProvider = shareProvider ?? Share.share;

  final ShareProvider _shareProvider;

  /// Method for opening native share bottom sheet.
  Future<void> share({required String text}) async {
    try {
      return _shareProvider(text);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(ShareFailure(error), stackTrace);
    }
  }
}
