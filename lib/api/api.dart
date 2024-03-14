
// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:movie_application/constant.dart';
import 'package:movie_application/movie/movie.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';



class Api {
  static const _trendingUrl =
      'https://api.themoviedb.org/3/trending/movie/day?api_key=${Constants.apiKey}';
  static const _topRatedUrl =
      'https://api.themoviedb.org/3/movie/top_rated?api_key=${Constants.apiKey}';
  static const _upcomingUrl =
      'https://api.themoviedb.org/3/movie/upcoming?api_key=${Constants.apiKey}';

  static const _onCinemaUrl = 
      'https://api.themoviedb.org/3/movie/now_playing?api_key=${Constants.apiKey}';


  static const _baseUrl = 'https://api.themoviedb.org/3';

  String _movieDetailsUrl(int movieId) => '$_baseUrl/movie/$movieId?api_key=${Constants.apiKey}';



 Future<List<Movie>> getMoviesByIds(List<int> movieIds) async {
    List<Movie> movies = [];
    for (int movieId in movieIds) {
      final response = await http.get(Uri.parse(_movieDetailsUrl(movieId)));
      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);
        movies.add(Movie.fromJson(decodedData));
      } else {
        print('Failed to load movie details for movie ID $movieId');
       
      }
    }
    return movies;
  }
  Future<List<Movie>> getSearchResults(String query) async {
  // Construct the search URL with all necessary query parameters
  final String searchUrl = 'https://api.themoviedb.org/3/search/movie'
      '?api_key=${Constants.apiKey}'
      '&language=en-US'
      '&page=1'
      '&include_adult=false'
      '&query=${Uri.encodeComponent(query)}'; 

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
      
      var actorId = searchResults['results'][0]['id'];

      return getMoviesByPersonId(actorId); 
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

class WatchListManager {
  static const String _watchListKey = 'watchList';
  List<int> _cachedWatchList = [];

  WatchListManager() {
    _loadWatchList();
  }

  // Load the watch list from SharedPreferences
  Future<void> _loadWatchList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? watchListJson = prefs.getString(_watchListKey);
    if (watchListJson != null) {
      List<dynamic> jsonList = jsonDecode(watchListJson);
      _cachedWatchList = jsonList.cast<int>();
    }
  }

  // Add a movie ID to the watch list
  Future<void> addToWatchList(int movieId) async {
    if (!_cachedWatchList.contains(movieId)) {
      _cachedWatchList.add(movieId);
      await _saveWatchList();
    }
  }

  // Remove a movie ID from the watch list
  Future<void> removeFromWatchList(int movieId) async {
    if (_cachedWatchList.remove(movieId)) {
      await _saveWatchList();
    }
  }

  // Save the watch list to SharedPreferences
  Future<void> _saveWatchList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String watchListJson = jsonEncode(_cachedWatchList);
    await prefs.setString(_watchListKey, watchListJson);
  }

  // Check if a movie ID is in the watch list
  bool isInWatchList(int movieId) {
    return _cachedWatchList.contains(movieId);
  }

  // Get the current watch list
  List<int> getWatchList() {
    return _cachedWatchList;
  }
}
