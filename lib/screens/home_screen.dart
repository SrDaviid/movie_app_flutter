import 'package:flutter/material.dart';
import 'package:movie_app/providers/movies_providers.dart';
import 'package:movie_app/search/search_delegate.dart';
import 'package:movie_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Movies in theaters'),
          centerTitle: true,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(
                Icons.search,
              ),
              onPressed: () =>
                  showSearch(context: context, delegate: MovieSearchDelegate()),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              //Primary Cards
              CardSwiper(
                movies: moviesProvider.onDisplayMovies,
              ),

              //Movie Slicer
              MovieSlider(
                movies: moviesProvider.onDisplayPopularMovies,
                title: 'Popular',
                onNextPage: () {
                  moviesProvider.getPopularMovies();
                },
              ),

              //Listado horizontal de peliculas
            ],
          ),
        ));
  }
}
