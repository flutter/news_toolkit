import 'dart:async';

import 'package:deep_link_client/deep_link_client.dart';
import 'package:equatable/equatable.dart';
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
/// A generic deep link client interface.
/// {@endtemplate}
class DeepLinkClient {
  /// {@macro firebase_deep_link_client}
  DeepLinkClient({
    required DeepLinkService deepLinkService,
  })  : _deepLinkService = deepLinkService,
        _deepLinkSubject = BehaviorSubject<Uri>() {
    unawaited(_getInitialLink());
    _deepLinkService.deepLinkStream.listen(_onAppLink).onError(_handleError);
  }

  final DeepLinkService _deepLinkService;
  final BehaviorSubject<Uri> _deepLinkSubject;

  /// Provides a stream of URIs intercepted by the app. Will emit the latest
  /// received value (if any) as first.
  Stream<Uri> get deepLinkStream => _deepLinkSubject;

  Future<void> _getInitialLink() async {
    try {
      final deepLink = await _deepLinkService.getInitialLink();
      if (deepLink != null) {
        _onAppLink(deepLink);
      }
    } catch (error, stackTrace) {
      _handleError(error, stackTrace);
    }
  }

  void _onAppLink(Uri deepLink) {
    _deepLinkSubject.add(deepLink);
  }

  void _handleError(Object error, StackTrace stackTrace) {
    _deepLinkSubject.addError(DeepLinkClientFailure(error), stackTrace);
  }
}
