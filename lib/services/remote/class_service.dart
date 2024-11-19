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
      final response = await http.post(
        Uri.parse('${ApiConstants.restApiBaseUrl}/rpc/get_enrolled_classes'),
        headers: ApiConstants.defaultHeaders,
        body: jsonEncode({'student_id': userId}),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to get classes');
      }

      final List<dynamic> jsonData = jsonDecode(response.body);

      // Handle empty response
      if (jsonData.isEmpty) {
        return [];
      }
      final parsedClasses = jsonData
          .map((json) {
            try {
              return ClassModel.fromJson(json);
            } catch (e) {
              print('Error parsing class data: $e');
              return null;
            }
          })
          .whereType<ClassModel>()
          .toList();
      return parsedClasses;
    } catch (e) {
      print('Error in getClasses: $e');
      throw Exception('Failed to get classes: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getClassAnnouncements(
      String classId, String userId) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.restApiBaseUrl}/rpc/get_student_materials'),
        headers: ApiConstants.defaultHeaders,
        body: jsonEncode({'student_uuid': userId, 'class_uuid': classId}),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to get class detail');
      }

      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.cast<Map<String, dynamic>>();
    } catch (e) {
      throw Exception('Failed to get class detail: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getClassAttendances(
      String classId, String userId) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.restApiBaseUrl}/rpc/get_student_attendances'),
        headers: ApiConstants.defaultHeaders,
        body: jsonEncode({'student_uuid': userId, 'class_uuid': classId}),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to get class detail');
      }

      // Parse as List<Map<String, dynamic>>
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.cast<Map<String, dynamic>>();
    } catch (e) {
      throw Exception('Failed to get class attendances: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getClassAssignments(
      String classId, String userId) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.restApiBaseUrl}/rpc/get_student_assignments'),
        headers: ApiConstants.defaultHeaders,
        body: jsonEncode({'student_uuid': userId, 'class_uuid': classId}),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to get class assignments');
      }

      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.cast<Map<String, dynamic>>();
    } catch (e) {
      throw Exception('Failed to get class assignments: $e');
    }
  }

  Future<Map<String, dynamic>> getClassDetails(String classId) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.restApiBaseUrl}/rpc/get_class_details'),
        headers: ApiConstants.defaultHeaders,
        body: jsonEncode({'class_uuid': classId}),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to get class details');
      }

      final List<dynamic> jsonData = jsonDecode(response.body);
      // Return the first item from the list, or an empty map if the list is empty
      return jsonData.isNotEmpty
          ? Map<String, dynamic>.from(jsonData.first)
          : {};
    } catch (e) {
      throw Exception('Failed to get class details: $e');
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
