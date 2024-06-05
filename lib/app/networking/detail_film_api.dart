import 'package:flutter_app/app/networking/api_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MovieDetailApi {
  final ApiService _apiService;

  MovieDetailApi(this._apiService, {required int movieId});

  Future<Map<String, dynamic>> fetchMovieDetail(int movieId) async {
    try {
      final response = await _apiService.network(
        request: (request) => request
            .get("/api/movies/details", queryParameters: {'movieId': movieId}),
      );

      return response;
    } catch (e) {
      print('Failed to fetch movie details: $e');
      return {};
    }
  }

  Future<Map<String, dynamic>> getTrailer(int movieId) async {
    try {
      final response = await _apiService.network(
        request: (request) => request.get("/movie/$movieId/videos"),
      );
      if (response != null) {
        print(response);
        return Map<String, dynamic>.from(response);
      } else {
        print('Failed to load movie details');
        return {};
      }
    } catch (e) {
      print('Failed to fetch movie details: $e');
      return {};
    }
  }
}
