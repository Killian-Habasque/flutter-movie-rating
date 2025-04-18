import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';


class AuthService {
  final UserRepository _userRepository;
  
  AuthService(this._userRepository);


  Future<String?> getSessionId() async {
    return _userRepository.getSessionId();
  }

  Future<bool> isLoggedIn() async {
    return _userRepository.isLoggedIn();
  }

  Future<bool> logout() async {
    return _userRepository.logout();
  }

  Future<User> getAccountDetails(String sessionId, String apiKey) async {
    return _userRepository.getAccountDetails(sessionId);
  }

  Future<bool> saveSession(dynamic session) async {
    String sessionId;
    if (session is String) {
      sessionId = session;
    } else {
      sessionId = session.sessionId;
    }
    return _userRepository.saveSession(sessionId);
  }
} 