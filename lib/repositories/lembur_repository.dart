import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:kjm_app/constants.dart';
import 'package:kjm_app/model/request/lembur_request_model.dart';
import 'package:kjm_app/model/response/lembur_response_model.dart';
import 'package:kjm_app/model/user_profile.dart';
import 'package:kjm_app/utils/user_preference.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LemburRepository {
  Future<LemburResponseModel> fetchLembur() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user = prefs.getString('user') ?? '';
    var data = jsonDecode(user);
    final response = await http.get(
        Uri.parse('${ApiConstants.apiUrl}/lembur/${data["uuid"]}'),
        headers: {"x-access-token": data['accessToken']});

    if (response.statusCode == 200) {
      return LemburResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load profile');
    }
  }

  Future<List<LemburResponseModel>> fetchLemburs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user = prefs.getString('user') ?? '';
    var data = jsonDecode(user);
    final response = await http.get(Uri.parse('${ApiConstants.apiUrl}/lemburs'),
        headers: {"x-access-token": data['accessToken']});
    //print(response.statusCode);
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => LemburResponseModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load articles');
    }
  }

  Future<Map<String, dynamic>> postLemburDatang(
      LemburRequestModel lemburDatang, File? image) async {
    String? uuid = await getUserUuid();
    String? token = await getUserToken();

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${ApiConstants.apiUrl}/Lembur/datang'),
    );

    request.fields['uuid'] = uuid!;
    request.fields['firstname'] = lemburDatang.email ?? '';
    request.fields['lastname'] = lemburDatang.password ?? '';

    if (image != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'file',
        image!.path,
      ));
    }

    request.headers.addAll({'x-access-token': token!});

    var response = await request.send();

    print(response.statusCode);

    if (response.statusCode == 200) {
      //final data = jsonDecode(response.);
      return {
        'status': 'success',
        'message': 'berhasil',
      };
      //final List<dynamic> newsJson = json.decode(response.body);
      //return newsJson.map((json) => News.fromJson(json)).toList();
    } else if (response.statusCode == 400 || response.statusCode == 404) {
      //final data = jsonDecode(response.reasonPhrase);
      return {
        'status': 'error',
        'message': response.reasonPhrase,
      };
    } else {
      throw Exception('Failed to Lembur datang');
    }
  }

  Future<Map<String, dynamic>> postLemburPulang(
      LemburRequestModel lemburPulang, File? image) async {
    String? uuid = await getUserUuid();
    String? token = await getUserToken();

    var request = http.MultipartRequest(
      'PUT',
      Uri.parse('${ApiConstants.apiUrl}/Lembur/pulang/$uuid'),
    );

    request.fields['firstname'] = lemburPulang.email ?? '';
    request.fields['lastname'] = lemburPulang.password ?? '';

    if (image != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'file',
        image.path,
      ));
    }

    request.headers.addAll({'x-access-token': token!});

    var response = await request.send();

    print(response.statusCode);

    if (response.statusCode == 200) {
      //final data = jsonDecode(response.);
      return {
        'status': 'success',
        'message': 'berhasil',
      };
      //final List<dynamic> newsJson = json.decode(response.body);
      //return newsJson.map((json) => News.fromJson(json)).toList();
    } else if (response.statusCode == 400 || response.statusCode == 404) {
      //final data = jsonDecode(response.reasonPhrase);
      return {
        'status': 'error',
        'message': response.reasonPhrase,
      };
    } else {
      throw Exception('Failed to Lembur pulang');
    }
  }
}
