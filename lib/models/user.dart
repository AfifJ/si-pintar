class User {
  String userId;
  String username;
  String npm;
  String password;
  String email;
  String full_name;
  String role;
  int semester;
  String imageUrl;
  String nim;
  String academicYear;

  User(
    this.userId,
    this.username,
    this.npm,
    this.password,
    this.email,
    this.full_name,
    this.role,
    this.semester, {
    this.imageUrl = '',
    this.nim = '',
    this.academicYear = '',
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      json['user_id'] as String,
      json['username'] as String,
      json['npm'] as String,
      json['password'] as String,
      json['email'] as String,
      json['full_name'] as String,
      json['role'] as String,
      // json['semester'] is int
      //     ? json['semester'] as int
      //     : int.parse(json['semester']),
      int.tryParse(json['semester'].toString()) ?? 1,
      imageUrl: json['imageUrl'] as String? ?? '',
      nim: json['nim'] as String? ?? '',
      academicYear: json['academicYear'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'username': username,
      'npm': npm,
      'password': password,
      'email': email,
      'full_name': full_name,
      'role': role,
      'semester': semester.toString(),
      'imageUrl': imageUrl,
      'nim': nim,
      'academicYear': academicYear,
    };
  }
}
