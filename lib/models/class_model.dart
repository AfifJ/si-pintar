class ClassModel {
  final String title;
  final String subtitle;
  final int semester;
  final int credits;
  final String lecturer;
  final String description;
  final String room;
  final String classSection;
  final Map<String, String> schedule;

  ClassModel({
    required this.title,
    required this.subtitle,
    required this.semester,
    required this.credits,
    required this.lecturer,
    required this.description,
    required this.room,
    required this.classSection,
    required this.schedule,
  });

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      semester: json['semester'] as int,
      credits: json['credits'] as int,
      lecturer: json['lecturer'] as String,
      description: json['description'] as String,
      room: json['room'] as String,
      classSection: json['classSection'] as String,
      schedule: Map<String, String>.from(json['schedule']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subtitle': subtitle,
      'semester': semester,
      'credits': credits,
      'lecturer': lecturer,
      'description': description,
      'room': room,
      'classSection': classSection,
      'schedule': schedule,
    };
  }
}
