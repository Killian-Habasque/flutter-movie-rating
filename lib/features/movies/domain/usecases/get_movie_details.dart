import 'package:init/features/movies/domain/entities/movie_detail.dart';

import '../repositories/movie_repository.dart';

class GetMovieDetails {
  final MovieRepository movieRepository;

  GetMovieDetails(this.movieRepository);

  Future<MovieDetailEntity> execute(int movieId) {
    return movieRepository.getMovieDetails(movieId);
  }
}
