import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flix_mate/services/api_service.dart';
import 'package:flix_mate/models/movie.dart';
import 'details_screen.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();

  late Future<List<Movie>> dramaMovies;
  late Future<List<Movie>> comedyMovies;
  late Future<List<Movie>> sportsMovies;
  late Future<List<Movie>> horrorMovies;
  late Future<List<Movie>> animeMovies;

  @override
  void initState() {
    super.initState();
    dramaMovies = _apiService.fetchMoviesByGenre('drama');
    comedyMovies = _apiService.fetchMoviesByGenre('comedy');
    sportsMovies = _apiService.fetchMoviesByGenre('sports');
    horrorMovies = _apiService.fetchMoviesByGenre('horror');
    animeMovies = _apiService.fetchMoviesByGenre('anime');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('FlixMate',
            style: TextStyle(
                color: Colors.red, fontWeight: FontWeight.bold, fontSize: 35)),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchScreen()),
              );
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.black,
        child: ListView(
          children: [
            // Genre: Drama
            GenreSlider(genre: 'Drama', moviesFuture: dramaMovies),

            // Genre: Anime
            GenreSlider(genre: 'Anime', moviesFuture: animeMovies),

            // Genre: Comedy
            GenreSlider(genre: 'Comedy', moviesFuture: comedyMovies),

            // Genre: Sports
            GenreSlider(genre: 'Sports', moviesFuture: sportsMovies),

            // Genre: Horror
            GenreSlider(genre: 'Horror', moviesFuture: horrorMovies),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.white,
        onTap: (index) {
          if (index == 0) {
            Navigator.pop(context);
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SearchScreen()),
            );
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
        ],
      ),
    );
  }
}

class GenreSlider extends StatelessWidget {
  final String genre;
  final Future<List<Movie>> moviesFuture;

  GenreSlider({required this.genre, required this.moviesFuture});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            genre,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        FutureBuilder<List<Movie>>(
          future: moviesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                  child: Text('Error: ${snapshot.error}',
                      style: TextStyle(color: Colors.white)));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                  child: Text('No movies found.',
                      style: TextStyle(color: Colors.white)));
            }

            return Container(
              height: 280, // Height of the slider
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final movie = snapshot.data![index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailsScreen(movie: movie),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl: movie.imageUrl,
                              fit: BoxFit.cover,
                              width: 140,
                              height: 200,
                              placeholder: (context, url) =>
                                  Center(child: CircularProgressIndicator()),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: EdgeInsets.all(8.0),
                              color: Colors.black.withOpacity(0.5),
                              child: Text(
                                movie.title,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
