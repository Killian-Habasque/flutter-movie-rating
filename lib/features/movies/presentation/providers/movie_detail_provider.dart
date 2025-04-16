import 'package:flutter/material.dart';
import '../../domain/entities/movie_detail.dart';
import '../../domain/usecases/get_movie_details.dart';

class MovieDetailProvider extends ChangeNotifier {
  final GetMovieDetails getMovieDetails;

  MovieDetailEntity? movieDetail;
  bool isLoading = false;
  String errorMessage = '';

  MovieDetailProvider(this.getMovieDetails);

  Future<void> fetchMovieDetails(int movieId) async {
    isLoading = true;
    notifyListeners();

    try {
      movieDetail = await getMovieDetails.execute(movieId);
      isLoading = false;
    } catch (error) {
      isLoading = false;
      errorMessage = error.toString();
    }
    notifyListeners();
  }
}
