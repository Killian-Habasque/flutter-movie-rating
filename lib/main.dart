import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'features/movies/data/datasources/movie_remote_datasource.dart';
import 'features/movies/data/repositories/movie_repository_impl.dart';
import 'features/movies/domain/usecases/get_popular_movies.dart';
import 'features/movies/presentation/providers/movie_provider.dart';
import 'features/movies/presentation/pages/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  final movieRemoteDataSource = MovieRemoteDataSource();
  final movieRepository = MovieRepositoryImpl(movieRemoteDataSource);
  final getPopularMovies = GetPopularMovies(movieRepository);

  runApp(
    ChangeNotifierProvider(
      create: (_) => MovieProvider(getPopularMovies)..fetchMovies(),
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
      home: const HomePage(),
    );
  }
}
