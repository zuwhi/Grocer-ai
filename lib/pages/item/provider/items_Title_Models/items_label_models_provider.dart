import 'package:flutter/services.dart' show rootBundle;
import 'package:green_cart_scanner/model/items/item.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'items_label_models_provider.g.dart';

@Riverpod(keepAlive: true)
class ItemsLabelModels extends _$ItemsLabelModels {
  @override
  List<Item> build() => [];

  getLabels() async {
    String textModels = await rootBundle.loadString('assets/labels.txt');
    List listLabels = textModels.split('\n');
    state = listLabels.map((e) => Item(nama_item: e.trim(), berat: 1)).toList();
  }

  updatePrice(index, {required Item item}) async {
    state[index] = item;
  }

  getFromDateCurrent({required List<Item> items}) async {
    state = items;
  }
}
