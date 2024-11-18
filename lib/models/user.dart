class User {
  String userId;
  String username;
  String npm;
  String password;
  String email;
  String full_name;
  String role;
  int semester;
  String image_url;
  String academic_year;

  User(
    this.userId,
    this.username,
    this.npm,
    this.password,
    this.email,
    this.full_name,
    this.role,
    this.semester, {
    this.image_url = '',
    this.academic_year = '',
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
      image_url: json['image_url'] as String? ?? '',
      academic_year: json['academic_year'] as String? ?? '',
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
      'image_url': image_url,
      'academic_year': academic_year,
    };
  }
}
