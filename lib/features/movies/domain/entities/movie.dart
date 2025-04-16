import 'package:init/features/movies/data/models/movie_model.dart';

class MovieEntity {
  final int id;
  final String title;
  final String posterPath;
  final String overview;
  final double voteAverage;
  final String releaseDate;
  final List<String> genres;
  final String originalLanguage;
  final int runtime;
  final int budget;
  final int revenue;
  final String tagline;
  final String backdropPath;

  MovieEntity({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.overview,
    required this.voteAverage,
    required this.releaseDate,
    required this.genres,
    required this.originalLanguage,
    required this.runtime,
    required this.budget,
    required this.revenue,
    required this.tagline,
    required this.backdropPath,
  });

  factory MovieEntity.fromModel(MovieModel model) {
    return MovieEntity(
      id: model.id,
      title: model.title,
      posterPath: model.posterPath,
      overview: model.overview,
      voteAverage: model.voteAverage,
      releaseDate:
          model.releaseDate, // Assurez-vous de le prendre de MovieModel
      genres: model.genres, // Assurez-vous de le prendre de MovieModel
      originalLanguage:
          model.originalLanguage, // Assurez-vous de le prendre de MovieModel
      runtime: model.runtime, // Assurez-vous de le prendre de MovieModel
      budget: model.budget, // Assurez-vous de le prendre de MovieModel
      revenue: model.revenue, // Assurez-vous de le prendre de MovieModel
      tagline: model.tagline, // Assurez-vous de le prendre de MovieModel
      backdropPath:
          model.backdropPath, // Assurez-vous de le prendre de MovieModel
    );
  }
}
