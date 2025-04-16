import 'package:init/features/movies/data/models/movie_detail_model.dart';

class MovieDetailEntity {
  final int id;
  final String title;
  final String posterPath;
  final String overview;
  final double voteAverage;
  final String releaseDate;
  final List<String> genres;
  final String originalLanguage;
  final List<Cast> cast;
  final int runtime;
  final int budget;
  final int revenue;
  final String tagline;
  final String backdropPath;

  MovieDetailEntity({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.overview,
    required this.voteAverage,
    required this.releaseDate,
    required this.genres,
    required this.originalLanguage,
    required this.cast,
    required this.runtime,
    required this.budget,
    required this.revenue,
    required this.tagline,
    required this.backdropPath,
  });

  factory MovieDetailEntity.fromModel(MovieDetailModel model) {
    return MovieDetailEntity(
      id: model.id,
      title: model.title,
      posterPath: model.posterPath,
      overview: model.overview,
      voteAverage: model.voteAverage,
      releaseDate: model.releaseDate,
      genres: model.genres,
      originalLanguage: model.originalLanguage,
      cast:
          model.cast
              .map(
                (c) => Cast(
                  name: c.name,
                  character: c.character,
                  profilePath: c.profilePath,
                ),
              )
              .toList(),
      runtime: model.runtime,
      budget: model.budget,
      revenue: model.revenue,
      tagline: model.tagline,
      backdropPath: model.backdropPath,
    );
  }
}

class Cast {
  final String name;
  final String character;
  final String profilePath;

  Cast({
    required this.name,
    required this.character,
    required this.profilePath,
  });
}
