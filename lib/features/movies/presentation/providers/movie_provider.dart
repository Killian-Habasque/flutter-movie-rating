import 'package:flutter/material.dart';
import 'package:init/features/movies/domain/usecases/get_now_playing_movies.dart';
import 'package:init/features/movies/domain/usecases/get_top_rated_movies.dart';
import '../../domain/entities/movie.dart';
import '../../domain/usecases/get_popular_movies.dart';
import '../../domain/usecases/get_upcoming_movies.dart';

class MovieProvider with ChangeNotifier {
  final GetPopularMovies getPopularMovies;
  final GetNowPlayingMovies getNowPlayingMovies;
  final GetUpcomingMovies getUpcomingMovies;
  final GetTopRatedMovies getTopRatedMovies;

  MovieProvider(
    this.getPopularMovies,
    this.getUpcomingMovies,
    this.getNowPlayingMovies,
    this.getTopRatedMovies,
  );

  List<MovieEntity> _popularMovies = [];
  List<MovieEntity> _upcomingMovies = [];
  List<MovieEntity> _getNowPlayingMovies = [];
  List<MovieEntity> _topRatedMovies = [];
  bool _isLoading = false;

  List<MovieEntity> get popularMovies => _popularMovies;
  List<MovieEntity> get upcomingMovies => _upcomingMovies;
  List<MovieEntity> get nowPlayingMovies => _getNowPlayingMovies;
  List<MovieEntity> get topRatedMovies => _topRatedMovies;
  bool get isLoading => _isLoading;

  Future<void> fetchMovies() async {
    _isLoading = true;
    notifyListeners();

    _popularMovies = await getPopularMovies();
    _upcomingMovies = await getUpcomingMovies();
    _getNowPlayingMovies = await getNowPlayingMovies();
    _topRatedMovies = await getTopRatedMovies();

    _isLoading = false;
    notifyListeners();
  }
}
