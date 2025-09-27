import 'dart:typed_data';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  static const String table = 'faces';
  static const String columnId = 'id';
  static const String columnName = 'name';
  static const String columnEmbedding = 'embedding';
  static const String columnFaceImage = 'faceImage';

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('face_database.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('ALTER TABLE $table ADD COLUMN $columnFaceImage BLOB');
        }
      },
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table(
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnName TEXT,
        $columnEmbedding TEXT,
        $columnFaceImage BLOB
      )
    ''');
  }

  Future<int> insertFace(String name, List<double> embedding, Uint8List faceImage) async {
    final db = await database;
    String embeddingStr = embedding.join(',');
    return await db.insert(
      table,
      {
        columnName: name,
        columnEmbedding: embeddingStr,
        columnFaceImage: faceImage,
      },
      // conflictAlgorithm: ConflictAlgorithm., // allow multiple images per name
    );
  }

  Future<List<Map<String, dynamic>>> getAllFaces() async {
    final db = await database;
    return await db.query(table);
  }

  Future<Map<String, dynamic>?> getFace(int id) async {
    final db = await database;
    final res = await db.query(table, where: '$columnId = ?', whereArgs: [id]);
    if (res.isNotEmpty) {
      return res.first;
    } else {
      return null;
    }
  }

  Future<int> deleteFace(int id) async {
    final db = await database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  Future close() async {
    final db = await database;
    db.close();
  }
}