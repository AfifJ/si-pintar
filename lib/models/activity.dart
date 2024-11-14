import 'package:flutter/material.dart';

// enum ActivityType { lecture, practicum, exam, assignment, project }

class Activity {
  final String title;
  final String subtitle;
  // final Color color;
  final String route;
  final String type;
  // final ActivityType type;
  final DateTime dateTime;

  Activity({
    required this.title,
    required this.subtitle,
    // required this.color,
    required this.route,
    required this.type,
    required this.dateTime,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      title: json['title'],
      subtitle: json['subtitle'],
      // color: Color(json['color']),
      // color: Color(
      //     int.parse(json['color'].substring(1, 7), radix: 16) + 0xFF000000),
      route: json['route'],
      type: json['type'],
      // type: ActivityType.values
      //     .firstWhere((e) => e.toString() == 'ActivityType.${json['type']}'),
      dateTime: DateTime.parse(json['dateTime']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subtitle': subtitle,
      // 'color': color.value,
      'route': route,
      'type': type.toString().split('.').last,
      'dateTime': dateTime.toIso8601String(),
    };
  }
}
