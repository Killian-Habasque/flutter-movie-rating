import 'package:flutter/material.dart';
import 'package:init/features/auth/data/models/user_model.dart';
import 'package:init/features/auth/data/services/auth_service.dart';

class UserProvider with ChangeNotifier {
  final AuthService authService;
  final String apiKey;
  String? _sessionId;
  User? _user;

  UserProvider({required this.authService, required this.apiKey});
  
  User? get user => _user;

  Future<void> fetchUser(String sessionId) async {
    _sessionId = sessionId;
    _user = await authService.getAccountDetails(sessionId, apiKey);
    notifyListeners();
  }

  void clear() {
  _user = null;
  notifyListeners();
}
}
