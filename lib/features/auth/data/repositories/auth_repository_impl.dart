 import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/auth_models.dart';

class AuthRepository {
  final String _apiKey;
  final String _baseUrl = 'https://api.themoviedb.org/3';

  AuthRepository(this._apiKey);

  Future<RequestToken> createRequestToken() async {
    final url = Uri.parse('$_baseUrl/authentication/token/new?api_key=$_apiKey');
    
    try {
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return RequestToken.fromJson(jsonData);
      } else {
        throw Exception('Failed to create request token: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to create request token: $e');
    }
  }

  Future<Session> createSession(String requestToken) async {
    final url = Uri.parse('$_baseUrl/authentication/session/new?api_key=$_apiKey');
    
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'request_token': requestToken}),
      );
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return Session.fromJson(jsonData);
      } else {
        throw Exception('Failed to create session: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to create session: $e');
    }
  }
}