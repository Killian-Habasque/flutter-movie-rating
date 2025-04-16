import 'package:flutter/material.dart';
import 'package:init/features/movies/presentation/delegates/movie_search_delegate.dart';
import 'package:provider/provider.dart';
import '../providers/search_movie_provider.dart';

class MovieSearchPage extends StatelessWidget {
  const MovieSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<SearchMovieProvider>(
      context,
      listen: false,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Search'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: MovieSearchDelegate(searchProvider),
              );
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('Tap the search icon to look for movies!'),
      ),
    );
  }
}
