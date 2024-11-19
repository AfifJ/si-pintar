import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:si_pintar/constant/api_constants.dart';

class ScheduleService {
  Future<List<Map<String, dynamic>>> getSchedule(String userId) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.restApiBaseUrl}/rpc/get_student_schedule'),
        headers: ApiConstants.defaultHeaders,
        body: jsonEncode({'student_uuid': userId}),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to get schedule');
      }

      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((item) => Map<String, dynamic>.from(item)).toList();
    } catch (e) {
      throw Exception('Failed to get schedule: $e');
    }
  }
}
