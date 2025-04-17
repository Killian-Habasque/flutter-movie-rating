import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/services/auth_service.dart';
import '../screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  final AuthRepository authRepository;
  final AuthService authService;

  const LoginScreen({
    Key? key,
    required this.authRepository,
    required this.authService,
  }) : super(key: key);

  static Route<void> route({
    required AuthRepository authRepository,
    required AuthService authService,
  }) {
    return MaterialPageRoute<void>(
      settings: const RouteSettings(name: '/login'),

      builder:
          (_) => LoginScreen(
            authRepository: authRepository,
            authService: authService,
          ),
    );
  }

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    final isLoggedIn = await widget.authService.isLoggedIn();
    if (isLoggedIn) {
      final sessionId = await widget.authService.getSessionId();
      if (sessionId != null) {
        _navigateToHome(sessionId);
      }
    }
  }

  void _navigateToHome(String sessionId) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder:
            (context) => HomeScreen(
              sessionId: sessionId,
              authService: widget.authService,
            ),
      ),
    );
  }

  Future<void> _login() async {
    setState(() => _isLoading = true);
    try {
      final requestToken = await widget.authRepository.createRequestToken();
      final urlString =
          'https://www.themoviedb.org/authenticate/${requestToken.requestToken}';

      // Modification de la méthode d'ouverture de l'URL
      if (await canLaunchUrl(Uri.parse(urlString))) {
        await launchUrl(
          Uri.parse(urlString),
          mode: LaunchMode.externalApplication,
        );

        // Attendre que l'utilisateur ait autorisé l'application sur TMDB
        // Afficher un dialogue demandant confirmation
        await _handleAuthorizationConfirmation(requestToken.requestToken);
      } else {
        // Afficher un message si l'URL ne peut pas être ouverte
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Impossible d\'ouvrir le navigateur. URL: $urlString',
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la connexion: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleAuthorizationConfirmation(String requestToken) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirmation'),
            content: const Text('Avez-vous autorisé l\'application sur TMDB?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Non'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Oui'),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      try {
        final session = await widget.authRepository.createSession(requestToken);
        // Stocker la session et rediriger vers la page principale
        await widget.authService.saveSession(session);
        _navigateToHome(session.sessionId);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la création de la session: $e'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Connexion')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Connectez-vous avec votre compte TMDB',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _login,
              child:
                  _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Se connecter'),
            ),
          ],
        ),
      ),
    );
  }
}
