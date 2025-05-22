import 'dart:async';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:smart_hotel_app/src/data/datasources/local/secure_storage.dart';
import 'package:smart_hotel_app/src/data/models/user/user.dart';

class AuthService {
  // Singleton instance
  static final AuthService _instance = AuthService._internal();

  // Private constructor
  AuthService._internal();

  // Factory constructor to return the same instance
  factory AuthService() {
    return _instance;
  }

  final storage = SecureStorage();

  // Current user stream
  final _authStateController = StreamController<User?>.broadcast();
  Stream<User?> get authStateChanges => _authStateController.stream;

  // Current user
  User? _currentUser;
  User? get currentUser => _currentUser;
  bool isAuntificated = false;

  int _userId(String? token) {
    if (token == null) {
      throw Exception('Token is null');
    }
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    return decodedToken['sub'] as int;
  }

  Future<int> get userId async => _userId(await storage.getAccessToken());

  Future<void> saveJwt() {
    return Future.delayed(const Duration(seconds: 1));
  }

  Future<String?> initializeUser() async {
    try {
      final token = await storage.getAccessToken();
      if (token != null) {
        isAuntificated = true;
        _authStateController.add(_currentUser);
      }
      return token;
    } catch (e) {
      log('Error while getting jwt in init');
    }
  }

  // Sign in with email and password
  Future<void> signInWithUser(
    User user,
    String accessToken,
    String refreshToken,
  ) async {
    try {
      _currentUser = user;
      isAuntificated = true;
      _authStateController.add(_currentUser);

      final dio = GetIt.I<Dio>();
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            options.headers['Authorization'] = 'Bearer $accessToken';
            handler.next(options);
          },
        ),
      );

      log('Token added to header');
      await storage.storeToken(accessToken, refreshToken);
    } catch (e) {
      throw AuthException('Failed to sign in: $e');
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      isAuntificated = false;
      _currentUser = null;
      _authStateController.add(null);
      final storage = SecureStorage();
      await storage.deleteAccessToken();
    } catch (e) {
      throw AuthException('Failed to sign out: $e');
    }
  }

  // Listen to auth state changes
  void onAuthStateChanged(void Function(User?) callback) {
    authStateChanges.listen(callback);
  }
}

// Custom exception
class AuthException implements Exception {
  final String message;
  AuthException(this.message);
}
