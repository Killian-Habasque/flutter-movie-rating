import 'package:init/features/movies/data/datasources/movie_remote_datasource.dart';
import 'package:init/features/movies/domain/entities/movie_detail.dart';

import '../../domain/entities/movie.dart';
import '../../domain/repositories/movie_repository.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource remoteDataSource;

  MovieRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<MovieEntity>> getPopularMovies() async {
    // Récupère les MovieModel et les convertis en MovieEntity
    final popularMovies = await remoteDataSource.fetchPopularMovies();
    return popularMovies
        .map((model) => model.toEntity())
        .toList(); // Conversion
  }

  @override
  Future<MovieDetailEntity> getMovieDetails(int movieId) async {
    final movieModel = await remoteDataSource.fetchMovieDetails(movieId);

    return MovieDetailEntity.fromModel(movieModel);
  }

  @override
  Future<List<MovieEntity>> searchMovies(String query) async {
    final results = await remoteDataSource.searchMovies(query);
    return results.map((model) => MovieEntity.fromModel(model)).toList();
  }
}
