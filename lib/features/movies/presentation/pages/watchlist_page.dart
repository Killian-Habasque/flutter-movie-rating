import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:init/features/auth/domain/repositories/user_repository.dart';
import 'package:init/features/auth/presentation/providers/user_provider.dart';
import 'package:init/features/movies/domain/entities/movie.dart';
import 'package:init/features/movies/presentation/providers/watchlist_provider.dart';
import 'movie_detail_page.dart';

class WatchlistPage extends StatefulWidget {
  static const routeName = '/watchlist';

  const WatchlistPage({Key? key}) : super(key: key);

  @override
  State<WatchlistPage> createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage> {
  bool _isInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      _loadWatchlist();
      _isInit = true;
    }
  }

  Future<void> _loadWatchlist() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userRepo = Provider.of<UserRepository>(context, listen: false);
    final watchlistProvider = Provider.of<WatchlistProvider>(context, listen: false);
    
    if (userProvider.user != null) {
      final sessionId = await userRepo.getSessionId();
      if (sessionId != null) {
        await watchlistProvider.fetchWatchlistMovies(userProvider.user!.id, sessionId);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Watchlist'),
      ),
      body: Consumer<WatchlistProvider>(
        builder: (context, watchlistProvider, child) {
          if (watchlistProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (watchlistProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error loading watchlist: ${watchlistProvider.error}',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadWatchlist,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          
          final movies = watchlistProvider.watchlistMovies;
          if (movies.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.bookmark_border, size: 80, color: Colors.grey),
                    const SizedBox(height: 16),
                    const Text(
                      'Your watchlist is empty',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Add movies to your watchlist to see them here',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Browse Movies'),
                    ),
                  ],
                ),
              ),
            );
          }
          
          return RefreshIndicator(
            onRefresh: _loadWatchlist,
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: movies.length,
              itemBuilder: (ctx, index) {
                final movie = movies[index];
                return _buildMovieCard(context, movie);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildMovieCard(BuildContext context, MovieEntity movie) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(
            MovieDetailPage.routeName,
            arguments: movie.id,
          ).then((_) => _loadWatchlist()); // Refresh after returning from details
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                bottomLeft: Radius.circular(4),
              ),
              child: movie.posterPath.isNotEmpty
                  ? Image.network(
                      'https://image.tmdb.org/t/p/w200${movie.posterPath}',
                      height: 150,
                      width: 100,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      height: 150,
                      width: 100,
                      color: Colors.grey,
                      child: const Icon(Icons.movie, size: 50),
                    ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    if (movie.releaseDate.isNotEmpty)
                      Text(
                        'Released: ${movie.releaseDate}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(movie.voteAverage.toStringAsFixed(1)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      movie.overview,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              onPressed: () async {
                final userProvider = Provider.of<UserProvider>(context, listen: false);
                final userRepo = Provider.of<UserRepository>(context, listen: false);
                final watchlistProvider = Provider.of<WatchlistProvider>(context, listen: false);
                
                if (userProvider.user != null) {
                  final sessionId = await userRepo.getSessionId();
                  if (sessionId != null) {
                    try {
                      await watchlistProvider.addToWatchlist(
                        userProvider.user!.id, 
                        sessionId, 
                        movie.id, 
                        false // Remove from watchlist
                      );
                      
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Removed from watchlist')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: ${e.toString()}')),
                      );
                    }
                  }
                }
              },
              icon: const Icon(Icons.bookmark_remove, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
} 