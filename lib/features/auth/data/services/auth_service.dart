import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';

/// @deprecated Cette classe est conservée pour la rétrocompatibilité. 
/// Utilisez plutôt UserRepository
class AuthService {
  final UserRepository _userRepository;
  
  AuthService(this._userRepository);

  // Récupérer la session ID
  Future<String?> getSessionId() async {
    return _userRepository.getSessionId();
  }

  // Vérifier si l'utilisateur est connecté
  Future<bool> isLoggedIn() async {
    return _userRepository.isLoggedIn();
  }

  // Déconnexion
  Future<bool> logout() async {
    return _userRepository.logout();
  }

  Future<User> getAccountDetails(String sessionId, String apiKey) async {
    return _userRepository.getAccountDetails(sessionId);
  }

  // Sauvegarder la session ID
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