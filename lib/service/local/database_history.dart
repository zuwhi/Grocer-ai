import 'dart:convert';
import 'dart:io' as io;

import 'package:green_cart_scanner/model/history/historymodel.dart';
import 'package:green_cart_scanner/model/history/history.dart';
import 'package:green_cart_scanner/model/items/item.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

class HistoryRepository {
  static final HistoryRepository _instance = HistoryRepository.internal();
  HistoryRepository.internal();

  factory HistoryRepository() => _instance;
  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) return _db;
    _db = await initDB();
    return _db;
  }

  Future<Database> initDB() async {
    io.Directory docDirectory = await getApplicationDocumentsDirectory();
    String path = join(docDirectory.path, 'history.db');
    var localDB = await openDatabase(path, version: 1, onCreate: _onCreate);
    return localDB;
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      create table if not exists history(
        id TEXT ,
        items TEXT,
        date TEXT
      )
      ''');
  }

  insertHistory(List<Item> listItems) async {
    try {
      String id = const Uuid().v4();
      String sekarang = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());

      // karena pada sqflite attribute Text tabelnya hanya bisa menerima string dan tidak ada attribute list
      // saya menggunakan jsonEncode untuk merubah list items saya menjadi string

      String itemString = jsonEncode(listItems);
      var dbClient = await db;
      dbClient!.insert(
          'history', {'id': id, 'items': itemString, 'date': sekarang},
          conflictAlgorithm: ConflictAlgorithm.replace);
      // print('oke');
    } catch (e) {
      print('error e = $e');
    }
  }

  getAllData() async {
    var dbClient = await db;
    List<Map<String, Object?>> result = await dbClient!.query(
        'history'); // result = [ {"id": "97ba0534-1c36-44cd-8e0b-06cdb8640797", "items": "[\"{\\\"id\\\":\\\"1\\\",\\\"nama_item\\\":\\\"kol\\\",\\\"nama_kota\\\":null,\\\"harga\\\":2000,\\\"tanggal\\\":null}\",\"{\\\"id\\\":\\\"2\\\",\\\"nama_item\\\":\\\"tomat\\\",\\\"nama_kota\\\":null,\\\"harga\\\":3000,\\\"tanggal\\\":null}\"]"}]

    // karena result bentuknya list of object maka saya lakukan perulangan agar bisa menjadi ke bentuk HistoryModel
    List<HistoryModel> histories = [];
    for (var e in result) {
      //mengembalikan object ke dalam string
      String id = e['id'].toString();
      List<dynamic> listString = jsonDecode(e['items'].toString());

      //melakukan decode agar listString di atas menjadi List Item
      List<Item> itemsList = listString.map((e) {
        Map<String, dynamic> jsonMap = jsonDecode(e);
        return Item.fromJson(jsonMap);
      }).toList();

      //disini saya memasukkan list item di atas ke dalam model dan memaukkannyak ke dalam list hitorymodel
      HistoryModel history =
          HistoryModel(id: id, items: itemsList, date: e['date'].toString());
      histories.add(history);
    }
    Logger().d(histories);
    return histories;
  }

  getDataByDate(date) async {
    var dbClient = await db;
    var formattedDate = date.substring(0, 10);

    List<Map<String, Object?>> result = await dbClient!.query(
      'history',
      where: 'SUBSTR(date, 1, 10) = ?',
      whereArgs: [formattedDate],
    );

    List<HistoryModel> histories = [];
    for (var e in result) {
      //mengembalikan object ke dalam string
      String id = e['id'].toString();
      List<dynamic> listString = jsonDecode(e['items'].toString());

      //melakukan decode agar listString di atas menjadi List Item
      List<Item> itemsList = listString.map((e) {
        Map<String, dynamic> jsonMap = jsonDecode(e);
        return Item.fromJson(jsonMap);
      }).toList();

      //disini saya memasukkan list item di atas ke dalam model dan memaukkannyak ke dalam list hitorymodel
      HistoryModel history =
          HistoryModel(id: id, items: itemsList, date: e['date'].toString());
      histories.add(history);
    }
    Logger().d(histories);
    return histories;

    // return histories.map((history) => History.fromMap(history)).toList();
  }

  Future<List<History>> getAllDataById(id) async {
    var dbClient = await db;
    var histories = await dbClient!.query(
      'history',
      where: 'id=?',
      whereArgs: [id],
    );

    return histories.map((history) => History.fromMap(history)).toList();
  }

  Future<void> deleteById(id) async {
    var dbClient = await db;
    await dbClient!.delete(
      'history',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  insertData(History history) async {
    var dbClient = await db;
    return dbClient!.insert('history', history.toMap());
  }

  Future<void> deleteAllItems() async {
    var dbClient = await db;
    await dbClient!.delete('history');
  }

  insertDummyHistory(List<Item> listItems) async {
    try {
      String id = const Uuid().v4();
      String sekarang = DateFormat('kk:mm (d-M-y) ').format(DateTime.now());

      String itemString = jsonEncode(listItems);
      var dbClient = await db;
      dbClient!.insert(
          'history', {'id': id, 'items': itemString, 'date': sekarang},
          conflictAlgorithm: ConflictAlgorithm.replace);
      // print('oke');
    } catch (e) {
      print('error e = $e');
    }
  }
}
