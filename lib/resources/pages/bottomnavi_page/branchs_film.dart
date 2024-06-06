import 'package:flutter/material.dart';
import 'package:flutter_app/app/networking/api_service.dart';
import 'package:flutter_app/app/networking/location_api.dart';
import 'package:flutter_app/resources/pages/detail_film.dart';
import 'package:flutter_app/resources/pages/film_branch.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';

class BranchFilm extends StatefulWidget {
  const BranchFilm({super.key});

  @override
  State<BranchFilm> createState() => _BranchFilmState();
}

class _BranchFilmState extends State<BranchFilm> {
  final _apiService = ApiService();
  List<Map<String, dynamic>> _branchs = [];
  bool _loading = false;
  @override
  void initState() {
    super.initState();
    setupLocation();
  }

  Future<void> setupLocation() async {
    await getLocation();
    getUserLocation();
  }

  Future<void> getLocation() async {
    setState(() {
      _loading = true;
    });
    var res = await LocationAPI(_apiService).getLocation();
    if (res.isNotEmpty) {
      _branchs = res;
      print(_branchs);
    }
    setState(() {
      _loading = false;
    });
  }

  Future<void> getUserLocation() async {
    setState(() {
      _loading = true;
    });
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    for (var branch in _branchs) {
      try {
        double distanceInMeters = Geolocator.distanceBetween(position.latitude,
            position.longitude, branch['latitude'], branch['longitude']);
        print(position.latitude);
        branch['distance'] = distanceInMeters / 1000; // Convert to kilometers
      } catch (e) {
        print('Error calculating distance: $e');
        branch['distance'] = null;
      }
    }
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: _loading
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            )
          : Scaffold(
              appBar: AppBar(
                title: Text('Rạp phim gần bạn'),
              ),
              body: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView.builder(
                    itemCount: _branchs.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FilmBranch(
                                  id: _branchs[index]['id'],
                                ),
                              ),
                            );
                          },
                          child: Container(
                            height: height / 10,
                            width: width,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  _branchs[index]['name'],
                                  style: TextStyle(fontSize: 18),
                                ),
                                Text(
                                    '${_branchs[index]['distance'].toStringAsFixed(1)} km'),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  )),
            ),
    );
  }
}
