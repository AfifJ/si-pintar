import 'package:http/http.dart' as http;
import 'package:si_pintar/constant/api_constants.dart';
import 'dart:convert';

String convertTimeManual(
    String inputTime, String sourceTimezone, String targetTimezone) {
  // Parse input time (assuming HH:mm format)
  final parts = inputTime.split(':');
  if (parts.length != 2) return '';

  int hours = int.tryParse(parts[0]) ?? 0;
  int minutes = int.tryParse(parts[1]) ?? 0;

  // Timezone data with offsets and cities
  Map<String, Map<String, dynamic>> timezoneData = {
    'UTC': {'offset': 0, 'city': 'Coordinated Universal Time'},
    'WIB': {'offset': 7, 'city': 'Jakarta'},
    'WITA': {'offset': 8, 'city': 'Makassar'},
    'WIT': {'offset': 9, 'city': 'Jayapura'},
    'JST': {'offset': 9, 'city': 'Tokyo'},
    'KST': {'offset': 9, 'city': 'Seoul'},
    'CST': {'offset': 8, 'city': 'Beijing'},
    'IST': {'offset': 5, 'city': 'New Delhi'},
    'MSK': {'offset': 3, 'city': 'Moscow'},
    'CET': {'offset': 1, 'city': 'Paris'},
    'GMT': {'offset': 0, 'city': 'London'},
    'BST': {'offset': 1, 'city': 'London'},
    'EDT': {'offset': -4, 'city': 'New York'},
    'CDT': {'offset': -5, 'city': 'Chicago'},
    'MDT': {'offset': -6, 'city': 'Denver'},
    'PDT': {'offset': -7, 'city': 'Los Angeles'},
  };

  // Get timezone data
  final sourceData = timezoneData[sourceTimezone];
  final targetData = timezoneData[targetTimezone];

  if (sourceData == null || targetData == null) {
    return 'Invalid timezone';
  }

  // Convert to UTC first
  hours -= sourceData['offset'] as int;

  // Then convert to target timezone
  hours += targetData['offset'] as int;

  // Handle day wraparound
  while (hours < 0) hours += 24;
  while (hours >= 24) hours -= 24;

  // Format result with city names
  return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')} '
      '(${sourceData['city']} → ${targetData['city']})';
}
