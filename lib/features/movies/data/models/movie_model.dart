import '../../domain/entities/movie.dart';

class MovieModel extends Movie {
  MovieModel({required super.title, required super.posterPath});

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      title: json['title'],
      posterPath: json['poster_path'] ?? '',
    );
  }
}
