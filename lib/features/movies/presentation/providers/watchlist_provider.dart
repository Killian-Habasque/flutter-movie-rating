import 'package:flutter/material.dart';
import 'package:init/features/movies/domain/entities/movie.dart';
import 'package:init/features/movies/domain/entities/watchlist.dart';
import 'package:init/features/movies/domain/usecases/add_to_watchlist_usecase.dart';
import 'package:init/features/movies/domain/usecases/get_watchlist_movies_usecase.dart';

class WatchlistProvider with ChangeNotifier {
  final AddToWatchlistUseCase addToWatchlistUseCase;
  final GetWatchlistMoviesUseCase getWatchlistMoviesUseCase;

  WatchlistProvider({
    required this.addToWatchlistUseCase,
    required this.getWatchlistMoviesUseCase,
  });

  List<MovieEntity> _watchlistMovies = [];
  bool _isLoading = false;
  String? _error;

  List<MovieEntity> get watchlistMovies => _watchlistMovies;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchWatchlistMovies(int accountId, String sessionId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _watchlistMovies = await getWatchlistMoviesUseCase.execute(accountId, sessionId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<WatchlistResponse> addToWatchlist(int accountId, String sessionId, int movieId, bool add) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await addToWatchlistUseCase.execute(accountId, sessionId, movieId, add);
            if (response.success && !add) {
        _watchlistMovies.removeWhere((movie) => movie.id == movieId);
      } else if (response.success && add) {
        await fetchWatchlistMovies(accountId, sessionId);
      }

      _isLoading = false;
      notifyListeners();
      return response;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      throw e;
    }
  }

  bool isMovieInWatchlist(int movieId) {
    return _watchlistMovies.any((movie) => movie.id == movieId);
  }
} 