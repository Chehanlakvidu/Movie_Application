// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:movie_application/api/api.dart';
import 'package:movie_application/detailscreen.dart';
import 'package:movie_application/movie/movie.dart';

class SearchResultsScreen extends StatelessWidget {
  final String query;
  final String searchType; // Add this line

  const SearchResultsScreen({Key? key, required this.query, required this.searchType}) : super(key: key); // Update constructor

  @override
  Widget build(BuildContext context) {
    // Decide which future to use based on the search type
    Future<List<Movie>> searchResults;
    if (searchType == 'actor') {
      searchResults = Api().getMoviesByActorName(query); // Search by actor name
    } else {
      searchResults = Api().getSearchResults(query); // Search by movie title
    }

    return Scaffold(
      appBar: AppBar(title: Text('Search Results')),
      body: FutureBuilder<List<Movie>>(
        future: searchResults,// This method needs to be defined in your Api class.
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            // We assume snapshot.data won't be null because of the hasData check.
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Movie movie = snapshot.data![index];
                return ListTile(
                  title: Text(movie.title),
                  subtitle: Text(movie.releaseDate), // Optional: Add more details if you want
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DetailsScreen(movie: movie)),
                    );
                  },
                );
              },
            );
          } else {
            return Text('No results found');
          }
        },
      ),
    );
  }
}
