import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flix_mate/models/movie.dart';

class ApiService {
  static const String _baseUrl = 'https://api.tvmaze.com/search/shows?q=';

  Future<List<Movie>> fetchMovies(String query) async {
    final response = await http.get(Uri.parse('$_baseUrl$query'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }

  Future<List<Movie>> fetchMoviesByGenre(String genre) async {
    return fetchMovies(genre);
  }
}
