// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:green_cart_scanner/model/history/historymodel.dart';
import 'package:green_cart_scanner/model/items/item.dart';
import 'package:green_cart_scanner/service/local/database_history.dart';
import 'package:green_cart_scanner/model/statusState/StatusCondition.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'history_database.g.dart';

@riverpod
class HistoryDatabase extends _$HistoryDatabase {
  @override
  HistoryDatabaseState build() =>
      const HistoryDatabaseState(StatusCondition.init, '', []);

  final db = HistoryRepository();

  getAllHistory() async {
    print("halo 1");
    state = const HistoryDatabaseState(StatusCondition.loading, '', []);
    List<HistoryModel> result = await db.getAllData();
    Logger().d(result);

    state = HistoryDatabaseState(StatusCondition.success, '', result);
  }

  getHistoryByDate({required String date}) async {
    Logger().d(date);
    state = const HistoryDatabaseState(StatusCondition.loading, '', []);
    final result = await db.getDataByDate(date);
    Logger().d(result);
    state = HistoryDatabaseState(StatusCondition.success, '', result);
  }

  insertDataToHistory(List<Item> items) async {
    state = const HistoryDatabaseState(StatusCondition.loading, '', []);

    await db.insertHistory(items);
    // getAllHistory();
  }

  deleteHistoryById(id) async {
    var deleteHistory = await db.deleteById(id);
    getAllHistory();
  }

  insertDummyHistory() async {
    state = const HistoryDatabaseState(StatusCondition.loading, '', []);

    List<Item> items = [
      Item(id: '1', nama_item: "kol", harga: 2000),
      Item(id: '2', nama_item: "tomat", harga: 3000)
    ];

    final result = await db.insertDummyHistory(items);
    getAllHistory();
  }
}

class HistoryDatabaseState extends Equatable {
  final StatusCondition status;
  final String message;
  final List<HistoryModel> data;
  const HistoryDatabaseState(
    this.status,
    this.message,
    this.data,
  );

  @override
  // Task: implement props
  List<Object> get props => [status, message, data];
}
