
import 'dart:convert';

import 'package:movie_application/constant.dart';
import 'package:movie_application/movie/movie.dart';
import 'package:http/http.dart' as http;


class Api{
  static const _trendingUrl = 'https://api.themoviedb.org/3/trending/movie/day?api_key=${Constants.apiKey}' ;

  Future<List<Movie>> getTrendingMovies() async{
    final response = await http.get(Uri.parse(_trendingUrl));
    if(response.statusCode == 200){
      final decodedData = json.decode(response.body)['results'] as List;
      print(decodedData);
      return decodedData.map((movie)=> Movie.fromJson(movie)).toList();
    }else{
      throw Exception("error occured");
    }
    
  }
}