import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/login_page.dart';
import 'package:flutter_app/resources/pages/home_page.dart';
import 'package:flutter_app/resources/pages/home_page_user.dart';
import 'package:flutter_app/resources/pages/main_screen.dart';
import 'package:flutter_app/routes/router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:nylo_framework/nylo_framework.dart';

void main() {
  Nylo.init();

  initializeDateFormatting('vi_VN').then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = appRouter();
    final routes = {
      HomePage.path: (context) => HomePage(),
      HomePageUser.path: (context) => HomePageUser(),
      MainScreen.path: (context) => MainScreen(),
      LoginPage.path: (context) => LoginPage(),
      // Add your routes here
    };
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      routes: routes,
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.blue,
    ));
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Transform.scale(
              scale: 0.5,
              child: Image.asset('public/assets/images/logo_bate.png')),
          CircularProgressIndicator(
            color: Colors.blue,
          )
        ],
      ),
    );
  }
}
