import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/movie_detail_provider.dart';

class MovieDetailPage extends StatelessWidget {
  final int movieId;

  const MovieDetailPage({super.key, required this.movieId});
  static Route<void> route({required int movieId}) {
    return MaterialPageRoute<void>(
      settings: const RouteSettings(name: '/movie_detail'),

      builder: (_) => MovieDetailPage(movieId: movieId),
    );
  }

  @override
  Widget build(BuildContext context) {
    Future.microtask(() {
      Provider.of<MovieDetailProvider>(
        context,
        listen: false,
      ).fetchMovieDetails(movieId);
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
                  // Image du film
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                      height: 300,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Titre du film
                  Text(
                    movie.title,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),

                  // Aperçu du film
                  Text(movie.overview, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 16),

                  // Date de sortie
                  Text(
                    'Release Date: ${movie.releaseDate}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // Note du film
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

                  // Langue d'origine
                  Text(
                    'Original Language: ${movie.originalLanguage}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // Casting
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
}
