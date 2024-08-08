import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Greeting extends StatelessWidget {
  const Greeting({
    Key? key,
  }) : super(key: key);

  Future<SharedPreferences> _getSharedPreferences() async {
    return SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: _getSharedPreferences(),
      builder: (context, snapshot) {
        //rint(snapshot.data?.getString('name'));
        if (snapshot.hasData) {
          //print(snapshot);
          String? user = snapshot.data?.getString('user');

          var data = jsonDecode(user!);
          print(data);
          String? nama = data['pegawai']["namaLengkap"];

          return Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 7, 61, 88),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              children: [
                Text(
                  "Halo, ${nama} ",
                  style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFFFBFCFE),
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
          // SharedPreferences instance is available
          //final SharedPreferences sharedPreferences =snapshot.data;
        }
        return Container();
      },
    );
  }
}
