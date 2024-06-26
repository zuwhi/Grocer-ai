import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:green_cart_scanner/model/items/item.dart';
import 'package:green_cart_scanner/service/local/database_items.dart';
import 'package:green_cart_scanner/model/statusState/StatusCondition.dart';
import 'package:green_cart_scanner/pages/item/provider/items_online/items_appwrite.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'items_database.g.dart';

@riverpod
class ItemsDatabase extends _$ItemsDatabase {
  @override
  ItemsDatabaseState build() =>
      const ItemsDatabaseState(StatusCondition.init, '', []);
  final db = ItemsRepository();

  getAllItems() async {
    state = const ItemsDatabaseState(StatusCondition.loading, '', []);
    final items = await db.getAllItem();
    state = ItemsDatabaseState(StatusCondition.success, '', items);
  }

  insertDataDummy() async {
    // state = ItemsDatabaseState('', '', []);
    final items = await db.insertDummyData();
    getAllItems();
  }

  updateItems(item) async {
    state = const ItemsDatabaseState(StatusCondition.loading, '', []);
    Logger().d(item);
   await db.updateItems(item);
    final items = await db.getAllItem();
    state = ItemsDatabaseState(StatusCondition.success, '', items);
  }

  deleteAllItem() async {
    await db.deleteAllItems();
  }

  Future<Item?> getFirstItem() async {
    final result = await db.getFirstItem();
    return result;
  }

  Future<Either<String, bool>> synchronToDBLocal(Item item) async {
    Either<String, bool> result = await db.insertItem(item);
    state = const ItemsDatabaseState(StatusCondition.success, '', []);
    return result;
  }

  Future<Either<String, bool>> autoSynchronDataPrice() async {
    List<Item> items =
        await ref.watch(itemsAppwriteProvider.notifier).getAllItemsByDateNow();
    deleteAllItem();
    for (Item item in items) {
      await synchronToDBLocal(item);
    }

    return const Right(true);
  }
}

class ItemsDatabaseState extends Equatable {
  final StatusCondition status;
  final String message;
  final List<Item> data;
  const ItemsDatabaseState(
    this.status,
    this.message,
    this.data,
  );

  @override
  // Task: implement props
  List<Object> get props => [status, message, data];
}
