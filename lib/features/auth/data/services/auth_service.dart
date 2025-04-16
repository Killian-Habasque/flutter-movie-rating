 import 'package:shared_preferences/shared_preferences.dart';
import '../models/auth_models.dart';

class AuthService {
  static const _sessionIdKey = 'session_id';
  
  // Sauvegarder la session ID
  Future<bool> saveSession(Session session) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_sessionIdKey, session.sessionId);
      return true;
    } catch (e) {
      return false;
    }
  }
  
  // Récupérer la session ID
  Future<String?> getSessionId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_sessionIdKey);
    } catch (e) {
      return null;
    }
  }
  
  // Vérifier si l'utilisateur est connecté
  Future<bool> isLoggedIn() async {
    final sessionId = await getSessionId();
    return sessionId != null && sessionId.isNotEmpty;
  }
  
  // Déconnexion
  Future<bool> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_sessionIdKey);
      return true;
    } catch (e) {
      return false;
    }
  }
}