import 'package:tmdb_api/tmdb_api.dart';
import 'tmdb.dart';

class movieService {

  static final TMDB tmdb = TMDB(
    ApiKeys('a806ec775a332aa18053c0e6ff76233f', 'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJhODA2ZWM3NzVhMzMyYWExODA1M2MwZTZmZjc2MjMzZiIsIm5iZiI6MTc0NDYzNDMwMS43NzIsInN1YiI6IjY3ZmQwMWJkN2MyOWFlNWJjM2Q5NDdmOSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.0_a0lXQOUt5I6SBYkX8UigW7M_IwxzPrqt_9Pjni4TU'),
    logConfig: ConfigLogger(showLogs: true, showErrorLogs: true),
  );

  static Future<List<Movie>> fetchTrendingMovies() async {
    final data = await tmdb.v3.trending.getTrending();
    List moviesJson = data['results'];
    return moviesJson.map((m) => Movie.fromJson(m)).toList();
  }

  static Future<List<Movie>> fetchMoviesByGenre(int genreId) async {
    final data = await tmdb.v3.discover.getMovies(
      withGenres: genreId.toString(),
    );
    List results = data['results'];
    return results.map((json) => Movie.fromJson(json)).toList();
  }

  static Future<Map<int, String>> fetchGenres() async {
    final genreData = await tmdb.v3.genres.getMovieList();
    final genres = genreData['genres'] as List;
    return {
      for (var genre in genres) genre['id'] as int: genre['name'] as String
    };
  }
}