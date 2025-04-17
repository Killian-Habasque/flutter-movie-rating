import '../entities/user.dart';

abstract class UserRepository {
  Future<User> getAccountDetails(String sessionId);
  Future<bool> saveSession(String sessionId);
  Future<String?> getSessionId();
  Future<bool> isLoggedIn();
  Future<bool> logout();
} 