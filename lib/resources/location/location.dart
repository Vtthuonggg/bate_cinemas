import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/networking/api_service.dart';
import 'package:flutter_app/app/networking/location_api.dart';
import 'package:flutter_app/resources/pages/book_ticker.dart';
import 'package:flutter_app/resources/pages/film_branch.dart';
import 'package:geolocator/geolocator.dart';

class Location extends StatefulWidget {
  dynamic movideDetail;
  Location({super.key, required this.movideDetail});

  @override
  State<Location> createState() => _LocationState();
}

class _LocationState extends State<Location> {
  List<bool> expandedIndex = [];
  ApiService _apiService = ApiService();
  dynamic movideDetail = {};
  List<dynamic> branches = [];
  bool _loading = false;
  @override
  void initState() {
    super.initState();
    movideDetail = widget.movideDetail;

    print(movideDetail);
    setupLocation();
  }

  Future<void> setupLocation() async {
    await getBranchWithMovie(movideDetail['id']);
    await getUserLocation();
    expandedIndex =
        List.generate(branches.length, (index) => index == 0 ? true : false);
    print(expandedIndex);
  }

  Future<void> getBranchWithMovie(int movieId) async {
    setState(() {
      _loading = true;
    });
    var res = await LocationAPI(_apiService).getFimBranchWithMovieId(movieId);
    branches = res;
    print('branches: $branches');
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
    for (var branch in branches) {
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
    branches.sort((a, b) => a['distance'].compareTo(b['distance']));
    if (mounted) {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Rạp phim gần bạn'),
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: branches.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              expandedIndex[index] = !expandedIndex[index];
                            });
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
                                  branches[index]['name'],
                                  style: TextStyle(fontSize: 18),
                                ),
                                Text(
                                    '${branches[index]['distance'].toStringAsFixed(1)} km' ??
                                        '0'),
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        expandedIndex[index] =
                                            !expandedIndex[index];
                                      });
                                    },
                                    icon: Icon(
                                      expandedIndex[index]
                                          ? Icons.expand_less
                                          : Icons.expand_more,
                                      color: Colors.blue,
                                    )),
                              ],
                            ),
                          ),
                        ),
                        if (expandedIndex[index])
                          Container(
                              height: 60,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount:
                                      branches[index]['schedules'].length,
                                  itemBuilder: (context, subIndex) {
                                    final time = DateTime.parse(
                                        '2022-01-01 ${branches[index]['schedules'][subIndex]['startTime']}');
                                    final formattedTime =
                                        "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
                                    return Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              153, 187, 222, 251),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      BookTicket(
                                                        film: branches[index],
                                                        time: formattedTime,
                                                        roomName: branches[
                                                                        index][
                                                                    'schedules']
                                                                [subIndex]
                                                            ['room']['name'],
                                                        branchName:
                                                            branches[index]
                                                                ['name'],
                                                        address: branches[index]
                                                            ['diaChi'],
                                                        dateRealse: branches[
                                                                        index][
                                                                    'schedules']
                                                                [subIndex]
                                                            ['startDate'],
                                                      )),
                                            );
                                          },
                                          child: Text(
                                            formattedTime,
                                            style: TextStyle(
                                                color: Colors.grey[900]),
                                          ),
                                        ),
                                      ),
                                    );
                                  }))
                      ],
                    ),
                  );
                },
              )),
    );
  }
}
