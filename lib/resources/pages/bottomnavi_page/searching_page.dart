import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/app/networking/api_service.dart';
import 'package:flutter_app/app/networking/movie_now_playing_api.dart';
import 'package:flutter_app/resources/pages/dashed_divide.dart';
import 'package:flutter_app/resources/pages/detail_film.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:diacritic/diacritic.dart';

class SearchingPage extends StatefulWidget {
  const SearchingPage({Key? key}) : super(key: key);

  @override
  State<SearchingPage> createState() => _SearchingPageState();
}

class _SearchingPageState extends State<SearchingPage> {
  final _apiService = ApiService();
  late MovieNowPlayingApi movieNowPlayingApi;
  bool _loading = false;
  List<String> ageRatings = [
    'P - PHIM DÀNH CHO MỌI ĐỐI TƯỢNG',
    'C13 - PHIM CẤM KHÁN GIẢ DƯỚI 13 TUỔI',
    'C16 - PHIM CẤM KHÁN GIẢ DƯỚI 16 TUỔI',
    'C18 - PHIM CẤM KHÁN GIẢ DƯỚI 18 TUỔI'
  ];
  List<String> selectedAgeRatings = [];
  List<String> categories = [
    'Hoạt Hình',
    'Hành Động',
    'Khoa Học Viễn Tưởng',
    'Phiêu Lưu',
    'Thần Thoại',
    'Tình Cảm',
    'Kinh Dị',
    'Nhạc Kịch',
    'Phim Tài Liệu'
  ];
  List<String> selectedCategories = [];
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
    setState(() {
      _loading = true;
    });
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
    setState(() {
      _loading = false;
    });
    print('Movies::: $movies');
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double heght = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tìm kiếm phim'),
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            )
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(children: [
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    cursorColor: Colors.blue,
                    decoration: InputDecoration(
                      suffixIcon: Wrap(
                        spacing: -10.0, // gap between adjacent chips
                        runSpacing: 0.0,
                        alignment: WrapAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(Icons.format_line_spacing),
                            onPressed: () {
                              showMenu(
                                context: context,
                                position: RelativeRect.fromLTRB(100, 100, 0, 0),
                                items: [
                                  PopupMenuItem(
                                    child: TextButton(
                                      child: Text(
                                        'Đánh giá tăng dần',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        setState(() {
                                          filteredMovies.sort((a, b) =>
                                              a['raeting']
                                                  .compareTo(b['raeting']));
                                        });
                                      },
                                    ),
                                  ),
                                  PopupMenuItem(
                                    child: TextButton(
                                      child: Text('Đánh giá giảm dần',
                                          style:
                                              TextStyle(color: Colors.black)),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        setState(() {
                                          filteredMovies.sort((a, b) =>
                                              b['raeting']
                                                  .compareTo(a['raeting']));
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.filter_list),
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return Container(
                                    height: heght / 4,
                                    child: Wrap(
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0),
                                              child: Text(
                                                'Chọn bộ lọc',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                        ListTile(
                                          leading: Icon(
                                            Icons.child_care,
                                            color: Colors.blue,
                                          ),
                                          title: Text('Độ tuổi'),
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  backgroundColor:
                                                      Color.fromARGB(
                                                          255, 255, 255, 255),
                                                  title: Text('Chọn độ tuổi'),
                                                  content: StatefulBuilder(
                                                      builder:
                                                          (BuildContext context,
                                                              StateSetter
                                                                  setState) {
                                                    return ListView.builder(
                                                      shrinkWrap: true,
                                                      physics:
                                                          NeverScrollableScrollPhysics(),
                                                      itemCount:
                                                          ageRatings.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return CheckboxListTile(
                                                          dense: true,
                                                          checkColor:
                                                              Colors.white,
                                                          activeColor:
                                                              Colors.blue,
                                                          title: Text(
                                                            ageRatings[index],
                                                          ),
                                                          value: selectedAgeRatings
                                                              .contains(
                                                                  ageRatings[
                                                                      index]),
                                                          onChanged:
                                                              (bool? value) {
                                                            setState(() {
                                                              if (value !=
                                                                  null) {
                                                                if (value) {
                                                                  selectedAgeRatings.add(
                                                                      ageRatings[
                                                                          index]);
                                                                } else {
                                                                  selectedAgeRatings.remove(
                                                                      ageRatings[
                                                                          index]);
                                                                }
                                                              }
                                                            });
                                                          },
                                                        );
                                                      },
                                                    );
                                                  }),
                                                  actions: [
                                                    ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              backgroundColor:
                                                                  Colors.blue),
                                                      child: Text(
                                                        'Xác nhận',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                        setState(() {
                                                          filteredMovies =
                                                              movies.where(
                                                                  (movie) {
                                                            return (selectedCategories
                                                                        .isEmpty ||
                                                                    selectedCategories.any((category) => movie[
                                                                            'categories']
                                                                        .contains(
                                                                            category))) &&
                                                                (selectedAgeRatings
                                                                        .isEmpty ||
                                                                    selectedAgeRatings
                                                                        .contains(
                                                                            movie['rated']));
                                                          }).toList();
                                                        });
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                        ),
                                        ListTile(
                                          leading: Icon(
                                            Icons.movie,
                                            color: Colors.blue,
                                          ),
                                          title: Text('Thể loại'),
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  backgroundColor:
                                                      Color.fromARGB(
                                                          255, 255, 255, 255),
                                                  title: Text(
                                                      'Chọn thể loại phim'),
                                                  content: StatefulBuilder(
                                                    builder: (BuildContext
                                                            context,
                                                        StateSetter setState) {
                                                      return ListView.builder(
                                                        shrinkWrap: true,
                                                        physics:
                                                            NeverScrollableScrollPhysics(),
                                                        itemCount:
                                                            categories.length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return CheckboxListTile(
                                                            dense: true,
                                                            checkColor:
                                                                Colors.white,
                                                            activeColor:
                                                                Colors.blue,
                                                            title: Text(
                                                              categories[index],
                                                            ),
                                                            value: selectedCategories
                                                                .contains(
                                                                    categories[
                                                                        index]),
                                                            onChanged:
                                                                (bool? value) {
                                                              setState(() {
                                                                if (value !=
                                                                    null) {
                                                                  if (value) {
                                                                    selectedCategories.add(
                                                                        categories[
                                                                            index]);
                                                                  } else {
                                                                    selectedCategories
                                                                        .remove(
                                                                            categories[index]);
                                                                  }
                                                                }
                                                              });
                                                            },
                                                          );
                                                        },
                                                      );
                                                    },
                                                  ),
                                                  actions: [
                                                    ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              backgroundColor:
                                                                  Colors.blue),
                                                      child: Text(
                                                        'Xác nhận',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                        setState(() {
                                                          filteredMovies =
                                                              movies.where(
                                                                  (movie) {
                                                            return (selectedCategories
                                                                        .isEmpty ||
                                                                    selectedCategories.any((category) => movie[
                                                                            'categories']
                                                                        .contains(
                                                                            category))) &&
                                                                (selectedAgeRatings
                                                                        .isEmpty ||
                                                                    selectedAgeRatings
                                                                        .contains(
                                                                            movie['rated']));
                                                          }).toList();
                                                        });
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                        ),
                                        ListTile(
                                          leading: Icon(
                                            Icons.date_range,
                                            color: Colors.blue,
                                          ),
                                          title: Text('Tìm theo ngày chiếu'),
                                          onTap: () {
                                            showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime.now(),
                                              lastDate: DateTime.now()
                                                  .add(Duration(days: 7)),
                                            ).then((selectedDate) {
                                              if (selectedDate != null) {
                                                setState(() {
                                                  filteredMovies =
                                                      movies.where((movie) {
                                                    DateTime releaseDate =
                                                        DateTime.parse(movie[
                                                            'releaseDate']);
                                                    return releaseDate.isBefore(
                                                            selectedDate) &&
                                                        releaseDate.isAfter(
                                                            selectedDate.subtract(
                                                                Duration(
                                                                    days: 20)));
                                                  }).toList();
                                                });
                                              }
                                            });
                                          },
                                        )
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 10.0),
                      labelText: 'Nhập tên phim',
                      labelStyle: TextStyle(color: Colors.grey),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        search = removeDiacritics(
                            value.toLowerCase().replaceAll(' ', ''));
                        if (search.isEmpty) {
                          filteredMovies = movies.where((movie) {
                            return (selectedCategories.isEmpty ||
                                    selectedCategories.any((category) =>
                                        movie['categories']
                                            .contains(category))) &&
                                (selectedAgeRatings.isEmpty ||
                                    selectedAgeRatings
                                        .contains(movie['rated']));
                          }).toList();
                        } else {
                          filteredMovies = movies.where((movie) {
                            return removeDiacritics(movie['name']
                                        .toLowerCase()
                                        .replaceAll(' ', ''))
                                    .contains(search) &&
                                (selectedCategories.isEmpty ||
                                    selectedCategories.any((category) =>
                                        movie['categories']
                                            .contains(category))) &&
                                (selectedAgeRatings.isEmpty ||
                                    selectedAgeRatings
                                        .contains(movie['rated']));
                          }).toList();
                        }
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredMovies.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailFilm(
                                        movieId: filteredMovies[index]['id'],
                                      )),
                            ),
                            child: Row(children: [
                              Container(
                                width: 150,
                                height: 80,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    filteredMovies[index]['largeImageURL'] ??
                                        'https://via.placeholder.com/150',
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
