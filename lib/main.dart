import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:init/features/movies/data/datasources/movie_remote_datasource.dart';
import 'package:init/features/movies/data/repositories/movie_repository_impl.dart';
import 'package:init/features/movies/domain/usecases/get_popular_movies.dart';
import 'package:init/features/movies/presentation/pages/movie_home_screen.dart';
import 'package:init/features/movies/presentation/providers/movie_provider.dart';
import 'package:provider/provider.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/data/services/auth_service.dart';
import 'core/constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  final movieRemoteDataSource = MovieRemoteDataSource();
  final movieRepository = MovieRepositoryImpl(movieRemoteDataSource);
  final getPopularMovies = GetPopularMovies(movieRepository);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => MovieProvider(getPopularMovies)..fetchMovies(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authRepository = AuthRepository(apiKey);
    final authService = AuthService();

    return MaterialApp(
      title: 'TMDB App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MovieHomeScreen(),
      routes: {
        '/login':
            (context) => LoginScreen(
              authRepository: authRepository,
              authService: authService,
            ),
      },
    );
  }
}