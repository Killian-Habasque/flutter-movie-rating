import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/search_movie_provider.dart';

class MovieSearchDelegate extends SearchDelegate {
  final SearchMovieProvider searchProvider;
  Timer? _debounce;

  MovieSearchDelegate(this.searchProvider);

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          searchProvider.clearSearch();
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    searchProvider.searchMovies(query);
    return _buildMovieList(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return const Center(child: Text('Search for a movie...'));
    }

    _onQueryChanged(query);

    return _buildMovieList(context);
  }

  void _onQueryChanged(String _) {
    final currentQuery = query;

    searchProvider.clearSearch();

    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (currentQuery.isNotEmpty) {
        searchProvider.searchMovies(currentQuery);
      }
    });
  }

  Widget _buildMovieList(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: searchProvider,
      child: Consumer<SearchMovieProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.searchResults.isEmpty) {
            return const Center(child: Text('No results found.'));
          }

          return ListView.builder(
            itemCount: provider.searchResults.length,
            itemBuilder: (context, index) {
              final movie = provider.searchResults[index];

              return ListTile(
                leading: Image.network(
                  'https://image.tmdb.org/t/p/w200${movie.posterPath}',
                  width: 50,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (_, __, ___) => const Icon(Icons.image_not_supported),
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
                  close(context, null);
                  Navigator.pushNamed(
                    context,
                    '/movie_detail',
                    arguments: movie.id,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
