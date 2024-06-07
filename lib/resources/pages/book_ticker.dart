import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/resources/custom_toast.dart';
import 'package:flutter_app/resources/pages/fake_invoice.dart';
import 'package:flutter_app/resources/pages/home_page_user.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookTicket extends StatefulWidget {
  Map<String, dynamic> film;
  String time;
  String roomName;
  String branchName;
  String address;
  String dateRealse;

  BookTicket({
    Key? key,
    required this.film,
    required this.time,
    required this.roomName,
    required this.branchName,
    required this.address,
    required this.dateRealse,
  }) : super(key: key);

  @override
  State<BookTicket> createState() => _BookTicketState();
}

class _BookTicketState extends State<BookTicket> {
  NumberFormat vndFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '');
  List<bool> selectedSeats = List<bool>.generate(150, (index) => false);
  List<Map<String, dynamic>> selectedSeatCoordinates = [];
  Map<String, dynamic> room = {};
  Map<String, dynamic> movies = {};
  double price = 0;
  String roomName = '';
  String branchName = '';
  String time = '';
  String name = '';
  String address = '';
  String releaseDate = '';
  List<Map<String, dynamic>> selectedTemp = [];

  @override
  void initState() {
    super.initState();
    loadSelectedSeats();
    releaseDate = widget.dateRealse;
    time = widget.time;
    roomName = widget.roomName;
    branchName = widget.branchName;
    movies = widget.film;
    name = widget.film['name'];
    address = widget.address;

    price = movies['schedules'][0]['price'];
    room = movies['schedules'][0]['room'];
    print(room);
    print(price);
  }

  void loadSelectedSeats() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String filmTimeKey = '${name}_$time';
    if (prefs.containsKey(filmTimeKey)) {
      List<Map<String, dynamic>> loadedSeats = List<Map<String, dynamic>>.from(
          jsonDecode(prefs.getString(filmTimeKey)!));
      setState(() {
        selectedTemp = loadedSeats;
        print(selectedSeatCoordinates);
      });
    }
  }

  getPrice() {
    num totalPrice = 0;
    DateTime now = DateTime.now();
    print('THỜI GIAN HIỆN TẠI: $now');
    String formattedDate = DateFormat("EEEE").format(now);
    print(formattedDate);
    bool isWeekend = (formattedDate == 'Friday' ||
        formattedDate == 'Saturday' ||
        formattedDate == 'Sunday');
    for (int i = 0; i < selectedSeats.length; i++) {
      if (selectedSeats[i]) {
        int row = i ~/ 11;
        num seatPrice = price; // Replace with actual API price
        if (row >= 4) {
          seatPrice += 15000; // VIP seat surcharge
        }
        if (isWeekend) {
          seatPrice += 15000; // Weekend surcharge
        }
        totalPrice += seatPrice;
      }
    }
    return totalPrice;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Đặt vé'),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Giá vé phim'),
                    content: Text.rich(
                      TextSpan(children: <TextSpan>[
                        TextSpan(
                            text:
                                'Vé phim của bạn có giá: ${vndFormat.format(price)}\n'),
                        TextSpan(text: 'Vào cuối tuần giá vé tăng 15.000\n'),
                        TextSpan(text: 'Ghế VIP tăng 15.000\n'),
                      ]),
                    ),
                    actions: [
                      TextButton(
                        child: Text(
                          'Đóng',
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
            icon: Icon(Icons.help_outline),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  name,
                  style: GoogleFonts.oswald(
                      fontSize: 20, fontWeight: FontWeight.w400),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Image.asset(
                  'public/assets/images/seat.png',
                  scale: 1.5,
                  color: Colors.grey[400],
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  ": Ghế thường",
                  style: GoogleFonts.oswald(fontSize: 20),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Image.asset(
                  'public/assets/images/seat.png',
                  scale: 1.5,
                  color: Colors.blue[300],
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  ": Ghế VIP",
                  style: GoogleFonts.oswald(fontSize: 20),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Image.asset(
                  'public/assets/images/seat.png',
                  scale: 1.5,
                  color: Colors.red[400],
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  ": Ghế đang được chọn",
                  style: GoogleFonts.oswald(fontSize: 20),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Image.asset(
                  'public/assets/images/seat.png',
                  scale: 1.5,
                  color: Colors.orange,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  ": Ghế đã được đặt",
                  style: GoogleFonts.oswald(fontSize: 20),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Tổng tiền: ${vndFormat.format(getPrice())}',
                  style: GoogleFonts.oswald(fontSize: 20),
                ),
              ],
            ),
            Expanded(child: Container()),
            Divider(),
            Text(
              'MÀN HÌNH CHIẾU',
              style: GoogleFonts.oswald(),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              width: width,
              height: height / 2.2,
              child: GridView.builder(
                itemCount: 121,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 11, childAspectRatio: 1),
                itemBuilder: (context, index) {
                  int row = index ~/ 11;
                  int seat = index % 11;
                  return GestureDetector(
                    onTap: () {
                      if (selectedTemp.any((seatCoordinate) =>
                          seatCoordinate['row'] ==
                              String.fromCharCode(row + 65) &&
                          seatCoordinate['column'] == seat + 1)) {
                        // This seat was selected before, so we don't allow to interact with it
                        return;
                      }
                      setState(() {
                        selectedSeats[index] = !selectedSeats[index];
                        if (selectedSeats[index]) {
                          selectedSeatCoordinates.add({
                            'row': String.fromCharCode(row + 65),
                            'column': seat + 1
                          });
                        } else {
                          selectedSeatCoordinates.removeWhere(
                              (seatCoordinate) =>
                                  seatCoordinate['row'] ==
                                      String.fromCharCode(row + 65) &&
                                  seatCoordinate['column'] == seat + 1);
                        }
                        print(selectedSeatCoordinates);
                      });
                    },
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: <Widget>[
                        Image.asset(
                          'public/assets/images/seat.png',
                          scale: 1.5,
                          color: selectedTemp.any((seatCoordinate) =>
                                  seatCoordinate['row'] ==
                                      String.fromCharCode(row + 65) &&
                                  seatCoordinate['column'] == seat + 1)
                              ? Colors.orange
                              : selectedSeats[index]
                                  ? Colors.red[400]
                                  : row < 4
                                      ? Colors.grey[400]
                                      : Colors.blue[300],
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Text(
                            '${String.fromCharCode(row + 65)}${seat + 1}',
                            style: GoogleFonts.oswald(
                                color: Colors.white, fontSize: 10),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Container(
              width: width,
              height: height / 16,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 229, 88, 0),
                    Color.fromARGB(255, 242, 198, 76)
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: TextButton(
                  onPressed: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    String filmTimeKey = '${name}_$time';
                    selectedTemp.addAll(selectedSeatCoordinates);
                    await prefs.setString(
                        filmTimeKey, jsonEncode(selectedTemp));
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Invoice(
                                seat: selectedSeatCoordinates,
                                price: getPrice(),
                                filmName: name,
                                branchName: branchName,
                                time: time,
                                address: address,
                                roomName: roomName,
                                releaseDate: releaseDate,
                              )),
                    );
                    CustomToast.showToastSuccess(
                        description: 'Đặt vé thành công');
                  },
                  child: Text('Thanh toán',
                      style: GoogleFonts.oswald(
                          fontSize: 20, color: Colors.white))),
            ),
          ],
        ),
      ),
    );
  }
}
