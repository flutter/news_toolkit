import 'dart:async';

import 'package:deep_link_client/deep_link_client.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

/// {@template firebase_deep_link_client}
/// A client that exposes a stream of deep link URIs redirected to the app.
/// {@endtemplate}
class FirebaseDeepLinkService extends DeepLinkService {
  /// {@macro firebase_deep_link_client}
  FirebaseDeepLinkService({FirebaseDynamicLinks? firebaseDynamicLinks})
      : _firebaseDynamicLinks =
            firebaseDynamicLinks ?? FirebaseDynamicLinks.instance;

  late final FirebaseDynamicLinks _firebaseDynamicLinks;

  @override
  Stream<Uri> get deepLinkStream =>
      _firebaseDynamicLinks.onLink.map((event) => event.link);

  @override
  Future<Uri?> getInitialLink() async {
    final deepLink = await _firebaseDynamicLinks.getInitialLink();
    return deepLink?.link;
  }
}
