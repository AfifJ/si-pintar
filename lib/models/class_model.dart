class ClassModel {
  final String classId;
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
    required this.classId,
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
    final classData = json['classes'] ?? json;

    return ClassModel(
      classId: classData['class_id'] ?? '',
      title: classData['title'] ?? '',
      subtitle: classData['subtitle'] ?? '',
      semester: int.parse(classData['semester']?.toString() ?? '0'),
      credits: int.parse(classData['sks']?.toString() ?? '0'),
      lecturer: classData['users']?['lecturer_name'] ?? '',
      description: classData['description'] ?? '',
      room: classData['room'] ?? '',
      classSection: classData['class_section'] ?? '',
      schedule: Map<String, String>.from(classData['schedule'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'class_id': classId,
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
