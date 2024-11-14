import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:si_pintar/constant/api_constants.dart';
import 'package:si_pintar/models/class_model.dart';

class ClassService {
  static final ClassService _instance = ClassService._internal();
  factory ClassService() => _instance;
  ClassService._internal();

  Future<List<ClassModel>> getClasses(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.restApiBaseUrl}/classes'),
        headers: ApiConstants.defaultHeaders,
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to get classes');
      }

      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('Failed to get classes: $e');
    }
  }

  Future<Map<String, dynamic>> getClassDetail(String classId) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.restApiBaseUrl}/classes/$classId'),
        headers: ApiConstants.defaultHeaders,
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to get class detail');
      }

      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('Failed to get class detail: $e');
    }
  }

  Future<Map<String, dynamic>> createClass(
      Map<String, dynamic> classData) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.restApiBaseUrl}/classes'),
        headers: ApiConstants.defaultHeaders,
        body: jsonEncode(classData),
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to create class');
      }

      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('Failed to create class: $e');
    }
  }

  Future<Map<String, dynamic>> updateClass(
      String classId, Map<String, dynamic> classData) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiConstants.restApiBaseUrl}/classes/$classId'),
        headers: ApiConstants.defaultHeaders,
        body: jsonEncode(classData),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update class');
      }

      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('Failed to update class: $e');
    }
  }

  Future<void> deleteClass(String classId) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiConstants.restApiBaseUrl}/classes/$classId'),
        headers: ApiConstants.defaultHeaders,
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete class');
      }
    } catch (e) {
      throw Exception('Failed to delete class: $e');
    }
  }
}
