import 'package:flutter_test/flutter_test.dart';
import 'package:init/features/movies/domain/entities/movie.dart';
import 'package:init/features/movies/domain/entities/movie_detail.dart';
import 'package:init/features/movies/domain/entities/watchlist.dart';
import 'package:init/features/movies/domain/repositories/movie_repository.dart';

class FakeMovieRepository implements MovieRepository {
  List<MovieEntity>? _popularMoviesResult;
  List<MovieEntity>? _upcomingMoviesResult;
  List<MovieEntity>? _topRatedMoviesResult;
  List<MovieEntity>? _nowPlayingMoviesResult;
  MovieDetailEntity? _movieDetailsResult;
  List<MovieEntity>? _searchMoviesResult;
  WatchlistResponse? _addToWatchlistResult;
  List<MovieEntity>? _watchlistMoviesResult;
  
  int getPopularMoviesCalls = 0;
  int getUpcomingMoviesCalls = 0;
  int getTopRatedMoviesCalls = 0;
  int getNowPlayingMoviesCalls = 0;
  int getMovieDetailsCalls = 0;
  int searchMoviesCalls = 0;
  int addToWatchlistCalls = 0;
  int getWatchlistMoviesCalls = 0;
  
  int? lastMovieDetailsId;
  String? lastSearchQuery;
  int? lastAddToWatchlistAccountId;
  String? lastAddToWatchlistSessionId;
  int? lastAddToWatchlistMovieId;
  bool? lastAddToWatchlistAdd;
  int? lastWatchlistAccountId;
  String? lastWatchlistSessionId;

  void setupGetPopularMovies(List<MovieEntity> result) {
    _popularMoviesResult = result;
  }
  
  void setupGetUpcomingMovies(List<MovieEntity> result) {
    _upcomingMoviesResult = result;
  }
  
  void setupGetTopRatedMovies(List<MovieEntity> result) {
    _topRatedMoviesResult = result;
  }
  
  void setupGetNowPlayingMovies(List<MovieEntity> result) {
    _nowPlayingMoviesResult = result;
  }
  
  void setupGetMovieDetails(MovieDetailEntity result) {
    _movieDetailsResult = result;
  }
  
  void setupSearchMovies(List<MovieEntity> result) {
    _searchMoviesResult = result;
  }
  
  void setupAddToWatchlist(WatchlistResponse result) {
    _addToWatchlistResult = result;
  }
  
  void setupGetWatchlistMovies(List<MovieEntity> result) {
    _watchlistMoviesResult = result;
  }

  // Implémentations de l'interface
  @override
  Future<List<MovieEntity>> getPopularMovies() async {
    getPopularMoviesCalls++;
    return _popularMoviesResult ?? [];
  }

  @override
  Future<List<MovieEntity>> getUpcomingMovies() async {
    getUpcomingMoviesCalls++;
    return _upcomingMoviesResult ?? [];
  }

  @override
  Future<List<MovieEntity>> getTopRatedMovies() async {
    getTopRatedMoviesCalls++;
    return _topRatedMoviesResult ?? [];
  }

  @override
  Future<List<MovieEntity>> getNowPlayingMovies() async {
    getNowPlayingMoviesCalls++;
    return _nowPlayingMoviesResult ?? [];
  }

  @override
  Future<MovieDetailEntity> getMovieDetails(int movieId) async {
    getMovieDetailsCalls++;
    lastMovieDetailsId = movieId;
    if (_movieDetailsResult == null) {
      throw Exception('Movie details not found');
    }
    return _movieDetailsResult!;
  }

  @override
  Future<List<MovieEntity>> searchMovies(String query) async {
    searchMoviesCalls++;
    lastSearchQuery = query;
    return _searchMoviesResult ?? [];
  }

  @override
  Future<WatchlistResponse> addToWatchlist(int accountId, String sessionId, int movieId, bool add) async {
    addToWatchlistCalls++;
    lastAddToWatchlistAccountId = accountId;
    lastAddToWatchlistSessionId = sessionId;
    lastAddToWatchlistMovieId = movieId;
    lastAddToWatchlistAdd = add;
    if (_addToWatchlistResult == null) {
      throw Exception('Failed to add to watchlist');
    }
    return _addToWatchlistResult!;
  }

  @override
  Future<List<MovieEntity>> getWatchlistMovies(int accountId, String sessionId) async {
    getWatchlistMoviesCalls++;
    lastWatchlistAccountId = accountId;
    lastWatchlistSessionId = sessionId;
    return _watchlistMoviesResult ?? [];
  }
}

void main() {
  late FakeMovieRepository fakeMovieRepository;

  setUp(() {
    fakeMovieRepository = FakeMovieRepository();
  });

  group('MovieRepository Tests', () {
    test('getPopularMovies returns a list of movies', () async {
      // Arrange
      final movies = [
        MovieEntity(
          id: 1,
          title: 'Test Movie',
          posterPath: '/path/to/poster.jpg',
          overview: 'A test movie overview',
          voteAverage: 8.5,
          releaseDate: '2023-01-01',
          genres: ['Action', 'Thriller'],
          originalLanguage: 'en',
          runtime: 120,
          budget: 150000000,
          revenue: 350000000,
          tagline: 'Test tagline',
          backdropPath: '/path/to/backdrop.jpg',
        ),
      ];
      
      fakeMovieRepository.setupGetPopularMovies(movies);

      // Act
      final result = await fakeMovieRepository.getPopularMovies();

      // Assert
      expect(result, isA<List<MovieEntity>>());
      expect(result.length, 1);
      expect(result.first.title, 'Test Movie');
      expect(fakeMovieRepository.getPopularMoviesCalls, 1);
    });

    test('getMovieDetails returns movie details for valid ID', () async {
      // Arrange
      final movieDetail = MovieDetailEntity(
        id: 1,
        title: 'Test Movie',
        posterPath: '/path/to/poster.jpg',
        overview: 'A test movie overview',
        voteAverage: 8.5,
        releaseDate: '2023-01-01',
        genres: ['Action', 'Thriller'],
        originalLanguage: 'en',
        runtime: 120,
        budget: 150000000,
        revenue: 350000000,
        tagline: 'Test tagline',
        backdropPath: '/path/to/backdrop.jpg',
        cast: [],
      );
      
      fakeMovieRepository.setupGetMovieDetails(movieDetail);

      // Act
      final result = await fakeMovieRepository.getMovieDetails(1);

      // Assert
      expect(result, isA<MovieDetailEntity>());
      expect(result.id, 1);
      expect(result.title, 'Test Movie');
      expect(fakeMovieRepository.getMovieDetailsCalls, 1);
      expect(fakeMovieRepository.lastMovieDetailsId, 1);
    });

    test('searchMovies returns movies matching the query', () async {
      // Arrange
      final searchResults = [
        MovieEntity(
          id: 1,
          title: 'Test Movie',
          posterPath: '/path/to/poster.jpg',
          overview: 'A test movie overview',
          voteAverage: 8.5,
          releaseDate: '2023-01-01',
          genres: ['Action', 'Thriller'],
          originalLanguage: 'en',
          runtime: 120,
          budget: 150000000,
          revenue: 350000000,
          tagline: 'Test tagline',
          backdropPath: '/path/to/backdrop.jpg',
        ),
      ];
      
      fakeMovieRepository.setupSearchMovies(searchResults);

      // Act
      final result = await fakeMovieRepository.searchMovies('test');

      // Assert
      expect(result, isA<List<MovieEntity>>());
      expect(result.length, 1);
      expect(result.first.title, 'Test Movie');
      expect(fakeMovieRepository.searchMoviesCalls, 1);
      expect(fakeMovieRepository.lastSearchQuery, 'test');
    });

    test('addToWatchlist returns success response', () async {
      // Arrange
      final watchlistResponse = WatchlistResponse(
        success: true,
        statusCode: 1,
        statusMessage: 'Success',
      );
      
      fakeMovieRepository.setupAddToWatchlist(watchlistResponse);

      // Act
      final result = await fakeMovieRepository.addToWatchlist(1, 'test-session-id', 1, true);

      // Assert
      expect(result, isA<WatchlistResponse>());
      expect(result.success, true);
      expect(result.statusMessage, 'Success');
      expect(fakeMovieRepository.addToWatchlistCalls, 1);
      expect(fakeMovieRepository.lastAddToWatchlistAccountId, 1);
      expect(fakeMovieRepository.lastAddToWatchlistSessionId, 'test-session-id');
      expect(fakeMovieRepository.lastAddToWatchlistMovieId, 1);
      expect(fakeMovieRepository.lastAddToWatchlistAdd, true);
    });

    test('getWatchlistMovies returns user watchlist', () async {
      // Arrange
      final watchlistMovies = [
        MovieEntity(
          id: 1,
          title: 'Test Movie',
          posterPath: '/path/to/poster.jpg',
          overview: 'A test movie overview',
          voteAverage: 8.5,
          releaseDate: '2023-01-01',
          genres: ['Action', 'Thriller'],
          originalLanguage: 'en',
          runtime: 120,
          budget: 150000000,
          revenue: 350000000,
          tagline: 'Test tagline',
          backdropPath: '/path/to/backdrop.jpg',
        ),
      ];
      
      fakeMovieRepository.setupGetWatchlistMovies(watchlistMovies);

      // Act
      final result = await fakeMovieRepository.getWatchlistMovies(1, 'test-session-id');

      // Assert
      expect(result, isA<List<MovieEntity>>());
      expect(result.length, 1);
      expect(result.first.title, 'Test Movie');
      expect(fakeMovieRepository.getWatchlistMoviesCalls, 1);
      expect(fakeMovieRepository.lastWatchlistAccountId, 1);
      expect(fakeMovieRepository.lastWatchlistSessionId, 'test-session-id');
    });
  });
} 