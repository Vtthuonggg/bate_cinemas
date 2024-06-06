import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/app/networking/api_service.dart';
import 'package:flutter_app/app/networking/movie_now_playing_api.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchingPage extends StatefulWidget {
  const SearchingPage({Key? key}) : super(key: key);

  @override
  State<SearchingPage> createState() => _SearchingPageState();
}

class _SearchingPageState extends State<SearchingPage> {
  final _apiService = ApiService();
  late MovieNowPlayingApi movieNowPlayingApi;

  List<Map<String, dynamic>> movies = [];
  List<Map<String, dynamic>> filteredMovies = [];
  String search = '';
  @override
  void initState() {
    super.initState();
    movieNowPlayingApi = MovieNowPlayingApi(_apiService);
    fetchMovies();
  }

  Future fetchMovies() async {
    try {
      var res = await movieNowPlayingApi.fetchMovies();
      setState(() {
        movies = res;
        filteredMovies =
            movies.length > 10 ? movies.sublist(0, 10) : List.from(movies);
        print(filteredMovies);
        print(movies);
      });
    } catch (e) {
      print('Lỗi: $e');
    }
    print('Movies::: $movies');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tìm kiếm phim'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(children: [
            TextField(
              cursorColor: Colors.blue,
              decoration: InputDecoration(
                labelText: 'Nhập tên phim',
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  search = value.toLowerCase();
                  if (search.isEmpty) {
                    filteredMovies = movies.length > 10
                        ? movies.sublist(0, 10)
                        : List.from(movies);
                  } else {
                    filteredMovies = movies.where((movie) {
                      return movie['name'].toLowerCase().contains(search);
                    }).toList();
                  }
                });
              },
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: filteredMovies.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: GestureDetector(
                      child: Row(children: [
                        Container(
                          width: 150,
                          height: 80,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              filteredMovies[index]['largeImageURL'],
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: Text(
                            filteredMovies[index]['name'],
                            style: GoogleFonts.oswald(),
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ]),
                    ),
                  );
                },
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
