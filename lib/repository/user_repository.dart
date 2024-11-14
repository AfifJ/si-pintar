import 'dart:convert';

import 'package:si_pintar/data/dummy_data.dart';
import 'package:si_pintar/models/user.dart';

class UserRepository {
  // Singleton pattern
  static final UserRepository _instance = UserRepository._internal();
  factory UserRepository() => _instance;
  UserRepository._internal();

  Future<User> getUser() async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Return dummy user data from DummyData
      final userData = jsonDecode(DummyData.profile);
      return User.fromJson(userData);
    } catch (e) {
      throw Exception('Failed to get user data: $e');
    }
  }

  // Method untuk update user data
  Future<User> updateUser(User user) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // In real app, you would make an API call here
      // For now, just return the updated user
      return user;
    } catch (e) {
      throw Exception('Failed to update user data: $e');
    }
  }

  // Method untuk update password
  Future<void> updatePassword(String oldPassword, String newPassword) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Validate old password (dummy validation)
      if (oldPassword != "password123") {
        throw Exception('Password lama tidak sesuai');
      }

      // In real app, you would make an API call here
    } catch (e) {
      throw Exception('Failed to update password: $e');
    }
  }
}
