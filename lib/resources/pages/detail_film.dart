import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/app/networking/api_service.dart';
import 'package:flutter_app/app/networking/detail_film_api.dart';
import 'package:flutter_app/app/networking/favorite_api.dart';
import 'package:flutter_app/resources/location/location.dart';
import 'package:flutter_app/resources/pages/book_ticker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class DetailFilm extends StatefulWidget {
  final int movieId;
  const DetailFilm({Key? key, required this.movieId}) : super(key: key);

  @override
  State<DetailFilm> createState() => _DetailFilmState();
}

class _DetailFilmState extends State<DetailFilm> {
  bool isFavorite = false;
  Map<String, dynamic> detail = {};
  Map<String, dynamic> video = {};
  late MovieDetailApi movieDetailApi;
  final _apiService = ApiService();
  bool _loading = false;
  bool _showFullText = false;
  List<Map<String, dynamic>> gener = [];
  @override
  void initState() {
    super.initState();
    movieDetailApi = MovieDetailApi(_apiService, movieId: widget.movieId);
    fetchDetail();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> toggleFavorite() async {
    setState(() {
      isFavorite = !isFavorite;
    });
    try {
      await FavoriteApi(_apiService)
          .addFavoriteMovie(movieId: widget.movieId, isFavorite: isFavorite);
    } catch (e) {
      print('Lỗi toggling favorite: $e');
    }
  }

  String getRating(String ratingText) {
    print(ratingText);
    switch (ratingText) {
      case "P - PHIM DÀNH CHO MỌI ĐỐI TƯỢNG":
        return "Mọi lứa tuổi";
      case "C13 - PHIM CẤM KHÁN GIẢ DƯỚI 13 TUỔI":
        return "C13";
      case "C16 - PHIM CẤM KHÁN GIẢ DƯỚI 16 TUỔI":
        return "C16";
      case "C18 - PHIM CẤM KHÁN GIẢ DƯỚI 18 TUỔI":
        return "C18";
      default:
        return '';
    }
  }

  Color getRatingColor(String ratingText) {
    switch (ratingText) {
      case "P - PHIM DÀNH CHO MỌI ĐỐI TƯỢNG":
        return Colors.green;
      case "C13 - PHIM CẤM KHÁN GIẢ DƯỚI 13 TUỔI":
        return Colors.yellow;
      case "C16 - PHIM CẤM KHÁN GIẢ DƯỚI 16 TUỔI":
        return Colors.orange;
      case "C18 - PHIM CẤM KHÁN GIẢ DƯỚI 18 TUỔI":
        return Color.fromARGB(255, 223, 26, 12);
      default:
        return Colors.white;
    }
  }
  // Future<void> fetchFavorite() async {
  //   var res = await FavoriteApi(_apiService).getFavoriteMovies();
  //   print('bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb');
  //   print(res);
  //   for (var item in res) {
  //     if (item['id'] == widget.movieId) {
  //       setState(() {
  //         isFavorite = true;
  //       });
  //     }
  //   }
  // }

  Future<void> fetchDetail() async {
    setState(() {
      _loading = true;
    });
    try {
      var res = await movieDetailApi.fetchMovieDetail(widget.movieId);
      detail = res;
      if (detail['genres'] != null) {
        gener = List<Map<String, dynamic>>.from(detail['genres']);
      }
      print("DETAIL:${widget.movieId}:: $detail");
    } catch (e) {
      print('Lỗi detail: $e');
      detail = {};
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  // Future<void> getVideo() async {
  //   setState(() {
  //     _loading = true;
  //   });
  //   try {
  //     var res = await movieDetailApi.getTrailer(widget.movieId);
  //     if (res['results'][0] != null || (res['results'][0].isNotEmpty)) {
  //       video = res['results'][0];
  //     }
  //     print("link trailer: $video");
  //   } catch (e) {
  //     print('Lỗi video: $e');
  //     video = {};
  //   } finally {
  //     if (mounted) {
  //       setState(() {
  //         _loading = false;
  //       });
  //     }
  //   }
  // }

  String limitWords(String text, int limit) {
    List<String> words = text.split(' ');
    if (words.length <= limit) {
      return text;
    } else {
      return words.take(limit).join(' ') + '...';
    }
  }

  String formatDate(String date) {
    try {
      final inputFormat = DateFormat('yyyy-MM-dd', 'vi_VN');
      final inputDate = inputFormat.parseStrict(date);

      final outputFormat = DateFormat('dd/MM/yyyy', 'vi_VN');
      return outputFormat.format(inputDate);
    } catch (e) {
      print('Unable to parse date: $date');
      return date;
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double? voteAverage = detail['rating'];

    Color progressColor = Colors.grey;

    if (voteAverage != null) {
      if (voteAverage < 5) {
        progressColor = Colors.red;
      } else if (voteAverage < 8) {
        progressColor = Colors.yellow;
      } else {
        progressColor = Colors.green;
      }
    }
    String extractVideoIdFromUrl(String url) {
      RegExp regExp = RegExp(
        r"(youtu\.be/|youtube\.com/embed/)([^&]+)",
        caseSensitive: false,
        multiLine: false,
      );

      Match? match = regExp.firstMatch(url);
      return match?.group(2) ?? ''; // if no match, return empty string
    }

    String? videoUrl = detail['trailerURL'].toString();

    String? videoKey = videoUrl != null ? extractVideoIdFromUrl(videoUrl) : '';

    YoutubePlayerController _controller = YoutubePlayerController(
      initialVideoId: videoKey,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết phim'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: _loading
              ? Center(
                  child: CircularProgressIndicator(
                  color: Colors.blue,
                ))
              : Column(
                  children: [
                    Container(
                      width: width,
                      child: Image.network(
                        detail['largeImageURL'] != null
                            ? detail['largeImageURL']
                            : 'https://via.placeholder.com/150',
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Text(
                            detail['name'] ?? '',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Mô tả phim:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              detail['longDescription'] == null ||
                                      detail['longDescription'].isEmpty
                                  ? 'Tạm thời chưa có mô tả'
                                  : _showFullText
                                      ? detail['longDescription']
                                      : limitWords(
                                          detail['longDescription'], 50),
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                          if ((detail['longDescription'] ?? '')
                                  .split(' ')
                                  .length >
                              50)
                            TextButton(
                              child: Text(
                                _showFullText ? "Thu gọn" : "Xem thêm",
                                style: TextStyle(color: Colors.blue),
                                textAlign: TextAlign.justify,
                              ),
                              style: ButtonStyle(
                                overlayColor: MaterialStateProperty.resolveWith(
                                    (states) => Colors.transparent),
                              ),
                              onPressed: () {
                                setState(() {
                                  _showFullText = !_showFullText;
                                });
                              },
                            ),
                          SizedBox(height: 10),
                          Text(
                            getRating(detail['rated'] ?? ''),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: getRatingColor(detail['rated'] ?? '')),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                child: Image.asset(
                                  'public/assets/images/date.png',
                                ),
                              ),
                              SizedBox(width: 5),
                              Text(formatDate(
                                detail['releaseDate'] ?? '',
                              )),
                              SizedBox(width: 20),
                              Container(
                                width: 20,
                                height: 20,
                                child: Image.asset(
                                  'public/assets/images/clock.png',
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                detail['duration'] == 0
                                    ? "Chưa rõ"
                                    : " ${detail['duration']} phút",
                              ),
                              IconButton(
                                  onPressed: toggleFavorite,
                                  icon: Icon(
                                    isFavorite
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color:
                                        isFavorite ? Colors.red : Colors.grey,
                                  ))
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Thể loại: ",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Flexible(
                                child: Text(
                                  "${detail['categories']}",
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                'Đánh giá:',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: 10),
                              SizedBox(
                                width: 30,
                                height: 30,
                                child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      CircularProgressIndicator(
                                        strokeWidth: 5,
                                        value: voteAverage,
                                        backgroundColor: Colors.grey[200],
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                progressColor),
                                      ),
                                      Text(
                                        voteAverage?.toStringAsFixed(1) ?? '',
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ]),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Text("Trailer:",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          SizedBox(height: 10),
                          video == null
                              ? Text("Tạm thời chưa cập nhật")
                              : YoutubePlayer(
                                  controller: _controller,
                                  showVideoProgressIndicator: true,
                                  progressColors: ProgressBarColors(
                                    playedColor: Colors.amber,
                                    handleColor: Colors.amberAccent,
                                  ),
                                ),
                          SizedBox(height: 30),
                          Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: height / 16,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 0, 90, 164),
                Color.fromARGB(255, 139, 203, 255)
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Location(
                            film: detail,
                          )),
                );
              },
              child: Text('ĐẶT VÉ',
                  style:
                      GoogleFonts.oswald(fontSize: 20, color: Colors.white))),
        ),
      ),
    );
  }
}
