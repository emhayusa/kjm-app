import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kjm_app/constants.dart';
import 'package:kjm_app/model/article.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EdukasiRepository {
  Future<List<Article>> fetchArticles() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user = prefs.getString('user') ?? '';
    var data = jsonDecode(user);
    final response = await http.get(Uri.parse('${ApiConstants.apiUrl}/article'),
        headers: {"x-access-token": data['accessToken']});
    //print(response.statusCode);
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Article.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load articles');
    }
  }

  Future<List<Article>> fetchFiveArticles() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user = prefs.getString('user') ?? '';
    var data = jsonDecode(user);
    final response = await http.get(
        Uri.parse('${ApiConstants.apiUrl}/article/latest_five'),
        headers: {"x-access-token": data['accessToken']});
    //print(response.statusCode);
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Article.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load articles');
    }
  }
}
