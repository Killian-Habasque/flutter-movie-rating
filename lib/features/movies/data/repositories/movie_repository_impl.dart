import 'package:init/features/movies/data/datasources/movie_remote_datasource.dart';
import 'package:init/features/movies/domain/entities/movie_detail.dart';

import '../../domain/entities/movie.dart';
import '../../domain/repositories/movie_repository.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource remoteDataSource;

  MovieRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<MovieEntity>> getPopularMovies() {
    return remoteDataSource.fetchPopularMovies();
  }

  @override
  Future<MovieDetailEntity> getMovieDetails(int movieId) async {
    final movieModel = await remoteDataSource.fetchMovieDetails(movieId);

    return MovieDetailEntity.fromModel(movieModel);
  }
}
