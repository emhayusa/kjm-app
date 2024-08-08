import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

Future<dynamic> getUserPreference() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String user = prefs.getString('user') ?? '';
  var data = jsonDecode(user);
  return data;
  //SharedPreferences prefs = await SharedPreferences.getInstance();
  //return prefs.getString('fcm_token');
}

Future<String?> getUserUuid() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String user = prefs.getString('user') ?? '';
  var data = jsonDecode(user);
  return data['uuid'];
}

Future<String?> getUserToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String user = prefs.getString('user') ?? '';
  var data = jsonDecode(user);
  return data['accessToken'];
}
