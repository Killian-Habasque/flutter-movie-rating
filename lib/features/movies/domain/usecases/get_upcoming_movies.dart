import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

class GetUpcomingMovies {
  final MovieRepository repository;

  GetUpcomingMovies(this.repository);

  Future<List<MovieEntity>> call() => repository.getUpcomingMovies();
}
