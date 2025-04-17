import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:init/features/movies/data/models/movie_detail_model.dart';
import 'package:init/features/movies/data/models/watchlist_response_model.dart';
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
      Uri.parse(
        '$baseUrl/movie/$movieId?api_key=$apiKey&append_to_response=credits',
      ),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> result = json.decode(response.body);

      return MovieDetailModel.fromJson(result);
    } else {
      throw Exception('Failed to fetch movie details');
    }
  }

  Future<List<MovieModel>> fetchNowPlayingMovies() async {
    final response = await http.get(
      Uri.parse('$baseUrl/movie/now_playing?api_key=$apiKey'),
    );

    if (response.statusCode == 200) {
      final List results = json.decode(response.body)['results'];
      return results.map((e) => MovieModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch popular movies');
    }
  }

  Future<List<MovieModel>> fetchUpcomingMovies() async {
    final response = await http.get(
      Uri.parse('$baseUrl/movie/upcoming?api_key=$apiKey'),
    );

    if (response.statusCode == 200) {
      final List results = json.decode(response.body)['results'];
      return results.map((e) => MovieModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch popular movies');
    }
  }

  Future<List<MovieModel>> fetchTopRatedMovies() async {
    final response = await http.get(
      Uri.parse('$baseUrl/movie/top_rated?api_key=$apiKey'),
    );

    if (response.statusCode == 200) {
      final List results = json.decode(response.body)['results'];
      return results.map((e) => MovieModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch popular movies');
    }
  }

  Future<List<MovieModel>> searchMovies(String query) async {
    final response = await http.get(
      Uri.parse('$baseUrl/search/movie?api_key=$apiKey&query=$query'),
    );

    if (response.statusCode == 200) {
      final List results = json.decode(response.body)['results'];
      return results.map((e) => MovieModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to search movies');
    }
  }
  
  Future<WatchlistResponseModel> addToWatchlist(int accountId, String sessionId, int movieId, bool add) async {
    final url = Uri.parse(
        '$baseUrl/account/$accountId/watchlist?api_key=$apiKey&session_id=$sessionId');
    
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'media_type': 'movie',
          'media_id': movieId,
          'watchlist': add,
        }),
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = json.decode(response.body);
        return WatchlistResponseModel.fromJson(jsonData);
      } else {
        throw Exception('Failed to update watchlist: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to update watchlist: $e');
    }
  }
  
  Future<List<MovieModel>> fetchWatchlistMovies(int accountId, String sessionId) async {
    final url = Uri.parse(
        '$baseUrl/account/$accountId/watchlist/movies?api_key=$apiKey&session_id=$sessionId');
    
    try {
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final List results = jsonData['results'] ?? [];
        return results.map((e) => MovieModel.fromJson(e)).toList();
      } else {
        throw Exception('Failed to fetch watchlist movies: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to fetch watchlist movies: $e');
    }
  }
}
