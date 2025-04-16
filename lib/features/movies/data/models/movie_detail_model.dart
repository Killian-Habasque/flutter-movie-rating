import 'cast_model.dart';

class MovieDetailModel {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final double voteAverage;
  final String releaseDate;
  final List<String> genres;
  final String originalLanguage;
  final List<CastModel> cast;
  final int runtime;
  final int budget;
  final int revenue;
  final String tagline;
  final String backdropPath;

  MovieDetailModel({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
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

  factory MovieDetailModel.fromJson(Map<String, dynamic> json) {
    var castJson = json['credits']?['cast'] as List? ?? [];

    return MovieDetailModel(
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
      cast: castJson.map((e) => CastModel.fromJson(e)).toList(),
      runtime: json['runtime'] ?? 0,
      budget: json['budget'] ?? 0,
      revenue: json['revenue'] ?? 0,
      tagline: json['tagline'] ?? '',
      backdropPath: json['backdrop_path'] ?? '',
    );
  }
}
