import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/models/models.dart';

class MoviesProvider extends ChangeNotifier {
  final String _baseUrl = "api.themoviedb.org";
  final String _apiKey = "1a5b6715e26af9ce3b547ef57cbb4d89";
  final String _language = 'en-US';

  List<Movie> onDisplayMovies = [];
  List<Movie> onDisplayPopularMovies = [];

  //Es un int debido a que es el movie_id
  Map<int, List<Cast>> moviesCast = {};

  int _popularPage = 0;

  MoviesProvider() {
    getOnDisplayMovies();
    getPopularMovies();
  }

  Future<String> _getJsonData(String endpoint, [int page = 1]) async {
    final url = Uri.https(_baseUrl, endpoint,
        {"api_key": _apiKey, "_language": _language, "page": "$page"});

    final response = await http.get(url);
    return response.body;
  }

  getOnDisplayMovies() async {
    final jsonData = await _getJsonData("3/movie/now_playing");
    final nowPlayingResponse = NowPlayingResponse.fromJson(jsonData);

    onDisplayMovies = nowPlayingResponse.results;
    notifyListeners();
  }

  getPopularMovies() async {
    _popularPage++;
    final jsonData = await _getJsonData("3/movie/popular", _popularPage);
    final popularResponse = PopularResponse.fromJson(jsonData);

    onDisplayPopularMovies = [
      ...onDisplayPopularMovies,
      ...popularResponse.results
    ];
    notifyListeners();
  }

  Future<List<Cast>> getMovieCast(int movieId) async {
    if (moviesCast.containsKey(movieId)) return moviesCast[movieId]!;

    final jsonData = await _getJsonData("3/movie/$movieId/credits");
    final creditsResponse = CreditsResponse.fromJson(jsonData);

    moviesCast[movieId] = creditsResponse.cast;

    return creditsResponse.cast;
  }

  Future<List<Movie>> searchMovies(String query) async {
    final url = Uri.https(_baseUrl, "3/search/movie",
        {"api_key": _apiKey, "_language": _language, "query": query});

    final response = await http.get(url);
    final searchResponse = SearchMovieResponse.fromJson(response.body);

    return searchResponse.results;
  }
}
