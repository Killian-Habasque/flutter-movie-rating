import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:init/features/auth/domain/repositories/user_repository.dart';
import 'package:init/features/auth/presentation/providers/user_provider.dart';
import '../providers/movie_detail_provider.dart';
import '../providers/watchlist_provider.dart';

class MovieDetailPage extends StatelessWidget {
  final int movieId;
  static const routeName = '/movie_detail';

  const MovieDetailPage({super.key, required this.movieId});

  @override
  Widget build(BuildContext context) {
    Future.microtask(() {
      Provider.of<MovieDetailProvider>(
        context,
        listen: false,
      ).fetchMovieDetails(movieId);
      
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final userRepo = Provider.of<UserRepository>(context, listen: false);
      final watchlistProvider = Provider.of<WatchlistProvider>(context, listen: false);
      
      if (userProvider.user != null) {
        userRepo.getSessionId().then((sessionId) {
          if (sessionId != null && watchlistProvider.watchlistMovies.isEmpty) {
            watchlistProvider.fetchWatchlistMovies(userProvider.user!.id, sessionId);
          }
        });
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Movie Details')),
      body: Consumer<MovieDetailProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.errorMessage.isNotEmpty) {
            return Center(child: Text(provider.errorMessage));
          }

          if (provider.movieDetail == null) {
            return const Center(child: Text('No movie details found.'));
          }

          final movie = provider.movieDetail!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      // Movie image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                          height: 300,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      // Watchlist button
                      Positioned(
                        top: 10,
                        right: 10,
                        child: _buildWatchlistButton(context, movie.id),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Movie title
                  Text(
                    movie.title,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),

                  // Movie overview
                  Text(movie.overview, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 16),

                  // Release date
                  Text(
                    'Release Date: ${movie.releaseDate}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // Movie rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Vote Average:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        movie.voteAverage.toStringAsFixed(1),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Genres
                  Text(
                    'Genres: ${movie.genres.join(', ')}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // Original language
                  Text(
                    'Original Language: ${movie.originalLanguage}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // Cast
                  const Text(
                    'Cast:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  if (movie.cast.isNotEmpty)
                    ...movie.cast.map(
                      (cast) => ListTile(
                        leading:
                            cast.profilePath.isEmpty
                                ? const Icon(Icons.account_circle)
                                : Image.network(
                                  'https://image.tmdb.org/t/p/w200${cast.profilePath}',
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                        title: Text(cast.name),
                        subtitle: Text(cast.character),
                      ),
                    )
                  else
                    const Text('No cast information available.'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildWatchlistButton(BuildContext context, int movieId) {
    return Consumer2<UserProvider, WatchlistProvider>(
      builder: (context, userProvider, watchlistProvider, child) {
        // Check if user is logged in
        if (userProvider.user == null) {
          return ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please log in to add to watchlist')),
              );
            },
            icon: const Icon(Icons.login),
            label: const Text('Login to add'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black.withOpacity(0.7),
            ),
          );
        }
        
        final isInWatchlist = watchlistProvider.isMovieInWatchlist(movieId);
        
        return ElevatedButton.icon(
          onPressed: () async {
            final userRepo = Provider.of<UserRepository>(context, listen: false);
            final sessionId = await userRepo.getSessionId();
            
            if (sessionId != null) {
              try {
                await watchlistProvider.addToWatchlist(
                  userProvider.user!.id,
                  sessionId,
                  movieId,
                  !isInWatchlist, // Toggle watchlist status
                );
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isInWatchlist
                          ? 'Removed from watchlist'
                          : 'Added to watchlist',
                    ),
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: ${e.toString()}')),
                );
              }
            }
          },
          icon: Icon(
            isInWatchlist ? Icons.bookmark : Icons.bookmark_border,
          ),
          label: Text(
            isInWatchlist ? 'Remove from Watchlist' : 'Add to Watchlist',
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black.withOpacity(0.7),
            foregroundColor: isInWatchlist ? Colors.yellow : Colors.white,
          ),
        );
      },
    );
  }
}
