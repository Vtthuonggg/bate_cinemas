import 'package:flutter/material.dart';
import 'package:flutter_app/app/networking/api_service.dart';
import 'package:flutter_app/app/networking/location_api.dart';
import 'package:flutter_app/resources/pages/book_ticker.dart';
import 'package:google_fonts/google_fonts.dart';

class FilmBranch extends StatefulWidget {
  int id;
  FilmBranch({super.key, required this.id});

  @override
  State<FilmBranch> createState() => _FilmBranchState();
}

class _FilmBranchState extends State<FilmBranch> {
  final _apiService = ApiService();
  bool _loading = false;
  Map<String, dynamic> _branchs = {};
  List<dynamic> movie = [];
  int id = 0;
  @override
  void initState() {
    super.initState();
    id = widget.id;
    getBranchWithId();
  }

  Future<void> getBranchWithId() async {
    setState(() {
      _loading = true;
    });
    var res = await LocationAPI(_apiService).getFimBranch(id);
    if (res.isNotEmpty) {
      _branchs = res;
      movie = _branchs['movies'];
      print(_branchs);
    }
    if (mounted) {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text(_branchs['name'] ?? ''),
        ),
        body: SafeArea(
          child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Phim đang chiếu",
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: movie.length,
                      itemBuilder: (context, index) {
                        final time = DateTime.parse(
                            '2022-01-01 ${movie[index]['schedules'][0]['startTime']}');
                        final formattedTime =
                            "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BookTicket(
                                            film: movie[index],
                                            time: formattedTime,
                                            roomName: movie[index]['schedules']
                                                [0]['room']['name'],
                                            branchName: _branchs['name'],
                                            address: _branchs['diaChi'],
                                            dateRealse: movie[index]
                                                ['schedules'][0]['startDate'],
                                          )));
                            },
                            child: Container(
                              width: width,
                              child: Row(children: [
                                Container(
                                  width: 150,
                                  height: 80,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      movie[index]['largeImageURL'] ??
                                          'https://via.placeholder.com/150',
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        movie[index]['name'],
                                        style: GoogleFonts.oswald(),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        movie[index]['schedules'][0]['room']
                                            ['name'],
                                        style: GoogleFonts.oswald(
                                            color: Colors.grey),
                                      ),
                                      Text(
                                        'Ngày chiếu: ${movie[index]['schedules'][0]['startDate']}',
                                        style: GoogleFonts.oswald(
                                            color: Colors.grey),
                                      ),
                                      Text(
                                        "Giờ chiếu: $formattedTime ",
                                        style: GoogleFonts.oswald(
                                            color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                )
                              ]),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              )),
        ));
  }
}
