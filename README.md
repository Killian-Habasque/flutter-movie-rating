# Movie App

A Flutter application built with clean architecture that uses [The Movie Database (TMDB) API](https://www.themoviedb.org/documentation/api) to display movies and related information.

## Features

- Browse popular movies
- Search for movies by title
- View movie details including rating, overview, and cast
- Save favorite movies

## Architecture

This application follows clean architecture principles with three main layers:

- **Domain**: Contains business logic, entities, and repository interfaces
- **Data**: Implements repositories and manages data sources
- **Presentation**: Contains UI components, screens and state management

## Getting Started

### Prerequisites

- Flutter SDK
- FVM (Flutter Version Management) installed
- The Movie DB API key

### Installation

1. Clone the repository
2. Set up your API key in the appropriate configuration file
3. Run the following command to get dependencies:

```
fvm flutter pub get
```

## Development

### Run the app

```
fvm flutter run
```

### Build commands

For Android:
```
fvm flutter build apk
```

For iOS:
```
fvm flutter build ipa
```

## Testing

Run unit tests for the movie repository:
```
flutter test test/features/movies/movie_repository_test.dart
```

## Project Structure

```
lib/
  ├── core/              # Core functionality and utilities
  ├── features/          # Feature modules
  │   └── movies/        # Movies feature
  │       ├── data/      # Data layer (repositories, models, data sources)
  │       ├── domain/    # Domain layer (entities, use cases, repository interfaces)
  │       └── presentation/ # Presentation layer (screens, widgets, state management)
  └── main.dart          # Application entry point
```

## Dependencies

- http: ^0.13.6 - For network requests
- flutter_dotenv: ^5.1.0 - For environment variable management
- provider: ^6.0.5 - For state management
- url_launcher: ^6.2.5 - For launching URLs
- shared_preferences: ^2.2.2 - For local storage

# Run cmd

fvm flutter run   

# Build cmd

fvm flutter build apk  
fvm flutter build ipa 

# Unit test 

flutter test test/features/movies/movie_repository_test.dart

