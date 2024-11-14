class Attendance {
  final String attendanceId;
  final String scheduleId;
  final String studentId;
  final DateTime date;
  final String status;

  Attendance({
    required this.attendanceId,
    required this.scheduleId,
    required this.studentId,
    required this.date,
    required this.status,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      attendanceId: json['attendanceId'] as String,
      scheduleId: json['scheduleId'] as String,
      studentId: json['studentId'] as String,
      date: DateTime.parse(json['date']),
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'attendanceId': attendanceId,
      'scheduleId': scheduleId,
      'studentId': studentId,
      'date': date.toIso8601String(),
      'status': status,
    };
  }
}
