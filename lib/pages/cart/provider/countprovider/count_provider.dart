import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_cart_scanner/model/items/item.dart';

final countItemsProvider = ChangeNotifierProvider<CountItemsProvider>((ref) {
  return CountItemsProvider();
});

class CountItemsProvider extends ChangeNotifier {
  num? _weight;
  num? get weight => _weight;

  num? _price;
  num? get price => _price;

  int? _selectIndex;
  int? get selectIndex => _selectIndex;

  num kilos = 0.10;

  initCountItem(Item item) async {
    _price = item.harga;
    _weight = item.berat;
  }

  changePrice(price) async {
    _price = price.toInt();
    _weight = 1;

    notifyListeners();
  }

  changeKilos(num kilo) {
    num weight = kilo;
    num price =
        double.parse(((_price! / _weight!) * weight).toStringAsFixed(2));
    _price = price.toInt();
    _weight = weight;

    notifyListeners();
  }

  plusCountItem() async {
    num weight = double.parse((_weight! + kilos).toStringAsFixed(2));
    num price =
        double.parse(((_price! / _weight!) * weight).toStringAsFixed(2));

    _price = price.toInt();
    _weight = weight;

    notifyListeners();
  }

  minusCountItem() async {
    num weight = double.parse((_weight! - kilos).toStringAsFixed(2));
    num price =
        double.parse(((_price! / _weight!) * weight).toStringAsFixed(2));
    if (weight <= 0) {
      weight = 0.0;
    } else {
      _price = price.toInt();
      _weight = weight;
    }
    notifyListeners();
  }

  changeSelectIndex(index) {
    _selectIndex = index;
    notifyListeners();
  }

  countByKiloPercen(index) async {
    if (index == 0) {
      changeKilos(1);
    } else if (index == 1) {
      changeKilos(0.5);
    } else if (index == 2) {
      changeKilos(0.25);
    } else if (index == 3) {
      changeKilos(0.125);
    } else if (index == 4) {
      changeKilos(2);
    } else if (index == 5) {
      changeKilos(2.5);
    } else if (index == 6) {
      changeKilos(3);
    } else if (index == 7) {
      changeKilos(4);
    } else if (index == 8) {
      changeKilos(5);
    }
    notifyListeners();
  }
}
