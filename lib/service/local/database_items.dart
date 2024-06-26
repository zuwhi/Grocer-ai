import 'dart:io' as io;

import 'package:fpdart/fpdart.dart';
import 'package:green_cart_scanner/model/items/item.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class ItemsRepository {
  static final ItemsRepository _instance = ItemsRepository.internal();
  ItemsRepository.internal();

  factory ItemsRepository() => _instance;
  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) return _db;
    _db = await initDB();
    return _db;
  }

  Future<Database> initDB() async {
    io.Directory docDirectory = await getApplicationDocumentsDirectory();
    String path = join(docDirectory.path, 'itemsDB.db');
    var localDB = await openDatabase(path, version: 1, onCreate: _onCreate);
    return localDB;
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      create table if not exists items(
        id TEXT primary key,
         nama_item TEXT,
         nama_kota TEXT,
         harga INTEGER,
         dateItems TEXT,
         berat REAL
      )
      ''');
  }

  Future<List<Item>> getAllItem() async {
    var dbClient = await db;
    var items = await dbClient!.query(
      'items',
    );

    return items.map((item) => Item.fromMap(item)).toList();
  }

  Future<int> updateItems(Item item) async {
    var dbClient = await db;
    return await dbClient!.update(
      'items',
      {'harga': item.harga},
      where: 'nama_item = ?',
      whereArgs: [item.nama_item],
    );
  }

  Future<Item?> getFirstItem() async {
    var dbClient = await db;
    var items = await dbClient!.query(
      'items',
      limit: 1,
    );

    if (items.isNotEmpty) {
      return Item.fromMap(items.first);
    } else {
      return null;
    }
  }

  Future<Either<String, bool>> insertItem(Item item) async {
    try {
      var dbClient = await db;
      // Logger().d(item.toMap());
      await dbClient!.insert('items', item.toMapDate());
      return const Right(true);
    } catch (e) {
      return Left("terjadi kesalahan $e");
    }
  }

  Future<List<Item>> insertDummyData() async {
    print('cek 1');
    List<Map<String, dynamic>> dummyData = [
      {
        'id': '1',
        'nama_item': 'Tomat',
        'nama_kota': 'Jepara',
        'harga': 50000,
        'tanggal': '2024-03-24',
      },
      {
        'id': '2',
        'nama_item': 'Kol',
        'nama_kota': 'Jepara',
        'harga': 25000,
        'dateItems': '2024-03-25',
      },
      {
        'id': '3',
        'nama_item': 'Wortel',
        'nama_kota': 'Semarang',
        'harga': 30000,
        'dateItems': '2024-03-24',
      },
    ];
    for (var data in dummyData) {
      var dbClient = await db;
      await dbClient!.insert('items', data);
    }
    final cek = await getAllItem();
    return cek;
  }

  Future<void> deleteAllItems() async {
    Logger().d("menghapus semua isi database item di local");
    var dbClient = await db;
    await dbClient!.delete('items');
  }
}
