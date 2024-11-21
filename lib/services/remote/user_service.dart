import 'dart:convert';
import 'dart:ffi';
import 'package:http/http.dart' as http;
import 'package:si_pintar/constant/api_constants.dart';
import 'package:si_pintar/models/user.dart';
import 'package:si_pintar/services/password_encrypt.dart';

class UserService {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  Future<String> login(String email, String password) async {
    try {
      final String encryptedPassword = encryptPassword(password);
      final response = await http.post(
        Uri.parse('${ApiConstants.restApiBaseUrl}/rpc/login'),
        headers: ApiConstants.defaultHeaders,
        body: jsonEncode({
          'p_email': email,
          'p_password': encryptedPassword,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to login');
      }

      final List<dynamic> responseData = jsonDecode(response.body);
      if (responseData.isEmpty) {
        throw Exception('User not found');
      }

      // Cast and return the user_id as String
      return responseData[0]['user_id'].toString();
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }

  Future<bool> updatePassword(String userId, String newPassword) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.restApiBaseUrl}/rpc/update_user_password'),
        headers: ApiConstants.defaultHeaders,
        body: jsonEncode({
          'user_uuid': userId,
          'new_password': encryptPassword(newPassword),
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

  // Future<void> logout(String userId) async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse('${ApiConstants.restApiBaseUrl}/auth/logout'),
  //       headers: ApiConstants.defaultHeaders,
  //     );

  //     if (response.statusCode != 200) {
  //       throw Exception('Failed to logout');
  //     }
  //   } catch (e) {
  //     throw Exception('Failed to logout: $e');
  //   }
  // }

  Future<Map<String, dynamic>> getUserFromSession(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.restApiBaseUrl}/users?user_id=eq.$userId'),
        headers: ApiConstants.defaultHeaders,
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to get user data');
      }

      final List<dynamic> responseData = jsonDecode(response.body);
      if (responseData.isEmpty) {
        throw Exception('User not found');
      }

      // Return the raw Map instead of converting to User
      return responseData[0];
    } catch (e) {
      throw Exception('Failed to get user data: $e');
    }
  }

  Future<bool> register(
      String email, String password, String name, String npm) async {
    try {
      // Validate NPM is numeric only
      if (!RegExp(r'^[0-9]+$').hasMatch(npm)) {
        throw UserServiceException('NPM harus berupa angka');
      }

      final response = await http.post(
        Uri.parse('${ApiConstants.restApiBaseUrl}/rpc/register'),
        headers: ApiConstants.defaultHeaders,
        body: jsonEncode({
          'p_full_name': name,
          'p_email': email,
          'p_password': encryptPassword(password),
          'p_npm': npm,
        }),
      );

      if (response.statusCode != 200) {
        final errorBody = jsonDecode(response.body);
        // Handle specific error messages from backend
        if (errorBody?['message']?.contains('duplicate key') ?? false) {
          if (errorBody['message'].contains('email')) {
            throw UserServiceException('Email sudah terdaftar');
          }
          if (errorBody['message'].contains('npm')) {
            throw UserServiceException('NPM sudah terdaftar');
          }
        }
        throw UserServiceException('Gagal melakukan registrasi');
      }

      final responseData = jsonDecode(response.body);
      if (responseData == null || responseData.isEmpty) {
        throw UserServiceException('Terjadi kesalahan pada server');
      }

      return true;
    } catch (e) {
      if (e is UserServiceException) {
        rethrow;
      }
      throw UserServiceException('Gagal melakukan registrasi: ${e.toString()}');
    }
  }

  Future<bool> updateFullName(String userId, String newName) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.restApiBaseUrl}/rpc/update_user_fullname'),
        headers: ApiConstants.defaultHeaders,
        body: jsonEncode({
          'user_uuid': userId,
          'new_fullname': newName,
        }),
      );

      if (response.statusCode != 200) {
        final errorBody = jsonDecode(response.body);
        throw UserServiceException(
            errorBody['message'] ?? 'Gagal memperbarui nama pengguna');
      }

      final responseData = jsonDecode(response.body);
      if (responseData == null) {
        throw UserServiceException('Terjadi kesalahan pada server');
      }

      return true;
    } catch (e) {
      if (e is UserServiceException) {
        rethrow;
      }
      throw UserServiceException(
          'Gagal memperbarui nama pengguna: ${e.toString()}');
    }
  }
}

class UserServiceException implements Exception {
  final String message;
  UserServiceException(this.message);

  @override
  String toString() => message;
}
