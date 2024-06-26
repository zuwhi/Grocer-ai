import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_cart_scanner/model/items/item.dart';
import 'package:green_cart_scanner/pages/cart/provider/cart_items.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:logger/logger.dart';
part 'total_items.g.dart';

@Riverpod(keepAlive: true)
class TotalItems extends _$TotalItems {
  @override
  num build() => 0;

  addTotalItems(num harga) {
    Logger().d(harga);
    state += harga;
  }

  deleteIndexTotalItems(num harga) {
    state -= harga;
  }

  disposeTotal() async {
    state = 0;
  }

  countTotal(List<Item> items) async {
    num total = 0;
    for (var i in items) {
      total += int.parse(i.harga.toString());
    }
    state = total;
  }
}
