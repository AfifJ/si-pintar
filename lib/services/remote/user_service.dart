import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:si_pintar/constant/api_constants.dart';
import 'package:si_pintar/data/dummy_data.dart';
import 'package:si_pintar/models/user.dart';

class UserService {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  Future<User> login(String email, String password) async {
    try {
      // Make API call to login
      final response = await http.post(
        Uri.parse('${ApiConstants.restApiBaseUrl}/auth/login'),
        headers: ApiConstants.defaultHeaders,
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to login');
      }

      // Parse response body
      return User.fromJson(jsonDecode(DummyData.profile));
      // return User.fromJson(jsonDecode(response.body));
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }

  Future<User> updateProfile(String userId, User user) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiConstants.restApiBaseUrl}/users/me'),
        headers: ApiConstants.defaultHeaders,
        body: jsonEncode(user.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update user');
      }

      // return User.fromJson(jsonDecode(response.body));
      return User.fromJson(jsonDecode(DummyData.profile));
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  Future<bool> updatePassword(
      String userId, String oldPassword, String newPassword) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiConstants.restApiBaseUrl}/users/me/password'),
        headers: ApiConstants.defaultHeaders,
        body: jsonEncode({
          'old_password': oldPassword,
          'new_password': newPassword,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update password');
      }

      return true;
    } catch (e) {
      throw Exception('Failed to update password: $e');
    }
  }

  Future<void> logout(String userId) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.restApiBaseUrl}/auth/logout'),
        headers: ApiConstants.defaultHeaders,
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to logout');
      }
    } catch (e) {
      throw Exception('Failed to logout: $e');
    }
  }
}
