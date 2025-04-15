import '../entities/movie.dart';

abstract class MovieRepository {
  Future<List<MovieEntity>> getPopularMovies();
}
