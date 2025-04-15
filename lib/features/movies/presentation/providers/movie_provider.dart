import 'package:flutter/material.dart';
import '../../domain/entities/movie.dart';
import '../../domain/usecases/get_popular_movies.dart';

class MovieProvider with ChangeNotifier {
  final GetPopularMovies getPopularMovies;

  MovieProvider(this.getPopularMovies);

  List<MovieEntity> _movies = [];
  bool _isLoading = false;

  List<MovieEntity> get movies => _movies;
  bool get isLoading => _isLoading;

  Future<void> fetchMovies() async {
    _isLoading = true;
    notifyListeners();

    _movies = await getPopularMovies();
    _isLoading = false;
    notifyListeners();
  }
}
