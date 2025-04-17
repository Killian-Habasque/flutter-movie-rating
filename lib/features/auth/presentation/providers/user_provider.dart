import 'package:flutter/material.dart';
import 'package:init/features/auth/domain/entities/user.dart';
import 'package:init/features/auth/domain/repositories/user_repository.dart';

class UserProvider with ChangeNotifier {
  final UserRepository userRepository;
  String? _sessionId;
  User? _user;

  UserProvider({required this.userRepository});
  
  User? get user => _user;

  Future<void> fetchUser(String sessionId) async {
    _sessionId = sessionId;
    _user = await userRepository.getAccountDetails(sessionId);
    notifyListeners();
  }

  void clear() {
    _user = null;
    notifyListeners();
  }
}
