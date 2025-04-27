import 'package:flutter/material.dart';
import 'package:tcard/tcard.dart'; 
import '../models/tmdb.dart';
import '../models/tmdb_services.dart';
import 'film_card.dart';
import '../services/database_services.dart';
import '../services/firebase_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewSwipe extends StatefulWidget {
  final String sessionId;

  const NewSwipe({super.key, required this.sessionId});

  @override
  State<NewSwipe> createState() => _SwipeScreenState();
}

class _SwipeScreenState extends State<NewSwipe> {
  Map<int, String> genres = {};
  List<Map<String, dynamic>> _dropFriends = [];
  Map<String, dynamic>? selectedFriend;
  List<Movie> _selectedMovies = [];
  int? currentUserId;
  bool _showForm = true;
  Map<int, String> _friendMap = {};
  int? _selectedFriendId;

  List<Movie> likedMovies = [];    // Store liked movies
  List<Movie> dislikedMovies = []; // Store disliked movies

  @override
  void initState() {
    super.initState();
    _sessionId = widget.sessionId;
    loadGenres();
    loadFriends();
  }

  Future<void> loadGenres() async {
    genres = await movieService.fetchGenres();
    setState(() {});
  }

  Future<void> loadFriends() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userID');

    if (userId != null) {
      final friends = await DatabaseServices.getFriends(userId);
      setState(() {
        _friendMap = {
          for (var friend in friends)
            friend['userID'] as int: friend['userName'] as String
        };
      });
    }
  }

  void swipeForm() {
    setState(() {
      _showForm = false;
    });
  }

  late String _sessionId ='';

  Future<void> startSwipe() async {
    final userA = currentUserId;
    final userB = _selectedFriendId;
    final movieIds = _selectedMovies.map((m) => m.movieID.toString()).toList();

    //_sessionId = await createSession(userA, userB, movieIds);
    print("Session started: $_sessionId");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("New swipe")),
      body: SafeArea(
        child: _showForm
            ? Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: DropdownButtonFormField<int>(
                      decoration: InputDecoration(labelText: "Who would you like to swipe with?"),
                      items: _friendMap.entries
                          .map((entry) => DropdownMenuItem<int>(
                                value: entry.key,
                                child: Text(entry.value),
                              ))
                          .toList(),
                      onChanged: (friendID) {
                        setState(() {
                          _selectedFriendId = friendID;
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: DropdownButtonFormField<int>(
                      decoration: InputDecoration(labelText: "Pick a genre"),
                      items: genres.entries
                          .map((entry) => DropdownMenuItem<int>(
                                value: entry.key,
                                child: Text(entry.value),
                              ))
                          .toList(),
                      onChanged: (genreId) async {
                        if (genreId != null) {
                          final movies =
                              await movieService.fetchMoviesByGenre(genreId);
                          setState(() {
                            _selectedMovies = movies;
                          });
                        }
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: swipeForm,
                    child: Text("Start swiping!"),
                  ),
                ],
              )
            : _selectedMovies.isEmpty
                ? Center(child: Text("No movies loaded"))
                : TCard(
                    cards: _selectedMovies.map((movie) => FilmCard(
                      title: movie.movieTitle,
                      plot: movie.moviePlot,
                      posterUrl: movie.posterUrl,
                    )).toList(),
                    size: Size(
                      MediaQuery.of(context).size.width * 0.9,
                      MediaQuery.of(context).size.height * 0.6,
                    ),
                    onForward: (index, info) {
                      final swipedMovie = _selectedMovies[index];
                      if (info.direction == SwipDirection.Right) {
                        storeSwipe(sessionID: _sessionId, userID: currentUserId.toString(), movieID: swipedMovie.movieID.toString(), liked: true);
                        Match(sessionID: _sessionId, userID: currentUserId.toString(), movieID: swipedMovie.movieID.toString(), liked: true);
                        print("Liked movie: ${swipedMovie.movieTitle}");
                        likedMovies.add(swipedMovie);
                      } else if (info.direction == SwipDirection.Left) {
                        storeSwipe(sessionID: _sessionId, userID: currentUserId.toString(), movieID: swipedMovie.toString(), liked: false);
                        print("Disliked movie: ${swipedMovie.movieTitle}");
                        dislikedMovies.add(swipedMovie);
                      }
                    },
                    onEnd: () {
                      print("All cards swiped!");
                      print("Liked movies: ${likedMovies.map((m) => m.movieTitle)}");
                      print("Disliked movies: ${dislikedMovies.map((m) => m.movieTitle)}");
                      // Here you can upload the liked/disliked movies to Firebase or your backend.
                    },
                  ),
      ),
    );
  }
}

