import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../models/user_model.dart';

class UserRepositoryImpl implements UserRepository {
  static const _sessionIdKey = 'session_id';
  final String _apiKey;
  final String _baseUrl = 'https://api.themoviedb.org/3';

  UserRepositoryImpl(this._apiKey);

  @override
  Future<User> getAccountDetails(String sessionId) async {
    final response = await http.get(
      Uri.parse(
        '$_baseUrl/account?session_id=$sessionId&api_key=$_apiKey',
      ),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final userModel = UserModel.fromJson(jsonData);
      return User(
        id: userModel.id,
        name: userModel.name,
        username: userModel.username,
        avatarUrl: userModel.avatarUrl,
      );
    } else {
      throw Exception('Error retrieving user account');
    }
  }

  @override
  Future<bool> saveSession(String sessionId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_sessionIdKey, sessionId);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<String?> getSessionId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_sessionIdKey);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    final sessionId = await getSessionId();
    return sessionId != null && sessionId.isNotEmpty;
  }

  @override
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