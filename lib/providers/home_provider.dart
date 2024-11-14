import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:si_pintar/data/dummy_data.dart';
import 'package:si_pintar/models/activity.dart';
import 'package:si_pintar/models/class_model.dart';
// import 'package:si_pintar/models/course.dart';
import 'package:si_pintar/models/user.dart';
import 'package:si_pintar/repository/user_repository.dart';

// Error "type 'Null' is not a subtype of type 'String'" terjadi ketika:
// 1. Mencoba mengkonversi nilai null ke String
// 2. Variabel yang nullable (String?) digunakan di tempat yang membutuhkan non-null String
// 3. Saat mengakses property/method String dari objek yang null

// Solusi:
// 1. Pastikan selalu ada null check sebelum type casting
// 2. Gunakan null-aware operator (?., ??, ?=)
// 3. Berikan nilai default jika null
// 4. Gunakan late keyword jika yakin nilai akan diisi sebelum digunakan

class HomeProvider with ChangeNotifier {
  User? _user;
  List<ClassModel> _classes = [];
  List<Activity> _activities = [];
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  List<ClassModel> get classes => _classes;
  List<Activity> get activities => _activities;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadHomeData() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final userRepo = UserRepository();
      _user = await userRepo.getUser();

      _classes = (jsonDecode(DummyData.classes) as List)
          .map((json) => ClassModel.fromJson(json))
          .toList();

      // _activities = (jsonDecode(DummyData.activities) as List)
      //     .map((json) => Activity.fromJson(json))
      //     .toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshData() async {
    await loadHomeData();
  }

  void clear() {
    _user = null;
    _isLoading = false;
    _error = null;
    notifyListeners();
  }
}
