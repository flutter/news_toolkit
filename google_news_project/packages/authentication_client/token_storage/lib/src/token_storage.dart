/// {@template token_storage}
/// Token storage for the authentication client.
/// {@endtemplate}
abstract class TokenStorage {
  /// Returns the current token.
  Future<String?> readToken();

  /// Saves the current token.
  Future<void> saveToken(String token);

  /// Clears the current token.
  Future<void> clearToken();
}

/// {@template in_memory_token_storage}
/// In-memory token storage for the authentication client.
/// {@endtemplate}
class InMemoryTokenStorage implements TokenStorage {
  String? _token;

  @override
  Future<String?> readToken() async => _token;

  @override
  Future<void> saveToken(String token) async => _token = token;

  @override
  Future<void> clearToken() async => _token = null;
}
