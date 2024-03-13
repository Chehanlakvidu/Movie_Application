class Movie{
  
  String title;
  String backDropPath; 
  String originalTitle;
  String overview;
  String posterPath;
  String releaseDate;
  double voteAverage;

Movie({
  required this.title,
  required this.backDropPath,
  required this.originalTitle,
  required this.overview,
  required this.posterPath,
  required this.releaseDate,
  required this.voteAverage,
});


factory Movie.fromJson(Map<String, dynamic> json) {
  return Movie(
    title: json["title"] ?? 'No title', // Provide a default value
    backDropPath: json["backdrop_path"] ?? '', // Assume empty string if null
    originalTitle: json["original_title"] ?? 'No original title',
    overview: json["overview"] ?? 'No overview',
    posterPath: json["poster_path"] ?? '',
    releaseDate: json["release_date"] ?? 'No release date',
    voteAverage: (json["vote_average"] ?? 0).toDouble(),
  );
}

}
class Person {
  final int id;
  final String name;

  Person({
    required this.id,
    required this.name,
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['id'],
      name: json['name'],
    );
  }
}
