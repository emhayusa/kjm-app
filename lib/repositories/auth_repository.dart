import 'package:kjm_app/constants.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  Future<void> saveUser(String user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', user);
  }

  Future<void> storeTokenLocally(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('fcm_token', token);
  }

  Future<String?> getLocalToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('fcm_token');
  }

  Future<void> sendTokenToServer(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user = prefs.getString('user') ?? '';

    if (user.isNotEmpty) {
      var data = jsonDecode(user);
      String uuid = data["uuid"];

      try {
        Map<String, dynamic> requestBody = {
          'token': token,
        };

        var response = await http.put(
          Uri.parse("${ApiConstants.apiUrl}/user/token/$uuid"),
          headers: {
            'Content-Type': 'application/json',
            'x-access-token': data['accessToken']
          },
          body: jsonEncode(requestBody),
        );

        if (response.statusCode == 200) {
          var resp = jsonDecode(response.body);
          print('Response: $resp');
        } else {
          print('Failed to update token: ${response.body}');
        }
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    // Implement your login logic here
    Map<String, dynamic> requestBody = {
      "username": username,
      "password": password,
    };

    var response = await http.post(
      Uri.parse('${ApiConstants.apiUrl}/auth/signin'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestBody),
    );
    //print(response.body);
    if (response.statusCode == 200) {
      //final data = jsonDecode(response.body);
      await saveUser(response.body);

      String? oldToken = await getLocalToken();

      if (oldToken != null) {
        // Token has changed
        //print('FCM Old Token: $oldToken');
        //FirebaseMessaging.instance.getToken().then((String? token) {
        //  assert(token != null);
        //  print("FCM Token: $token");
        //  sendTokenToServer(token!);
        //});
      }

      return {
        'status': 'success',
        'message': 'Berhasil Login',
      };
      //final List<dynamic> newsJson = json.decode(response.body);
      //return newsJson.map((json) => News.fromJson(json)).toList();
    } else if (response.statusCode == 400 ||
        response.statusCode == 401 ||
        response.statusCode == 404) {
      final data = jsonDecode(response.body);
      return {
        'status': 'error',
        'message': data['message'],
      };
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String phone,
    required String password,
  }) async {
    Map<String, dynamic> requestBody = {
      "username": username,
      "email": email,
      "phone": phone,
      "password": password,
    };

    var response = await http.post(
      Uri.parse('${ApiConstants.apiUrl}/auth/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {
        'status': 'success',
        'message': data['message'],
      };
      //final List<dynamic> newsJson = json.decode(response.body);
      //return newsJson.map((json) => News.fromJson(json)).toList();
    } else if (response.statusCode == 400 || response.statusCode == 404) {
      final data = jsonDecode(response.body);
      return {
        'status': 'error',
        'message': data['message'],
      };
    } else {
      throw Exception('Failed to register');
    }
  }

  Future<Map<String, dynamic>> resetPassword({
    required String password,
    required String otp,
    required String phone,
  }) async {
    Map<String, dynamic> requestBody = {
      "password": password,
      "otp": otp,
      "phone": phone,
    };

    var response = await http.post(
      Uri.parse('${ApiConstants.apiUrl}/auth/password_otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {
        'status': 'success',
        'message': data['message'],
      };
      //final List<dynamic> newsJson = json.decode(response.body);
      //return newsJson.map((json) => News.fromJson(json)).toList();
    } else if (response.statusCode == 400 || response.statusCode == 404) {
      final data = jsonDecode(response.body);
      return {
        'status': 'error',
        'message': data['message'],
      };
    } else {
      throw Exception('Failed to reset password');
    }
  }

  Future<Map<String, dynamic>> otpPassword({
    required String phone,
  }) async {
    Map<String, dynamic> requestBody = {
      "phone": phone,
    };

    var response = await http.post(
      Uri.parse('${ApiConstants.apiUrl}/auth/send_otp_forgot'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {
        'status': 'success',
        'message': data['message'],
      };
      //final List<dynamic> newsJson = json.decode(response.body);
      //return newsJson.map((json) => News.fromJson(json)).toList();
    } else if (response.statusCode == 400 || response.statusCode == 404) {
      final data = jsonDecode(response.body);
      return {
        'status': 'error',
        'message': data['message'],
      };
    } else {
      throw Exception('Failed to activate');
    }
  }

  Future<Map<String, dynamic>> activate({
    required String phone,
  }) async {
    Map<String, dynamic> requestBody = {
      "phone": phone,
    };

    var response = await http.post(
      Uri.parse('${ApiConstants.apiUrl}/auth/send_otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {
        'status': 'success',
        'message': data['message'],
      };
      //final List<dynamic> newsJson = json.decode(response.body);
      //return newsJson.map((json) => News.fromJson(json)).toList();
    } else if (response.statusCode == 400 || response.statusCode == 404) {
      final data = jsonDecode(response.body);
      return {
        'status': 'error',
        'message': data['message'],
      };
    } else {
      throw Exception('Failed to send otp activation');
    }
  }

  Future<Map<String, dynamic>> otpActivate({
    required String otp,
    required String phone,
  }) async {
    Map<String, dynamic> requestBody = {
      "otp": otp,
      "phone": phone,
    };

    var response = await http.post(
      Uri.parse('${ApiConstants.apiUrl}/auth/activate'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {
        'status': 'success',
        'message': data['message'],
      };
      //final List<dynamic> newsJson = json.decode(response.body);
      //return newsJson.map((json) => News.fromJson(json)).toList();
    } else if (response.statusCode == 400 || response.statusCode == 404) {
      final data = jsonDecode(response.body);
      return {
        'status': 'error',
        'message': data['message'],
      };
    } else {
      throw Exception('Failed to activate');
    }
  }

  Future<void> logout() async {
    // Implement your logout logic here
  }
}
