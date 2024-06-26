import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final addItemsLoadingProvider = ChangeNotifierProvider<AddItemsLoading>((ref) {
  return AddItemsLoading();
});

class AddItemsLoading extends ChangeNotifier {
  bool _isLoad = false;
  bool get isLoad => _isLoad;

  changeIsLoad() {
    _isLoad = !_isLoad;
    notifyListeners();
  }
}
