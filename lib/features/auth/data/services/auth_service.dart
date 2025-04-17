import 'dart:convert';

import 'package:init/features/auth/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/auth_models.dart';
import 'package:http/http.dart' as http;

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

  Future<User> getAccountDetails(String sessionId, String apiKey) async {
    final response = await http.get(
      Uri.parse(
        'https://api.themoviedb.org/3/account?session_id=$sessionId&api_key=$apiKey',
      ),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return User.fromJson(jsonData);
    } else {
      throw Exception('Erreur lors de la récupération du compte utilisateur');
    }
  }
}
