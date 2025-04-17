import 'package:init/features/movies/domain/entities/watchlist.dart';
import 'package:init/features/movies/domain/repositories/movie_repository.dart';

class AddToWatchlistUseCase {
  final MovieRepository repository;

  AddToWatchlistUseCase(this.repository);

  Future<WatchlistResponse> execute(int accountId, String sessionId, int movieId, bool add) {
    return repository.addToWatchlist(accountId, sessionId, movieId, add);
  }
} 