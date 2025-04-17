import '../entities/auth.dart';

abstract class AuthRepository {
  Future<RequestToken> createRequestToken();
  Future<Session> createSession(String requestToken);
} 