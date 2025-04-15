import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MovieProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Popular Movies')),
      body:
          provider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: provider.movies.length,
                itemBuilder: (context, index) {
                  final movie = provider.movies[index];
                  return ListTile(
                    leading: Image.network(
                      'https://image.tmdb.org/t/p/w200${movie.posterPath}',
                    ),
                    title: Text(movie.title),
                  );
                },
              ),
    );
  }
}
