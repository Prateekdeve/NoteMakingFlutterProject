import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

// Database Helper Class

class DatabaseHelper {
  // Singelton Design Patterns
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final dbFullPath = path.join(dbPath, filePath);

    return await openDatabase(dbFullPath, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
    Create Table notes{
    id $idType,
    title $textType,
    content $textType,
    createdAt $textType
    }
    ''');
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('notes.db');
    return _database!;
  }
}
