import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:pdfcreator/model/image_model.dart';

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""
    CREATE TABLE IF NOT EXISTS images (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      imageData TEXT
    )
    """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'image.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  static Future<int> createItem(String imageData) async {
    final db = await SQLHelper.db();
    final data = {'imageData': imageData};
    final id = await db.insert('images', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<ImageModel>> getImages() async {
    final db = await SQLHelper.db();
    final List<Map<String, dynamic>> studentMaps = await db.query('images');
    return List.generate(studentMaps.length, (i) {
      return ImageModel(
        id: studentMaps[i]['id'],
        imageData: studentMaps[i]['imageData'],
      );
    });
  }

  static Future<void> deleteItem(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("images", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Error deleting item: $err");
    }
  }
}
