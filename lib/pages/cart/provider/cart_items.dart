// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_cart_scanner/model/items/item.dart';
import 'package:green_cart_scanner/pages/cart/provider/total_items.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cart_items.g.dart';

@Riverpod(keepAlive: true)
class CartItems extends _$CartItems {
  @override
  List<Item> build() => [];

  addItem(Item data) async {
    state = [...state, data];
    Logger().d(state.last.harga);
    ref.watch(totalItemsProvider.notifier).addTotalItems(state.last.harga ?? 0);
  }

  removeItem(int index) async {
    state.removeAt(index);
    state = [...state];
  }

  updateItem(int index, Item newData) async {
    if (index >= 0 && index < state.length) {
      state[index] = newData;
      state = [...state];
    }
  }

  manualDispose() async {
    state = [];
  }

  editPriceItem(index, harga, berat) async {
    state[index].harga = int.parse(harga);
    state[index].berat = double.parse(berat);
  }
}

// class CartItemsState {
//   final List<Map<String, dynamic>> listItem;
//   CartItemsState({
//     required this.listItem,
//   });

//   get length => null;
// }
