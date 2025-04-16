import 'package:init/features/movies/data/datasources/movie_remote_datasource.dart';
import 'package:init/features/movies/domain/entities/movie_detail.dart';

import '../../domain/entities/movie.dart';
import '../../domain/repositories/movie_repository.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource remoteDataSource;

  MovieRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<MovieEntity>> getPopularMovies() async {
    final popularMovies = await remoteDataSource.fetchPopularMovies();
    return popularMovies.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<MovieEntity>> getNowPlayingMovies() async {
    final nowPlayingMoview = await remoteDataSource.fetchNowPlayingMovies();
    return nowPlayingMoview.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<MovieEntity>> getUpcomingMovies() async {
    final upcomingMovies = await remoteDataSource.fetchUpcomingMovies();
    return upcomingMovies.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<MovieEntity>> getTopRatedMovies() async {
    final topRatedMovies = await remoteDataSource.fetchTopRatedMovies();
    return topRatedMovies.map((model) => model.toEntity()).toList();
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
