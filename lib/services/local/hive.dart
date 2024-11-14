import 'package:hive_flutter/hive_flutter.dart';
import 'package:si_pintar/models/user.dart';

class HiveService {
  static const String userBox = 'elearningBox';

  // Singleton pattern
  static final HiveService _instance = HiveService._internal();
  factory HiveService() => _instance;
  HiveService._internal();

  Future<void> init() async {
    await Hive.initFlutter();

    // Open boxes
    await Hive.openBox<User>(userBox);
  }

  // User methods
  Future<void> saveUser(User user) async {
    final box = Hive.box<User>(userBox);
    await box.put('currentUser', user);
  }

  User? getUser() {
    final box = Hive.box<User>(userBox);
    return box.get('currentUser');
  }

  Future<void> deleteUser() async {
    final box = Hive.box<User>(userBox);
    await box.delete('currentUser');
  }

  Future<void> clearAll() async {
    final box = Hive.box<User>(userBox);
    await box.clear();
  }
}
