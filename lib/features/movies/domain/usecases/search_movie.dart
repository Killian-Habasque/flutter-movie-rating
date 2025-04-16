import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

class SearchMovies {
  final MovieRepository repository;

  SearchMovies(this.repository);

  Future<List<MovieEntity>> call(String query) {
    return repository.searchMovies(query);
  }
}
