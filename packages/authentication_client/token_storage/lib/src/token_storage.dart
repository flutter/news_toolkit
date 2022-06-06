/// {@template token_storage}
/// Token storage for the authentication client.
/// {@endtemplate}
abstract class TokenStorage {
  /// Returns the current token.
  String? readToken();

  /// Saves the current token.
  void saveToken(String token);
}

/// {@template in_memory_token_storage}
/// in-memory token storage for the authentication client.
/// {@endtemplate}
class InMemoryTokenStorage implements TokenStorage {
  String? _token;

  @override
  String? readToken() => _token;

  @override
  void saveToken(String token) => _token = token;
}
