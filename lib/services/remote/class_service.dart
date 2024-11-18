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

      // Debug print
      print('Raw JSON response: $jsonData');

      // Handle empty response
      if (jsonData.isEmpty) {
        return [];
      }
      // Print JSON data for debugging
      print('\n=== Raw JSON Data ===');
      print(jsonEncode(jsonData));

      print('\n=== JSON Data Before Parsing ===');
      for (var json in jsonData) {
        print('Raw item: $json');
        print('Class Data:');
        print('Title: ${json?['title'] ?? 'N/A'}');
        print('Subtitle: ${json?['subtitle'] ?? 'N/A'}');
        print('Credits: ${json?['sks'] ?? 'N/A'}');
        print('Semester: ${json?['semester'] ?? 'N/A'}');
        print('Room: ${json?['room'] ?? 'N/A'}');
        print('Section: ${json?['class_section'] ?? 'N/A'}');
        print('Lecturer: ${json?['users']?['lecturer_name'] ?? 'N/A'}');
        print('-------------------');
      }

      final parsedClasses = jsonData
          .map((json) {
            try {
              return ClassModel.fromJson(json);
            } catch (e) {
              print('Error parsing class data: $e');
              print('Problematic data: $json');
              return null;
            }
          })
          .whereType<ClassModel>()
          .toList();

      // Print parsed data for debugging
      print('\n=== Parsed Class Objects ===');
      for (var cls in parsedClasses) {
        print('Parsed Class:');
        print('Title: ${cls.title}');
        print('Subtitle: ${cls.subtitle}');
        print('Credits: ${cls.credits}');
        print('Semester: ${cls.semester}');
        print('Room: ${cls.room}');
        print('Section: ${cls.classSection}');
        print('Lecturer: ${cls.lecturer}');
        print('-------------------');
      }

      return parsedClasses;
    } catch (e) {
      print('Error in getClasses: $e');
      throw Exception('Failed to get classes: $e');
    }
  }

  Future<Map<String, dynamic>> getClassAnnouncements(String classId) async {
    try {
      final response = await http.get(
        Uri.parse(
            '${ApiConstants.restApiBaseUrl}/materials?select=material_id,material_title:title,description,file_url,date,has_task,has_attachment,attachment_url,created_at,...classes!inner(class_name:title,...class_enrollments!inner())&class_enrollments.student_id=eq.$classId&order=created_at.desc'),
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
