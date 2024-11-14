class Submission {
  final String submissionId;
  final String assignmentId;
  final String studentId;
  final String filePath;
  final DateTime submissionDate;
  final double? score;
  final String? feedback;

  Submission({
    required this.submissionId,
    required this.assignmentId,
    required this.studentId,
    required this.filePath,
    required this.submissionDate,
    this.score,
    this.feedback,
  });

  factory Submission.fromJson(Map<String, dynamic> json) {
    return Submission(
      submissionId: json['submissionId'] as String,
      assignmentId: json['assignmentId'] as String,
      studentId: json['studentId'] as String,
      filePath: json['filePath'] as String,
      submissionDate: DateTime.parse(json['submissionDate']),
      score: json['score'] as double?,
      feedback: json['feedback'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'submissionId': submissionId,
      'assignmentId': assignmentId,
      'studentId': studentId,
      'filePath': filePath,
      'submissionDate': submissionDate.toIso8601String(),
      'score': score,
      'feedback': feedback,
    };
  }
}
