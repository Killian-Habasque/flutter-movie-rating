import 'package:init/features/movies/domain/entities/movie.dart';
import 'package:init/features/movies/domain/entities/movie_detail.dart';

abstract class MovieRepository {
  Future<List<MovieEntity>> getPopularMovies();

  Future<MovieDetailEntity> getMovieDetails(int movieId);

  Future<List<MovieEntity>> searchMovies(String query);
}
