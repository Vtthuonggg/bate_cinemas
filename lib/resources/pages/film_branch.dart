import 'package:flutter/material.dart';
import 'package:flutter_app/app/networking/api_service.dart';
import 'package:flutter_app/app/networking/location_api.dart';

class FilmBranch extends StatefulWidget {
  int id;
  FilmBranch({super.key, required this.id});

  @override
  State<FilmBranch> createState() => _FilmBranchState();
}

class _FilmBranchState extends State<FilmBranch> {
  final _apiService = ApiService();
  bool _loading = false;
  List<dynamic> _branchs = [];
  int id = 0;
  @override
  void initState() {
    super.initState();
    id = widget.id;
  }

  Future<void> getBranchWithId() async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
