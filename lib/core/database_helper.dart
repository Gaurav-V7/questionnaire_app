import 'dart:convert';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE submissions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        questionnaire_id INTEGER,
        answers TEXT,
        submitted_at TEXT,
        latitude REAL,
        longitude REAL
      )
''');
  }

  Future<int> insertSubmission(Map<String, dynamic> data) async {
    final db = await database;
    return db.insert('submissions', data);
  }

  Future<bool> isQuestionnaireSubmitted(int questionnaireId) async {
    final db = await database;

    final result = await db.query(
      'submissions',
      where: 'questionnaire_id = ?',
      whereArgs: [questionnaireId],
    );

    return result.isNotEmpty;
  }

  Future<List<int>?> getSubmissionAnswers(int questionnaireId) async {
    final db = await database;

    final result = await db.query(
      'submissions',
      where: 'questionnaire_id = ?',
      whereArgs: [questionnaireId],
    );

    if (result.isEmpty) return null;

    final answersJson = result.first['answers'] as String;

    return List<int>.from(jsonDecode(answersJson));
  }
}
