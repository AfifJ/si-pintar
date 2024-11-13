import 'package:flutter/material.dart';

enum ActivityType { lecture, practicum, exam, assignment, project }

class Activity {
  final String title;
  final String subtitle;
  final Color color;
  final String route;
  final ActivityType type;
  final DateTime dateTime;

  Activity({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.route,
    required this.type,
    required this.dateTime,
  });
}
