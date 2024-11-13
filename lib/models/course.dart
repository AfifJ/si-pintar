class Course {
  final String title;
  final String subtitle;
  final int semester;
  final int credits;
  final String lecturer;
  final String description;
  final String room;
  final String classSection;
  final Map<String, String> schedule;

  Course({
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
}
