import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:init/features/auth/data/repositories/user_repository_impl.dart';
import 'package:init/features/auth/domain/repositories/user_repository.dart';
import 'package:init/features/auth/presentation/providers/user_provider.dart';
import 'package:init/features/movies/domain/usecases/add_to_watchlist_usecase.dart';
import 'package:init/features/movies/domain/usecases/get_watchlist_movies_usecase.dart';
import 'package:init/features/movies/presentation/pages/movie_detail_page.dart';
import 'package:init/features/movies/presentation/pages/watchlist_page.dart';
import 'package:init/features/movies/presentation/providers/watchlist_provider.dart';
import 'package:provider/provider.dart';
import 'package:init/core/constants.dart';

// Movie data & logic
import 'features/movies/data/datasources/movie_remote_datasource.dart';
import 'features/movies/data/repositories/movie_repository_impl.dart';
import 'features/movies/domain/usecases/get_now_playing_movies.dart';
import 'features/movies/domain/usecases/get_popular_movies.dart';
import 'features/movies/domain/usecases/get_upcoming_movies.dart';
import 'features/movies/domain/usecases/get_top_rated_movies.dart';
import 'features/movies/domain/usecases/get_movie_details.dart';
import 'features/movies/domain/usecases/search_movie.dart';
import 'features/movies/presentation/providers/movie_provider.dart';
import 'features/movies/presentation/providers/movie_detail_provider.dart';
import 'features/movies/presentation/providers/search_movie_provider.dart';
import 'features/movies/presentation/pages/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  final movieRemoteDataSource = MovieRemoteDataSource();
  final movieRepository = MovieRepositoryImpl(movieRemoteDataSource);
  
  // Auth repositories
  final userRepository = UserRepositoryImpl(apiKey);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create:
              (_) => MovieProvider(
                GetPopularMovies(movieRepository),
                GetUpcomingMovies(movieRepository),
                GetNowPlayingMovies(movieRepository),
                GetTopRatedMovies(movieRepository),
              )..fetchMovies(),
        ),
        ChangeNotifierProvider(
          create: (_) => SearchMovieProvider(SearchMovies(movieRepository)),
        ),
        ChangeNotifierProvider(
          create: (_) => MovieDetailProvider(GetMovieDetails(movieRepository)),
        ),
        ChangeNotifierProvider(
          create: (_) => UserProvider(userRepository: userRepository),
        ),
        // Provide user repository for watchlist actions
        Provider<UserRepository>(
          create: (_) => userRepository,
        ),
        // Watchlist provider
        ChangeNotifierProvider(
          create: (_) => WatchlistProvider(
            addToWatchlistUseCase: AddToWatchlistUseCase(movieRepository),
            getWatchlistMoviesUseCase: GetWatchlistMoviesUseCase(movieRepository),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
      routes: {
        WatchlistPage.routeName: (context) => const WatchlistPage(),
        MovieDetailPage.routeName: (context) {
          final movieId = ModalRoute.of(context)!.settings.arguments as int;
          return MovieDetailPage(movieId: movieId);
        },
      },
    );
  }
}
