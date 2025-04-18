import 'package:flutter/material.dart';
import '../../domain/repositories/user_repository.dart';

class HomeScreen extends StatelessWidget {
  final String sessionId;
  final UserRepository userRepository;

  const HomeScreen({
    Key? key,
    required this.sessionId,
    required this.userRepository,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TMDB App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () async {
              await userRepository.logout();
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Vous êtes connecté !',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('Session ID: $sessionId'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // TODO: Implémenter la navigation
              },
              child: const Text('Voir les films'),
            ),
          ],
        ),
      ),
    );
  }
}