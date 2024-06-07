import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/networking/api_service.dart';
import 'package:flutter_app/app/networking/location_api.dart';

class Location extends StatefulWidget {
  dynamic movideDetail;
  Location({super.key, required this.movideDetail});

  @override
  State<Location> createState() => _LocationState();
}

class _LocationState extends State<Location> {
  ApiService _apiService = ApiService();
  dynamic movideDetail = {};
  List<dynamic> branches = [];
  @override
  void initState() {
    super.initState();
    movideDetail = widget.movideDetail;
    getBranchWithMovie(movideDetail['id']);
  }

  Future<void> getBranchWithMovie(int movieId) async {
    var res = await LocationAPI(_apiService).getFimBranchWithMovieId(movieId);
    branches = res;
    print('branches: $branches');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rạp phim gần bạn'),
      ),
    );
  }
}
