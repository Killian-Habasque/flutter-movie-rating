import 'package:init/features/movies/domain/entities/movie.dart';
import 'package:init/features/movies/domain/repositories/movie_repository.dart';

class GetWatchlistMoviesUseCase {
  final MovieRepository repository;

  GetWatchlistMoviesUseCase(this.repository);

  Future<List<MovieEntity>> execute(int accountId, String sessionId) {
    return repository.getWatchlistMovies(accountId, sessionId);
  }
} 