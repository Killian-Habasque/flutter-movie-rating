import '../../domain/entities/movie.dart';

class MovieModel extends MovieEntity {
  final bool adult;
  final String backdropPath;
  final List<int> genreIds;
  final int id;
  final String originalLanguage;
  final String originalTitle;
  final String overview;
  final double popularity;
  final String releaseDate;
  final bool video;
  final double voteAverage;
  final int voteCount;

  MovieModel({
    required super.title,
    required super.posterPath,
    required this.adult,
    required this.backdropPath,
    required this.genreIds,
    required this.id,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    required this.releaseDate,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      title: json['title'],
      posterPath: json['poster_path'] ?? '',
      adult: json['adult'] ?? true,
      backdropPath: json['backdrop_path'] ?? '',
      genreIds: List<int>.from(json['genre_ids'] ?? []),
      id: json['id'] ?? 0,
      originalLanguage: json['original_language'] ?? '',
      originalTitle: json['original_title'] ?? '',
      overview: json['overview'] ?? '',
      popularity: json['popularity']?.toDouble() ?? 0.0,
      releaseDate: json['release_date'] ?? '',
      video: json['video'] ?? true,
      voteAverage: json['vote_average']?.toDouble() ?? 0.0,
      voteCount: json['vote_count'] ?? 0,
    );
  }
}
