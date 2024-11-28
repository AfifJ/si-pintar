import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'nilai_database.db');

    try {
      await Directory(dirname(path)).create(recursive: true);
    } catch (_) {}

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      singleInstance: true,
      readOnly: false,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE mata_kuliah(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nama TEXT NOT NULL,
        sks INTEGER DEFAULT 2,
        nilai_huruf TEXT DEFAULT 'A',
        nilai_angka REAL DEFAULT 4.0
      )
    ''');

    await db.execute('''
      CREATE TABLE profile_images(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        image_path TEXT NOT NULL
      )
    ''');
  }

  // CRUD Operations
  Future<int> insertMataKuliah(Map<String, dynamic> mataKuliah) async {
    final db = await database;
    return await db.insert('mata_kuliah', mataKuliah);
  }

  Future<List<Map<String, dynamic>>> getAllMataKuliah() async {
    final db = await database;
    final results = await db.query('mata_kuliah');
    return List.generate(
        results.length, (i) => Map<String, dynamic>.from(results[i]));
  }

  Future<int> updateMataKuliah(Map<String, dynamic> mataKuliah) async {
    final mutableData = Map<String, dynamic>.from(mataKuliah);
    final db = await database;
    return await db.update(
      'mata_kuliah',
      mutableData,
      where: 'id = ?',
      whereArgs: [mutableData['id']],
    );
  }

  Future<int> deleteMataKuliah(int id) async {
    final db = await database;
    return await db.delete(
      'mata_kuliah',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteAllMataKuliah() async {
    final db = await database;
    return await db.delete('mata_kuliah');
  }

  Future<void> saveProfileImage(String imagePath) async {
    final db = await database;
    await db.insert(
      'profile_images',
      {'image_path': imagePath},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> getProfileImage() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('profile_images');
    if (maps.isNotEmpty) {
      return maps.first['image_path'] as String?;
    }
    return null;
  }
}
