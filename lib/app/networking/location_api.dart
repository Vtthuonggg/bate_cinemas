import 'dart:convert';

import 'package:flutter_app/app/networking/api_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
}
