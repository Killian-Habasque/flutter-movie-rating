import 'package:init/features/movies/domain/entities/movie.dart';

class MovieModel {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final double voteAverage;
  final String releaseDate;
  final List<String> genres;
  final String originalLanguage;
  final int runtime;
  final int budget;
  final int revenue;
  final String tagline;
  final String backdropPath;

  MovieModel({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
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

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'] ?? '',
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
      releaseDate: json['release_date'] ?? '',
      genres: List<String>.from(
        json['genres']?.map((g) => g['name'] ?? '') ?? [],
      ),
      originalLanguage: json['original_language'] ?? '',
      runtime: json['runtime'] ?? 0,
      budget: json['budget'] ?? 0,
      revenue: json['revenue'] ?? 0,
      tagline: json['tagline'] ?? '',
      backdropPath: json['backdrop_path'] ?? '',
    );
  }

  // Définir la méthode toEntity ici
  MovieEntity toEntity() {
    return MovieEntity(
      id: id,
      title: title,
      posterPath: posterPath,
      overview: overview,
      voteAverage: voteAverage,
      releaseDate: releaseDate,
      genres: genres,
      originalLanguage: originalLanguage,
      runtime: runtime,
      budget: budget,
      revenue: revenue,
      tagline: tagline,
      backdropPath: backdropPath,
    );
  }
}
