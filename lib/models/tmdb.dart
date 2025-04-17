import 'package:tmdb_api/tmdb_api.dart';

void main() async {
  final String apiKey = 'a806ec775a332aa18053c0e6ff76233f';
  final String readAccessTokenV4 = 'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJhODA2ZWM3NzVhMzMyYWExODA1M2MwZTZmZjc2MjMzZiIsIm5iZiI6MTc0NDYzNDMwMS43NzIsInN1YiI6IjY3ZmQwMWJkN2MyOWFlNWJjM2Q5NDdmOSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.0_a0lXQOUt5I6SBYkX8UigW7M_IwxzPrqt_9Pjni4TU'; // Optional but recommended

  TMDB tmdb = TMDB(
    ApiKeys(apiKey, readAccessTokenV4),
    logConfig: ConfigLogger(showLogs: true, showErrorLogs: true),
  );

  //Map trending = await tmdb.v3.trending.getTrending();
  //print(trending);
}


