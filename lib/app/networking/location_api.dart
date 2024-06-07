import 'package:flutter_app/app/networking/api_service.dart';

class LocationAPI {
  final ApiService _apiService;
  LocationAPI(this._apiService);
  getLocation() async {
    try {
      final response = await _apiService.network(
        request: (request) => request.get("/api/branches"),
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

  getFimBranch(int branchId) async {
    try {
      final response = await _apiService.network(
        request: (request) => request.get("/api/branches/branches-movies"),
      );

      if (response != null) {
        return response[branchId - 1];
      } else {
        print('Failed to load now playing movies ');
        return [];
      }
    } catch (e) {
      print('Failed to fetch now playing movies: $e');
      return [];
    }
  }

  getFimBranchWithMovieId(int movieId) async {
    try {
      final response = await _apiService.network(
        request: (request) => request
            .get("/api/branches/movie/branches-schedules", queryParameters: {
          'movie_id': movieId,
        }),
      );

      if (response != null) {
        return response;
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
