// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_application/api/api.dart';
import 'package:movie_application/movie/movie.dart';
import 'package:movie_application/searchresultscreen.dart';
import 'package:movie_application/widgets/movies_slider.dart';


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
  late Future<List<Movie>> watchListMovies; // Add this line
  final WatchListManager watchListManager = WatchListManager(); // Add this line



  String currentSearchType = 'movie'; // or 'actor'
  final List<String> searchTypes = ['movie', 'actor'];

  @override
  void initState() {
    super.initState();
    trendingMovies = Api().getTrendingMovies();
    topRatedMovies = Api().getTopRatedMovies();
    upcomingMovies = Api().getUpcomingMovies();
    oncinema = Api().getwhatsoncinema();
    _fetchWatchListMovies();
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
   void _fetchWatchListMovies() async {
    final List<int> watchListIds = await watchListManager.getWatchList();
    // Assuming you have a method in your API class to fetch movies by a list of IDs
    watchListMovies = Api().getMoviesByIds(watchListIds);
    setState(() {}); // Notify the UI that data is ready to be refreshed
  }
   void addToWatchList(int movieId) async {
    await watchListManager.addToWatchList(movieId);
    // You might want to fetch the updated watch list movies here
    _fetchWatchListMovies();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Added to your Watch List!')),
    );
  }
  void removeFromWatchList(int movieId) async {
  await watchListManager.removeFromWatchList(movieId);
  _fetchWatchListMovies(); // Refresh the watch list to reflect changes
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Removed from your Watch List')),
  );
}


    Widget _movieItem(Movie movie) {
    return Card(
      child: Row(
        children: [
          // Movie poster/thumbnail
          Image.network(
            'https://image.tmdb.org/t/p/w500${movie.posterPath}',
            width: 100,
            height: 150,
            fit: BoxFit.cover,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Your movie metadata (like rating, release date, etc)
                Text('Rating: ${movie.voteAverage}'),
                // Add to watch list button
                ElevatedButton(
                  onPressed: () => addToWatchList(movie.id),
                  child: Text('Add to Watch List'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
Widget _buildWatchListSection() {
  return FutureBuilder<List<Movie>>(
    future: watchListMovies,
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Center(child: Text("Error fetching watch list"));
      } else if (snapshot.hasData) {
        return MoviesSlider(
          snapshot: snapshot,
          onAddToWatchList: addToWatchList,
          isInWatchList: (int movieId) => watchListManager.isInWatchList(movieId), // Implement this method
          onRemoveFromWatchList: removeFromWatchList,
        );
      } else {
        return const Center(child: CircularProgressIndicator());
      }
    },
  );
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
        child: FutureBuilder<List<Movie>>(
          future: moviesFuture,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            } else if (snapshot.hasData) {
              return MoviesSlider(
                snapshot: snapshot,
                onAddToWatchList: addToWatchList,
isInWatchList: (int movieId) => watchListManager.isInWatchList(movieId),
                onRemoveFromWatchList: removeFromWatchList,
              );
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


Widget _watchListMovieItem(Movie movie) {
  return Card(
    child: Row(
      children: [
        Image.network(
          'https://image.tmdb.org/t/p/w500${movie.posterPath}',
          width: 100,
          height: 150,
          fit: BoxFit.cover,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                movie.title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text('Rating: ${movie.voteAverage}'),
              ElevatedButton(
                onPressed: () => removeFromWatchList(movie.id),
                child: Text('Remove from Watch List'),
                style: ElevatedButton.styleFrom(
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget buildWatchListSection() {
  return FutureBuilder<List<Movie>>(
    future: watchListMovies,
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Center(child: Text("Error fetching watch list"));
      } else if (snapshot.hasData) {
        // Here we use a ListView to display the watch list movies with the remove button
        return ListView.builder(
          physics: NeverScrollableScrollPhysics(), // Disables scrolling in the ListView
          shrinkWrap: true, // Allows ListView to occupy only the space it needs
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            return _watchListMovieItem(snapshot.data![index]);
          },
        );
      } else {
        return const Center(child: CircularProgressIndicator());
      }
    },
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
              Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Your Watch List',
                style: GoogleFonts.aBeeZee(fontSize: 25, color: Colors.white),
              ),
            ),
            const SizedBox(height: 32),
            _buildWatchListSection(), // Display the watch list section
          ],
        ),
      ),
    );
  }
}