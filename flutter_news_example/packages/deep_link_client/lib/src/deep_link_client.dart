import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

import 'package:rxdart/rxdart.dart';

/// {@template deep_link_client_failure}
/// Indicates a failure during retrieval or processing of a deep link.
/// {@endtemplate}
class DeepLinkClientFailure with EquatableMixin implements Exception {
  /// {@macro deep_link_client_failure}
  DeepLinkClientFailure(this.error);

  /// The error which was caught.
  final Object error;

  @override
  List<Object> get props => [error];
}

/// {@template deep_link_client}
/// A client that exposes a stream of deep link URIs redirected to the app.
/// {@endtemplate}
class DeepLinkClient {
  /// {@macro deep_link_client}
  DeepLinkClient({FirebaseDynamicLinks? firebaseDynamicLinks})
      : _deepLinkSubject = BehaviorSubject<Uri>() {
    _firebaseDynamicLinks =
        firebaseDynamicLinks ?? FirebaseDynamicLinks.instance;

    unawaited(_getInitialLink());
    _firebaseDynamicLinks.onLink.listen(_onAppLink).onError(_handleError);
  }

  late final FirebaseDynamicLinks _firebaseDynamicLinks;
  final BehaviorSubject<Uri> _deepLinkSubject;

  /// Provides a stream of URIs intercepted by the app. Will emit the latest
  /// received value (if any) as first.
  Stream<Uri> get deepLinkStream => _deepLinkSubject;

  Future<void> _getInitialLink() async {
    try {
      final deepLink = await _firebaseDynamicLinks.getInitialLink();
      if (deepLink != null) {
        _onAppLink(deepLink);
      }
    } catch (error, stackTrace) {
      _handleError(error, stackTrace);
    }
  }

  void _onAppLink(PendingDynamicLinkData dynamicLinkData) {
    _deepLinkSubject.add(dynamicLinkData.link);
  }

  void _handleError(Object error, StackTrace stackTrace) {
    _deepLinkSubject.addError(DeepLinkClientFailure(error), stackTrace);
  }
}
