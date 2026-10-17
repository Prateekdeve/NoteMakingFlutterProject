import 'package:my_first_app/model.dart';
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

  // Setting up SQLite Database for CRUD Operations on Notes

  // Create notes
  Future<Note> createNote(Note note) async {
    final db = await database;
    final id = await db.insert('notes', note.ToMap());
    return note.copyWith(id: id);
  }

  // Get all notes
  Future<List<Note>> getAllNotes() async {
    final db = await database;
    const orderBy = 'createdAt DESC';
    final result = await db.query('notes', orderBy: orderBy);
    return result.map((map) => Note.fromMap(map)).toList();
  }

  // Get a note by id
  Future<Note?> getNoteById(int id) async {
    final db = await database;
    final maps = await db.query('notes', where: 'id=?', whereArgs: [id]);

    if (maps.isNotEmpty) {
      return Note.fromMap(maps.first);
    }
    return null;
  }

  // Update a note
  Future<int> updateNote(Note note) async {
    final db = await database;
    return db.update(
      'notes',
      note.ToMap(),
      where: 'id=?',
      whereArgs: [note.id],
    );
  }

  // Delete a note
  Future<int> deleteNote(int id) async {
    final db = await database;
    return await db.delete('notes', where: 'id=?', whereArgs: [id]);
  }
}
