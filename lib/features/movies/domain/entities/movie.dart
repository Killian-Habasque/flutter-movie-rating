class MovieEntity {
  final int id;
  final String title;
  final String posterPath;
  final String overview;
  final double voteAverage;

  MovieEntity({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.overview,
    required this.voteAverage,
  });
}
