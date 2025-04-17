import 'package:flutter/material.dart';
import 'package:init/core/constants.dart';
import 'package:init/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:init/features/auth/data/repositories/user_repository_impl.dart';
import 'package:init/features/auth/presentation/providers/user_provider.dart';
import 'package:init/features/auth/presentation/screens/login_screen.dart';
import 'package:init/features/movies/presentation/delegates/movie_search_delegate.dart';
import 'package:init/features/movies/presentation/pages/movie_detail_page.dart';
import 'package:init/features/movies/presentation/providers/search_movie_provider.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(
      settings: const RouteSettings(name: '/home'),
      builder: (_) => const HomePage(),
    );
  }

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final userRepository = UserRepositoryImpl(apiKey);
  final authRepository = AuthRepositoryImpl(apiKey);

  String? _sessionId;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _loadSession() async {
    final id = await userRepository.getSessionId();
    setState(() => _sessionId = id);

    if (id != null) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.fetchUser(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    _loadSession();
    final provider = Provider.of<MovieProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Movies'),
            if (user != null) ...[
              const SizedBox(width: 10),
              Text('@${user.username}', style: const TextStyle(fontSize: 14)),
            ],
          ],
        ),
        actions: [
          if (user?.avatarUrl != null)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(user!.avatarUrl!),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              final searchProvider = Provider.of<SearchMovieProvider>(
                context,
                listen: false,
              );

              showSearch(
                context: context,
                delegate: MovieSearchDelegate(searchProvider),
              );
            },
          ),
          _sessionId == null
              ? IconButton(
                icon: const Icon(Icons.login),
                onPressed: () {
                  Navigator.push(
                    context,
                    LoginScreen.route(
                      authRepository: authRepository,
                      userRepository: userRepository,
                    ),
                  );
                },
              )
              : IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () async {
                  await userRepository.logout();
                  setState(() => _sessionId = null);
                },
              ),
        ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(8.0),
              children: [
                const Text(
                  'Now playing',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...provider.nowPlayingMovies.map(
                  (movie) => _buildMovieTile(context, movie),
                ),

                const SizedBox(height: 20),

                const Text(
                  'Upcoming movies',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...provider.upcomingMovies.map(
                  (movie) => _buildMovieTile(context, movie),
                ),

                const Text(
                  'Top rated movies',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...provider.topRatedMovies.map(
                  (movie) => _buildMovieTile(context, movie),
                ),

                const Text(
                  'Popular movies',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...provider.popularMovies.map(
                  (movie) => _buildMovieTile(context, movie),
                ),

                const SizedBox(height: 20),
              ],
            ),
    );
  }

  Widget _buildMovieTile(BuildContext context, movie) {
    return ListTile(
      leading: Image.network(
        'https://image.tmdb.org/t/p/w200${movie.posterPath}',
        width: 50,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(movie.title)),
          Text(
            '${movie.voteAverage.toStringAsFixed(1)}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      onTap: () {
        Navigator.push(context, MovieDetailPage.route(movieId: movie.id));
      },
    );
  }
}
