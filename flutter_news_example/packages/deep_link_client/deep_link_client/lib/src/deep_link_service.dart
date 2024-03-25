/// {@template deep_link_service}
/// A generic deep link service interface.
/// {@endtemplate}
abstract class DeepLinkService {
  /// Provides a stream of URIs intercepted by the app. Will emit the latest
  /// received value (if any) as first.
  Stream<Uri> get deepLinkStream;

  /// Retrieves the initial deep link if present.
  Future<Uri?> getInitialLink();
}
