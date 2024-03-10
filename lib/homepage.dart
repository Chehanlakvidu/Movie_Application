import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

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
  // Example categories
  final List<String> categories = ['Top Rated', 'New Releases', 'Popular'];

  // This would be your API data
  final Map<String, List<String>> movies = {
    'Top Rated': ['Movie 1', 'Movie 2', 'Movie 3'],
    'New Releases': ['Movie A', 'Movie B', 'Movie C'],
    'Popular': ['Film X', 'Film Y', 'Film Z'],
  };

  Widget _buildMovieCategory(String category) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(category, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        ),
        SizedBox(
          height: 200, // Adjust height to fit your content
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movies[category]?.length ?? 0,
            itemBuilder: (context, index) {
              // Replace with a widget that displays the movie data
              return Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Image.network(
                  'https://via.placeholder.com/150', // Replace with movie image URL
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.person), onPressed: () {}),
        ],
      ),
      body: ListView(
        children: <Widget>[
          // Search bar at the top
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search for movies, shows, genres, etc.',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          ...categories.map((category) => _buildMovieCategory(category)).toList(),
        ],
      ),
    );
  }
}
