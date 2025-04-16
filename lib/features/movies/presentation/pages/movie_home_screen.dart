import 'package:flutter/material.dart';
import 'package:init/features/auth/data/services/auth_service.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';

class MovieHomeScreen extends StatefulWidget {
  const MovieHomeScreen({Key? key}) : super(key: key);

  @override
  State<MovieHomeScreen> createState() => _MovieHomeScreenState();
}

class _MovieHomeScreenState extends State<MovieHomeScreen> {
  final AuthService _authService = AuthService();
  String? _sessionId;

  @override
  void initState() {
    super.initState();
    _loadSession();
  }

  Future<void> _loadSession() async {
    final id = await _authService.getSessionId();
    setState(() => _sessionId = id);
  }

  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Films Populaires'),
        actions: [
          _sessionId == null
              ? IconButton(
                  icon: const Icon(Icons.login),
                  onPressed: () async {
                    final result = await Navigator.pushNamed(context, '/login');
                    if (result == true) {
                      _loadSession();
                    }
                  },
                )
              : IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () async {
                    await _authService.logout();
                    setState(() => _sessionId = null);
                  },
                ),
        ],
      ),
      body: movieProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: movieProvider.movies.length,
              itemBuilder: (context, index) {
                final movie = movieProvider.movies[index];
                return ListTile(
                  leading: Image.network('https://image.tmdb.org/t/p/w200${movie.posterPath}'),
                  title: Text(movie.title),
                );
              },
            ),
    );
  }
}
