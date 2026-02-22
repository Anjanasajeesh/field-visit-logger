import 'package:field_visit_logger/models/visit_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class VisitDatabase {
  static final VisitDatabase instance = VisitDatabase._init();
  static Database? _database;

  VisitDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('visits.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE visits(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          farmerName TEXT,
          village TEXT,
          cropType TEXT,
          notes TEXT,
          imagePath TEXT,
          latitude REAL,
          longitude REAL,
          dateTime TEXT,
          isSynced INTEGER
        )
        ''');
      },
    );
  }

  Future<void> insertVisit(Visit visit) async {
    final db = await database;
    await db.insert('visits', visit.toMap());
  }

  Future<List<Visit>> getVisits() async {
    final db = await database;
    final result = await db.query('visits', orderBy: 'id DESC');
    return result.map((e) => Visit.fromMap(e)).toList();
  }

  Future<void> markSynced(int id) async {
    final db = await database;
    await db.update(
      'visits',
      {'isSynced': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
