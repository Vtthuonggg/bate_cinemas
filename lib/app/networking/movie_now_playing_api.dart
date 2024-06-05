import 'package:flutter_app/app/networking/api_service.dart';

class MovieNowPlayingApi {
  final ApiService _apiService;

  MovieNowPlayingApi(this._apiService);

  Future<List<Map<String, dynamic>>> fetchNowPlayingMovies() async {
    try {
      final response = await _apiService.network(
        request: (request) => request.get("/api/movies/showing"),
      );

      if (response != null) {
        return List<Map<String, dynamic>>.from(response);
      } else {
        print('Failed to load now playing movies ');
        return [];
      }
    } catch (e) {
      print('Failed to fetch now playing movies: $e');
      return [];
    }
  }
}
