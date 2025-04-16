import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:init/features/movies/data/models/movie_detail_model.dart';
import '../../../../core/constants.dart';
import '../models/movie_model.dart';

class MovieRemoteDataSource {
  Future<List<MovieModel>> fetchPopularMovies() async {
    final response = await http.get(
      Uri.parse('$baseUrl/movie/popular?api_key=$apiKey'),
    );

    if (response.statusCode == 200) {
      final List results = json.decode(response.body)['results'];
      return results.map((e) => MovieModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch popular movies');
    }
  }

  Future<MovieDetailModel> fetchMovieDetails(int movieId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/movie/$movieId?api_key=$apiKey'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> result = json.decode(response.body);
      return MovieDetailModel.fromJson(result);
    } else {
      throw Exception('Failed to fetch movie details');
    }
  }
}
