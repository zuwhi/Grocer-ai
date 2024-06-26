// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fpdart/fpdart.dart';
import 'package:green_cart_scanner/model/items/item.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:green_cart_scanner/model/statusState/StatusCondition.dart';
import 'package:green_cart_scanner/model/items/dateItems.dart';
import 'package:green_cart_scanner/service/appwrite/appwrite_item.dart';

part 'date_items_appwrite.g.dart';

@Riverpod(keepAlive: true)
class DateItemsAppwrite extends _$DateItemsAppwrite {
  @override
  DateItemsState build() =>
      DateItemsState(status: StatusCondition.init, data: []);
  final appwriteItem = AppwriteItemRepository();

  getAllDateItems() async {
    state = DateItemsState(status: StatusCondition.loading, data: []);
    Either<String, List<DateItems>> result =
        await appwriteItem.getAllDateItems();
    result.fold(
        (l) => state = DateItemsState(status: StatusCondition.failed, data: []),
        (r) =>
            state = DateItemsState(status: StatusCondition.success, data: r));
  }

  Future<Either<String, String>> createDateItems() async {
    Either<String, String> result =
        await appwriteItem.createDateItems();

        result.fold((l) => null, (r) => null);
    return result;
  }
}

class DateItemsState {
  final StatusCondition status;
  final List<DateItems> data;
  DateItemsState({
    required this.status,
    required this.data,
  });
}
