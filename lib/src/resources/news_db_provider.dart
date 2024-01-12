import 'package:news/src/resources/repository.dart';
import 'package:sqflite/sqflite.dart';

import "package:path_provider/path_provider.dart";

import 'dart:io';

import '../models/itemmodel.dart';
import 'package:path/path.dart';
import 'repository.dart';

class NewsDbProvider implements Source, Cache {
  Database? db;
  NewsDbProvider() {
    init();
  }
  Future<List<int>> fetchTopIds() async {
    return Future(() => [1, 2, 3]);
  }

  void init() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'items1.db');
    db = await openDatabase(path, version: 1,
        onCreate: (Database newDb, int version) {
      newDb.execute("""
        CREATE TABLE Items(
          id INTEGER PRIMARY KEY,
          deleted INTEGER,
          type TEXT,
          by TEXT,
          time INTEGER,
          text TEXT,
          dead INTEGER,
          parent INTEGER,
          poll INTEGER,
          kids BLOB,
          url TEXT,
          score INTEGER,
          title TEXT,
          parts BLOB,
          descendants INTEGER
        )
""");
    });
  }

  Future<ItemModel?> fetchItem(id) async {
    final maps = await db?.query(
      "Items",
      columns: null,
      where: "id=?",
      whereArgs: [id],
    );
    if (maps!.isNotEmpty) {
      return ItemModel.fromDb(maps.first);
    }
    return null;
  }

  Future<int> addItem(ItemModel? item) {
    return db!.insert("Items", item!.toMap(),
    conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<int> clear() {
    return db!.delete("Items");
  }
}

final newsdbprovider = NewsDbProvider();
