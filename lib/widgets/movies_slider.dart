

// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:movie_application/constant.dart';
import 'package:movie_application/detailscreen.dart';
import 'package:movie_application/movie/movie.dart';

class MoviesSlider extends StatelessWidget {
  const MoviesSlider({
    super.key,
    required this.snapshot,
        required this.onAddToWatchList, 
    required this.isInWatchList, 
    required this.onRemoveFromWatchList,

  });
  final AsyncSnapshot<List<Movie>> snapshot; 
  final Function(int) onAddToWatchList; 
  final bool Function(int) isInWatchList; 
  final Function(int) onRemoveFromWatchList; 


  
   @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: snapshot.data!.length,
        itemBuilder: (context, index) {
          final movie = snapshot.data![index]; 
          return Stack( 
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailsScreen(
                          movie: movie,
                        ),
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      height: 200,
                      width: 150,
                      child: Image.network(
                        '${Constants.imagePath}${movie.posterPath}', 
                        filterQuality: FilterQuality.high,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned( // Positioned the button on the top-right of the movie item
                top: 8,
                right: 8,
                child: IconButton(
                  icon: Icon(Icons.add_circle, color: Colors.white),
                  onPressed: () => onAddToWatchList(movie.id), 
                ),
              ),
               Positioned(
                top: 8,
                right: 8,
                child: isInWatchList(movie.id)
                    ? IconButton(
                        icon: Icon(Icons.remove_circle, color: Colors.red),
                        onPressed: () => onRemoveFromWatchList(movie.id), // Remove from watch list
                      )
                    : IconButton(
                        icon: Icon(Icons.add_circle, color: Colors.white),
                        onPressed: () => onAddToWatchList(movie.id), // Add to watch list
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}