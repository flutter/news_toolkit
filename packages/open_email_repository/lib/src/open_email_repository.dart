import 'package:open_email_client/open_email_client.dart';

/// {@template open_email_repository}
/// Open email app repository
/// {@endtemplate}
class OpenEmailRepository {
  /// {@macro open_email_repository}
  const OpenEmailRepository({
    required OpenEmailClient openEmailClient,
  }) : _openEmailClient = openEmailClient;

  final OpenEmailClient _openEmailClient;

  /// Future method to open an email app based on the device.
  Future<void> openEmailApp() async => _openEmailClient.openEmailApp();
}
