import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/auth.dart';
import '../models/auth_models.dart';

class AuthRepositoryImpl implements AuthRepository {
  final String _apiKey;
  final String _baseUrl = 'https://api.themoviedb.org/3';
  final http.Client _client;

  AuthRepositoryImpl(this._apiKey, {http.Client? client}) 
      : _client = client ?? http.Client();

  @override
  Future<RequestToken> createRequestToken() async {
    final url = Uri.parse('$_baseUrl/authentication/token/new?api_key=$_apiKey');
    
    try {
      final response = await _client.get(url);
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final modelToken = RequestTokenModel.fromJson(jsonData);
        return RequestToken(
          requestToken: modelToken.requestToken,
          success: modelToken.success,
          expiresAt: modelToken.expiresAt,
        );
      } else {
        throw Exception('Failed to create request token: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to create request token: $e');
    }
  }

  @override
  Future<Session> createSession(String requestToken) async {
    final url = Uri.parse('$_baseUrl/authentication/session/new?api_key=$_apiKey');
    
    try {
      final response = await _client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'request_token': requestToken}),
      );
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final modelSession = SessionModel.fromJson(jsonData);
        return Session(
          sessionId: modelSession.sessionId,
          success: modelSession.success,
        );
      } else {
        throw Exception('Failed to create session: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to create session: $e');
    }
  }
}