import 'package:flutter/foundation.dart';
import '../../domain/entities/movie.dart';
import '../../domain/usecases/search_movie.dart';

class SearchMovieProvider extends ChangeNotifier {
  SearchMovieProvider(this._searchMoviesUseCase);
  final SearchMovies _searchMoviesUseCase;

  List<MovieEntity> _searchResults = [];
  List<MovieEntity> get searchResults => _searchResults;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> searchMovies(String query) async {
    _isLoading = true;
    notifyListeners();

    try {
      _searchResults = await _searchMoviesUseCase(query);
    } catch (e) {
      if (kDebugMode) print("Error searching movies: $e");
      _searchResults = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearSearch() {
    _searchResults = [];
    notifyListeners();
  }
}
