import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_cart_scanner/service/appwrite/appwrite_item.dart';
import 'package:green_cart_scanner/model/items/item.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:equatable/equatable.dart';

part 'get_all_items_appwrite.g.dart';

@riverpod
class GetAllItemsAppwrite extends _$GetAllItemsAppwrite {
  final appwriteItem = AppwriteItemRepository();

  Future<List<Item>> build() async => await appwriteItem.getData();
}
