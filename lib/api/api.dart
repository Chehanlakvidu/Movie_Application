
import 'dart:convert';

import 'package:movie_application/constant.dart';
import 'package:movie_application/movie/movie.dart';
import 'package:http/http.dart' as http;


class Api {
  static const _trendingUrl =
      'https://api.themoviedb.org/3/trending/movie/day?api_key=${Constants.apiKey}';
  static const _topRatedUrl =
      'https://api.themoviedb.org/3/movie/top_rated?api_key=${Constants.apiKey}';
  static const _upcomingUrl =
      'https://api.themoviedb.org/3/movie/upcoming?api_key=${Constants.apiKey}';

  static const _onCinemaUrl = 
      'https://api.themoviedb.org/3/movie/now_playing?api_key=${Constants.apiKey}';




  Future<List<Movie>> getSearchResults(String query) async {
  // Construct the search URL with all necessary query parameters
  final String searchUrl = 'https://api.themoviedb.org/3/search/movie'
      '?api_key=${Constants.apiKey}'
      '&language=en-US'
      '&page=1'
      '&include_adult=false'
      '&query=${Uri.encodeComponent(query)}'; // Ensure the query is properly encoded

  final response = await http.get(Uri.parse(searchUrl));

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    List<Movie> movies = (data['results'] as List).map((movieJson) => Movie.fromJson(movieJson)).toList();
    return movies;
  } else {
    throw Exception('Failed to load search results');
  }
}


      

  Future<List<Movie>> getTrendingMovies() async {
    final response = await http.get(Uri.parse(_trendingUrl));
    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body)['results'] as List;
      return decodedData.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Something happened');
    }
  }
   Future<List<Movie>> getwhatsoncinema() async {
    final response = await http.get(Uri.parse(_onCinemaUrl));
    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body)['results'] as List;
      return decodedData.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Something happened');
    }
  }

  Future<List<Movie>> getTopRatedMovies() async {
    final response = await http.get(Uri.parse(_topRatedUrl));
    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body)['results'] as List;
      return decodedData.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Something happened');
    }
  }

  Future<List<Movie>> getUpcomingMovies() async {
    final response = await http.get(Uri.parse(_upcomingUrl));
    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body)['results'] as List;
      return decodedData.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Something happened');
    }
  }

 Future<List<Movie>> getMoviesByActorName(String actorName) async {
    final String searchUrl = 'https://api.themoviedb.org/3/search/person'
        '?api_key=${Constants.apiKey}'
        '&language=en-US'
        '&page=1'
        '&include_adult=false'
        '&query=${Uri.encodeComponent(actorName)}';

    final response = await http.get(Uri.parse(searchUrl));

    if (response.statusCode == 200) {
      var searchResults = jsonDecode(response.body);
      if (searchResults['results'].isEmpty) {
        return []; // Return an empty list if no actors were found
      }
      // Assuming you're interested in the first actor found
      var actorId = searchResults['results'][0]['id'];

      return getMoviesByPersonId(actorId); // Call another method to get the actor's movies
    } else {
      throw Exception('Failed to search for actor');
    }
  }

  Future<List<Movie>> getMoviesByPersonId(int personId) async {
    final String personMoviesUrl = 'https://api.themoviedb.org/3/person/$personId/movie_credits'
        '?api_key=${Constants.apiKey}'
        '&language=en-US';

    final response = await http.get(Uri.parse(personMoviesUrl));

    if (response.statusCode == 200) {
      var credits = jsonDecode(response.body);
      List<Movie> movies = (credits['cast'] as List).map((movieJson) => Movie.fromJson(movieJson)).toList();
      return movies;
    } else {
      throw Exception('Failed to load movies for person id $personId');
    }
  }
}

