// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_application/api/api.dart';
import 'package:movie_application/detailscreen.dart';
import 'package:movie_application/movie/movie.dart';
import 'package:movie_application/searchresultscreen.dart';
import 'package:movie_application/widgets/movies_slider.dart';
import 'package:movie_application/widgets/slider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(title: 'Climax'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<Movie>> trendingMovies;
  late Future<List<Movie>> topRatedMovies;
  late Future<List<Movie>> upcomingMovies;
  late Future<List<Movie>> oncinema;
  TextEditingController searchController = TextEditingController(); // Add this line


  String currentSearchType = 'movie'; // or 'actor'
  final List<String> searchTypes = ['movie', 'actor'];

  @override
  void initState() {
    super.initState();
    trendingMovies = Api().getTrendingMovies();
    topRatedMovies = Api().getTopRatedMovies();
    upcomingMovies = Api().getUpcomingMovies();
    oncinema = Api().getwhatsoncinema();
  }
  void _search(String query) {
    // Call a function to update the UI with the search results.
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResultsScreen(query: query, searchType: currentSearchType),
      ),
    );
  }
 void _updateSearchType(String type) {
    setState(() {
      currentSearchType = type;
    });
  }

  Widget _buildSection(String title, Future<List<Movie>> moviesFuture) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: GoogleFonts.aBeeZee(fontSize: 25, color: Colors.white),
          ),
        ),
        const SizedBox(height: 32),
        SizedBox(
          height: 300,
           // Adjust as needed
          child: FutureBuilder<List<Movie>>(
            future: moviesFuture,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text(snapshot.error.toString()));
              } else if (snapshot.hasData) {
                // Assuming 'MoviesSlider' or 'TrendingSlider' is a custom widget for displaying movies
                return MoviesSlider(snapshot: snapshot); // Use appropriate slider widget here
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00000F),
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          
        ),
        actions: [
          IconButton(icon: const Icon(Icons.person), onPressed: () {}),
        ],
        backgroundColor: const Color(0xFF00000F),
      ),
 body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: searchController,
                    onSubmitted: _search,
                    decoration: InputDecoration(
                      hintText: 'Search for movies, shows, genres, etc.',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                DropdownButton<String>(
                  value: currentSearchType,
                  icon: Icon(Icons.arrow_downward),
                  elevation: 16,
                  style: TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (String? newValue) {
                    _updateSearchType(newValue!);
                  },
                  items: searchTypes.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                )
              ],
            ),

            
            _buildSection('Trending Movies', trendingMovies),
            _buildSection('Top Rated Movies', topRatedMovies),
            _buildSection('Upcoming Movies', upcomingMovies),
             _buildSection('On Cinema ', oncinema),
          ],
        ),
      ),
    );
  }
}