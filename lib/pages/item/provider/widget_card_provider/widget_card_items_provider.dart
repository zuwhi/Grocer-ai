import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final widgetCardItemsProvider =
    ChangeNotifierProvider<WidgetCardItemsProvider>((ref) {
  return WidgetCardItemsProvider();
});

class WidgetCardItemsProvider extends ChangeNotifier {
  bool _isGrid = false;
  bool get isGrid => _isGrid;

  changeIsGrid() {
    _isGrid = !_isGrid;
    notifyListeners();
  }


}
