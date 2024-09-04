import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:kjm_security/constants.dart';
import 'package:kjm_security/model/request/presensi_request_model.dart';
import 'package:kjm_security/model/response/presensi_response_model.dart';
import 'package:kjm_security/model/user_profile.dart';
import 'package:kjm_security/utils/user_preference.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PresensiRepository {
  Future<PresensiResponseModel> fetchPresensi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user = prefs.getString('user') ?? '';
    var data = jsonDecode(user);
    final response = await http.get(
        Uri.parse('${ApiConstants.apiUrl}/presensi/${data["uuid"]}'),
        headers: {"x-access-token": data['accessToken']});

    if (response.statusCode == 200) {
      return PresensiResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load profile');
    }
  }

  Future<List<PresensiResponseModel>> fetchPresensis() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user = prefs.getString('user') ?? '';
    var data = jsonDecode(user);
    final response = await http.get(
        Uri.parse('${ApiConstants.apiUrl}/presensis'),
        headers: {"x-access-token": data['accessToken']});
    //print(response.statusCode);
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => PresensiResponseModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load articles');
    }
  }

  Future<Map<String, dynamic>> postPresensiDatang(
      PresensiRequestModel presensiDatang, File? image) async {
    String? uuid = await getUserUuid();
    String? token = await getUserToken();

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${ApiConstants.apiUrl}/presensi/datang'),
    );

    request.fields['uuid'] = uuid!;
    request.fields['firstname'] = presensiDatang.email ?? '';
    request.fields['lastname'] = presensiDatang.password ?? '';

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
      throw Exception('Failed to presensi datang');
    }
  }

  Future<Map<String, dynamic>> postPresensiPulang(
      PresensiRequestModel presensiPulang, File? image) async {
    String? uuid = await getUserUuid();
    String? token = await getUserToken();

    var request = http.MultipartRequest(
      'PUT',
      Uri.parse('${ApiConstants.apiUrl}/presensi/pulang/$uuid'),
    );

    request.fields['firstname'] = presensiPulang.email ?? '';
    request.fields['lastname'] = presensiPulang.password ?? '';

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
      throw Exception('Failed to presensi pulang');
    }
  }
}
