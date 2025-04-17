import 'package:init/features/movies/domain/entities/movie.dart';
import 'package:init/features/movies/domain/entities/movie_detail.dart';
import 'package:init/features/movies/domain/entities/watchlist.dart';

abstract class MovieRepository {
  Future<List<MovieEntity>> getPopularMovies();

  Future<List<MovieEntity>> getUpcomingMovies();

  Future<List<MovieEntity>> getTopRatedMovies();

  Future<List<MovieEntity>> getNowPlayingMovies();

  Future<MovieDetailEntity> getMovieDetails(int movieId);

  Future<List<MovieEntity>> searchMovies(String query);
  
  Future<WatchlistResponse> addToWatchlist(int accountId, String sessionId, int movieId, bool add);
  
  Future<List<MovieEntity>> getWatchlistMovies(int accountId, String sessionId);
}
