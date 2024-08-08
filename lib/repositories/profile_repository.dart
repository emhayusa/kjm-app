import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kjm_app/constants.dart';
import 'package:kjm_app/model/user_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileRepository {
  Future<UserProfile> fetchProfile() async {
    final response =
        await http.get(Uri.parse('${ApiConstants.apiUrl}/user/uuid'));

    if (response.statusCode == 200) {
      return UserProfile.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load profile');
    }
  }

  Future<void> updateProfile(UserProfile profile) async {
    final response = await http.put(
      Uri.parse('${ApiConstants.apiUrl}/profile'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(profile.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update profile');
    }
  }

  Future<Map<String, String>> fetchProfileData() async {
    final response =
        await http.get(Uri.parse('${ApiConstants.apiUrl}/profile'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Save profile name to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('profileName', data['name']);
      return {
        'profilePictureUrl': data['profilePictureUrl'],
        'profileName': data['name'],
      };
    } else {
      throw Exception('Failed to load profile data');
    }
  }

  Future<String?> getProfileNameFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('profileName');
  }
}
