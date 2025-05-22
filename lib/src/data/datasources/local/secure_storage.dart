import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const String _accessTokenKey = 'accessToken';
  static const String _refreshTokenKey = 'refreshToken';
  final FlutterSecureStorage _storage;

  SecureStorage({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  /// Stores the JWT token securely
  Future<void> storeToken(String accessToken, String refreshToken) async {
    try {
      await _storage.write(key: _accessTokenKey, value: accessToken);
      await _storage.write(key: _refreshTokenKey, value: refreshToken);
    } catch (e) {
      throw SecurityException('Failed to store token: $e');
    }
  }

  /// Retrieves the stored JWT token
  Future<String?> getAccessToken() async {
    try {
      return await _storage.read(key: _accessTokenKey);
    } catch (e) {
      throw SecurityException('Failed to retrieve token: $e');
    }
  }

  /// Retrieves the stored JWT token
  Future<String?> getRefreshToken() async {
    try {
      return await _storage.read(key: _refreshTokenKey);
    } catch (e) {
      throw SecurityException('Failed to retrieve token: $e');
    }
  }

  /// Deletes the stored JWT token
  Future<void> deleteAccessToken() async {
    try {
      await _storage.delete(key: _accessTokenKey);
    } catch (e) {
      throw SecurityException('Failed to delete token: $e');
    }
  }

  /// Deletes the stored JWT token
  Future<void> deleteRefreshToken() async {
    try {
      await _storage.delete(key: _refreshTokenKey);
    } catch (e) {
      throw SecurityException('Failed to delete token: $e');
    }
  }

  /// Checks if a token exists
  Future<bool> hasToken() async {
    try {
      final token = await getAccessToken();
      return token != null && token.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Clears all stored data
  Future<void> clearAll() async {
    try {
      await _storage.deleteAll();
    } catch (e) {
      throw SecurityException('Failed to clear storage: $e');
    }
  }
}

class SecurityException implements Exception {
  final String message;
  SecurityException(this.message);

  @override
  String toString() => 'SecurityException: $message';
}
