import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:green_cart_scanner/model/items/item.dart';
import 'package:green_cart_scanner/service/appwrite/appwrite_item.dart';
import 'package:green_cart_scanner/model/statusState/StatusCondition.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'items_appwrite.g.dart';

@Riverpod(keepAlive: true)
class ItemsAppwrite extends _$ItemsAppwrite {
  @override
  ItemsAppwriteState build() =>
      const ItemsAppwriteState(StatusCondition.init, '', []);
  final appwriteItem = AppwriteItemRepository();

  getAllItems() async {
    state = const ItemsAppwriteState(StatusCondition.loading, '', []);
    try {
      final items = await appwriteItem.getData();
      state = ItemsAppwriteState(StatusCondition.success, '', items);
    } catch (e) {
      state = ItemsAppwriteState(
          StatusCondition.failed, 'gagal mendapatkan data $e', const []);
    }
    return state;
  }

  Future<List<Item>> getAllItemsByDateNow() async {
    state = const ItemsAppwriteState(StatusCondition.loading, '', []);
    String result = await appwriteItem.getDataByDateNow();
    List<Item> items = await getItemsByDate(date: result);
    return items;
  }

  Future<List<Item>> getItemsByDate({required String date}) async {
    state = const ItemsAppwriteState(StatusCondition.loading, '', []);
    try {
      final items = await appwriteItem.getItemsDataByDate(date: date);
      state = ItemsAppwriteState(StatusCondition.success, '', items);
      return items;
    } catch (e) {
      state = ItemsAppwriteState(
          StatusCondition.failed, 'gagal mendapatkan data $e', const []);
      return [];
    }
  }

  Future<Either<String, String>> addItems(
      {required Item item, required String dateItemsId}) async {
    Either<String, String> result = await appwriteItem.createItemsAppwrite(
        item: item, dateItemsId: dateItemsId);
    return result;
  }

  Future<Either<String, bool>> addItemsLoop(
      {required List<Item> items, required String dateItemsId}) async {
    try {
      for (Item item in items) {
        await addItems(item: item, dateItemsId: dateItemsId);
      }
      return const Right(true);
    } catch (e) {
      return const Left("terdapat kesalahan");
    }
  }

  Future<Either<String, String>> editItems(
      {required Item item, required String date}) async {
    state = const ItemsAppwriteState(StatusCondition.loading, '', []);
    Either<String, String> result = await appwriteItem.updateItemsAppwrite(
      item: item,
    );

    return result.fold((l) => Left(l), (r) {
      getItemsByDate(date: date);
      return Right(r);
    });
  }
}

class ItemsAppwriteState extends Equatable {
  final StatusCondition status;
  final String message;
  final List<Item> data;
  const ItemsAppwriteState(
    this.status,
    this.message,
    this.data,
  );

  @override
  // Task: implement props
  List<Object> get props => [status, message, data];
}
