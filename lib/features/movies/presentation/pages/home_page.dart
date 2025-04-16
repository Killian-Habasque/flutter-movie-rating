import 'package:flutter/material.dart';
import 'package:init/features/movies/presentation/delegates/movie_search_delegate.dart';
import 'package:init/features/movies/presentation/providers/search_movie_provider.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MovieProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies'),
        actions: [
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
        ],
      ),
      body:
          provider.isLoading
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
        Navigator.pushNamed(context, '/movie_detail', arguments: movie.id);
      },
    );
  }
}
