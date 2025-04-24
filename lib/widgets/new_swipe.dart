import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart'; // Use this one!
import '../models/tmdb.dart';
import '../models/tmdb_services.dart';
import '../widgets/film_card.dart';

class NewSwipe extends StatefulWidget {
  const NewSwipe({super.key});

  @override
  State<NewSwipe> createState() => _SwipeScreenState();
}

class _SwipeScreenState extends State<NewSwipe> {
  final _fnameController = TextEditingController();
  Map<int, String> genres = {};
  List<Movie> _selectedMovies = [];
  bool _showForm = true;

  @override
  void initState() {
    super.initState();
    loadGenres();
  }

  Future<void> loadGenres() async {
    genres = await movieService.fetchGenres();
    setState(() {});
  }

  void swipeForm() {
    setState(() {
      _showForm = false;
    });
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
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: _fnameController,
                      decoration: InputDecoration(labelText: "Friend's name"),
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
                : Swiper(
                    itemBuilder: (BuildContext context, int index) {
                      final movie = _selectedMovies[index];
                      return FilmCard(
                        title: movie.movieTitle,
                        plot: movie.moviePlot,
                        posterUrl: movie.posterUrl,
                      );
                    },
                    itemCount: _selectedMovies.length,
                    layout: SwiperLayout.TINDER,
                    itemWidth: MediaQuery.of(context).size.width * 0.9,
                    itemHeight: MediaQuery.of(context).size.height * 0.6,
                  ),
      ),
    );
  }
}
