class Material {
  final String title;
  final String description;
  final String fileUrl;
  final DateTime date;
  final bool hasTask;
  final bool hasAttachment;
  final String? attachmentUrl;
  final String subtitle;
  final int semester;
  final int credits;
  final String lecturer;
  final String room;
  final String classSection;
  final Map<String, String> schedule;

  Material({
    required this.title,
    required this.description,
    required this.fileUrl,
    required this.date,
    this.hasTask = false,
    this.hasAttachment = false,
    this.attachmentUrl,
    required this.subtitle,
    required this.semester,
    required this.credits,
    required this.lecturer,
    required this.room,
    required this.classSection,
    required this.schedule,
  });

  factory Material.fromJson(Map<String, dynamic> json) {
    return Material(
      title: json['title'] as String,
      description: json['content'] as String,
      fileUrl: json['fileUrl'] ?? '',
      date: DateTime.parse(json['date']),
      hasTask: json['hasTask'] as bool? ?? false,
      hasAttachment: json['hasAttachment'] as bool? ?? false,
      attachmentUrl: json['attachmentUrl'] as String?,
      subtitle: json['subtitle'] as String,
      semester: json['semester'] as int,
      credits: json['credits'] as int,
      lecturer: json['lecturer'] as String,
      room: json['room'] as String,
      classSection: json['classSection'] as String,
      schedule: Map<String, String>.from(json['schedule'] as Map),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': description,
      'fileUrl': fileUrl,
      'date': date.toIso8601String(),
      'hasTask': hasTask,
      'hasAttachment': hasAttachment,
      'attachmentUrl': attachmentUrl,
      'subtitle': subtitle,
      'semester': semester,
      'credits': credits,
      'lecturer': lecturer,
      'room': room,
      'classSection': classSection,
      'schedule': schedule,
    };
  }
}
