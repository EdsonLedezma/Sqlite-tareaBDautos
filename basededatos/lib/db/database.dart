import 'package:sqflite/sqflite.dart' as sqlite;
import 'package:path/path.dart';

import '../autos/jdm.dart';

class Database {
  static Future<sqlite.Database> db() async {
    var databasesPath = await sqlite.getDatabasesPath();
    return sqlite.openDatabase(
      join(databasesPath, "autos.db"),
      version: 1,
      onCreate: (db, version) async {
        await crearTablas(db);
      },
    );
  }

  static Future<void> crearTablas(sqlite.Database db) async {
    await db.execute("""
    CREATE TABLE autos (
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      nombre TEXT NOT NULL,
      km REAL NOT NULL,
      distancia100 REAL NOT NULL,
      creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    );
    """);
  }

  static Future<int> insertar(Autos auto) async {
    sqlite.Database db = await Database.db();
    return await db.insert(
      "autos",
      auto.aMapa(),
      conflictAlgorithm: sqlite.ConflictAlgorithm.replace,
    );
  }

  static Future<int> eliminar(int id) async {
    sqlite.Database db = await Database.db();
    return await db.delete(
      "autos",
      where: "id = ?",
      whereArgs: [id],
    );
  }

  static Future<int> actualizar(Autos auto) async {
    sqlite.Database db = await Database.db();
    return await db.update(
      "autos",
      auto.aMapa(),
      where: "id = ?",
      whereArgs: [auto.id],
    );
  }

  static Future<List<Autos>> seleccionarTodos() async {
    sqlite.Database db = await Database.db();
    List<Map<String, dynamic>> datos = await db.query("autos");
    return datos.map((e) => Autos.fromMap(e)).toList();
  }
}
