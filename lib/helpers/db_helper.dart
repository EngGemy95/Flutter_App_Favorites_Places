import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;

class DBHelper {
  static Future<sql.Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(
      path.join(dbPath, 'places.db'),
      version: 1,
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE user_places(id TEXT PRIMARY KEY,title TEXT,image TEXT,loc_lat REAL,loc_lng REAL,address TEXT)');
      },
    );
  }

  static Future<List<Map<String, dynamic>>> getPlaces(String table) async {
    final db = await DBHelper.database();
    return db.query(table);
  }

  static Future<void> insertPlace(
      String table, Map<String, Object> dataValues) async {
    final db = await DBHelper.database();
    db.insert(
      table,
      dataValues,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }
}
