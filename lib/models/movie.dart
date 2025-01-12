class Movie {
  final String title;
  final String imageUrl;
  final String summary;
  final String id;
  var rating;
  var language;
  var genres;

  Movie(
      {required this.title,
      required this.imageUrl,
      required this.summary,
      required this.id,
      required this.rating,
      required this.language,
      required this.genres});

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['show']['name'],
      imageUrl: json['show']['image']?['medium'] ??
          '', // null check if image is absent
      summary: json['show']['summary'] ?? 'No summary available.',
      id: json['show']['id'].toString(),
      rating: json['show']['rating']['average'] ?? 0.0,
      language: json['show']['language'],
      genres: json['show']['genres'].cast<String>(),
    );
  }
}
