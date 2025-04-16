import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'features/movies/data/datasources/movie_remote_datasource.dart';
import 'features/movies/data/repositories/movie_repository_impl.dart';
import 'features/movies/domain/usecases/get_popular_movies.dart';
import 'features/movies/domain/usecases/get_movie_details.dart';
import 'features/movies/presentation/providers/movie_provider.dart';
import 'features/movies/presentation/providers/movie_detail_provider.dart';
import 'features/movies/presentation/pages/home_page.dart';
import 'features/movies/presentation/pages/movie_detail_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  final movieRemoteDataSource = MovieRemoteDataSource();
  final movieRepository = MovieRepositoryImpl(movieRemoteDataSource);
  final getPopularMovies = GetPopularMovies(movieRepository);

  final getMovieDetails = GetMovieDetails(movieRepository);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => MovieProvider(getPopularMovies)..fetchMovies(),
        ),
        ChangeNotifierProvider(
          create: (_) => MovieDetailProvider(getMovieDetails),
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
      title: 'Movie App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        if (settings.name == '/movie_detail') {
          final movieId = settings.arguments as int;
          return MaterialPageRoute(
            builder: (_) => MovieDetailPage(movieId: movieId),
          );
        }
        return MaterialPageRoute(builder: (_) => const HomePage());
      },
    );
  }
}
