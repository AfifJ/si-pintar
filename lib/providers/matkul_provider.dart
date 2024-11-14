import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:si_pintar/data/dummy_data.dart';

class MatkulProvider with ChangeNotifier {
  List<Map<String, dynamic>> _announcements = [];
  List<Map<String, dynamic>> _tasks = [];
  List<Map<String, dynamic>> _meetings = [];
  bool _isLoading = false;
  String? _error;

  // Getters untuk mengakses data
  List<Map<String, dynamic>> get announcements => _announcements;
  List<Map<String, dynamic>> get tasks => _tasks;
  List<Map<String, dynamic>> get meetings => _meetings;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadMatkulData() async {
    if (_isLoading) return;

    try {
      _isLoading = true;
      _error = null;
      Future.microtask(() => notifyListeners());

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Parse announcements
      final announcementsJson = jsonDecode(DummyData.announcements);
      _announcements = (announcementsJson as List)
          .map((item) => Map<String, dynamic>.from(item))
          .toList();

      // Parse tasks
      final tasksJson = jsonDecode(DummyData.tasks);
      _tasks = (tasksJson as List)
          .map((item) => Map<String, dynamic>.from(item))
          .toList();

      // Parse meetings - since your JSON doesn't have a "meetings" wrapper
      final meetingsJson = jsonDecode(DummyData.meetings);
      _meetings = (meetingsJson as List)
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      Future.microtask(() => notifyListeners());
    }
  }

  // Method untuk submit presensi
  Future<void> submitPresensi(String status) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      // TODO: Implement presensi submission logic
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to submit presensi: $e');
    }
  }

  // Method untuk submit tugas
  Future<void> submitTask(
      String taskId, String description, String filePath) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      // TODO: Implement task submission logic
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to submit task: $e');
    }
  }
}
