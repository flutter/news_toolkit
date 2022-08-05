import 'package:dart_frog/dart_frog.dart';

/// A lightweight user object associated with an incoming [Request].
class RequestUser {
  const RequestUser._({required this.id});

  /// The unique user identifier.
  final String id;

  /// An anonymous user.
  static const anonymous = RequestUser._(id: '');

  /// Whether the user is anonymous.
  bool get isAnonymous => this == RequestUser.anonymous;
}

/// Provider a [RequestUser] to the current [RequestContext].
Middleware userProvider() {
  return (handler) {
    return handler.use(
      provider<RequestUser>((context) {
        final userId = _extractUserId(context.request);
        return userId != null
            ? RequestUser._(id: userId)
            : RequestUser.anonymous;
      }),
    );
  };
}

String? _extractUserId(Request request) {
  final authorizationHeader = request.headers['authorization'];
  if (authorizationHeader == null) return null;
  final segments = authorizationHeader.split(' ');
  if (segments.length != 2) return null;
  if (segments.first.toLowerCase() != 'bearer') return null;
  final userId = segments.last;
  return userId;
}
