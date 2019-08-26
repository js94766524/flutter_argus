import 'dart:async';
import 'dart:convert';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'post_data.dart';

class Cacher {
  static const int version = 1;
  static Database db;

  static Future<void> init() async {
    final dir = await getDatabasesPath();
    final path = join(dir, "argus.db");
    db = await openDatabase(path, version: version, onCreate: initTables);
  }

  static Future<void> cache(PostData data) async {
    await db.insert(
        "Events", {"id": data.id, "raw_json": json.encode(data.toJson())});
  }

  static Future<bool> delete(String id) async {
    return 1 == await db.delete("Events", where: "id = '$id'");
  }

  static Future<List<Map<String, dynamic>>> getAllCached() async {
    final all = await db.query("Events");
    return all.map((i) => json.decode(i["raw_json"]) as Map<String,dynamic>).toList();
  }

  static FutureOr<void> initTables(Database db, int version) async {
    await db.transaction<void>((trans) async {
      await trans.execute(
        "CREATE TABLE Events ("
        "id TEXT PRIMARY KEY, "
        "raw_json TEXT"
        ");",
      );
    });
  }
}
