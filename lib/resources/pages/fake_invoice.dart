import 'package:flutter/material.dart';
import 'package:flutter_app/resources/pages/dashed_divide.dart';
import 'package:flutter_app/resources/pages/main_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class Invoice extends StatelessWidget {
  String roomName;
  double price;
  String filmName;
  String branchName;
  String time;
  List<dynamic> seat;
  String address;
  String releaseDate;

  Invoice({
    super.key,
    required this.seat,
    required this.price,
    required this.filmName,
    required this.branchName,
    required this.time,
    required this.address,
    required this.roomName,
    required this.releaseDate,
  });
  NumberFormat vndFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '');
  @override
  Widget build(BuildContext context) {
    seat.sort((a, b) {
      int compare = a['row'].compareTo(b['row']);
      if (compare != 0) return compare;
      return a['column'].compareTo(b['column']);
    });
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 0, 90, 164),
                Color.fromARGB(255, 139, 203, 255)
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text(
              'Chi tiết hóa đơn',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            centerTitle: true,
            leading: IconButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => MainScreen()),
                    (Route<dynamic> route) => false,
                  );
                },
                icon: Icon(
                  Icons.home_outlined,
                  color: Colors.white,
                  size: 35,
                )),
          ),
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    'public/assets/images/logo_bate.png',
                    scale: 20,
                  ),
                  Text('Công ty TNHH Nhóm 2',
                      style: GoogleFonts.roboto(
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                      )),
                ],
              ),
              DashedDivider(),
              SizedBox(
                height: 25,
              ),
              Text(
                "Rạp $branchName",
                style: TextStyle(fontSize: 15),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                address,
                style: TextStyle(fontSize: 15),
              ),
              SizedBox(
                height: 25,
              ),
              DashedDivider(),
              SizedBox(
                height: 25,
              ),
              Row(
                children: [
                  Text(
                    "Tên phim: ",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    filmName,
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Text(roomName,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Text('Ngày chiếu: ',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  Text(releaseDate, style: TextStyle(fontSize: 15)),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Text('Giờ chiếu: ',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  Text(time, style: TextStyle(fontSize: 15)),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Text(
                    "Số ghế: ",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    seat.map((s) => '${s['row']}${s['column']}').join(', '),
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 25,
              ),
              DashedDivider(),
              SizedBox(
                height: 25,
              ),
              Text(
                'Tổng tiền:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 5,
              ),
              Text(vndFormat.format(price),
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              SizedBox(
                height: 30,
              ),
              Text("(Giá tiền đã bao gồm thuế VAT)")
            ],
          ),
        ),
      )),
    );
  }
}
