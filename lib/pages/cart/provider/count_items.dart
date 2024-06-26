// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:logger/logger.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';

// import 'package:green_cart_scanner/domain/entities/item.dart';
// import 'package:green_cart_scanner/presentation/pages/cart/provider/cart_items.dart';

// part 'count_items.g.dart';

// @Riverpod(keepAlive: true)
// class CountItems extends _$CountItems {
//   @override
//   CountItemState build() => CountItemState(price: 0, weight: 0);
//   num kilos = 0.10;

//   initCountItem(Item item) async {
//     state = CountItemState(price: item.harga, weight: item.berat);
//     // print('Count item : ${state.price}');
//   }

//   changePrice(price) async {
//     state = CountItemState(price: price.toInt(), weight: 1);
//   }

//   changeKilos(num kilo) {
//     print(kilo);
//     num weight = kilo;
//     num price = double.parse(
//         ((state.price! / state.weight!) * weight).toStringAsFixed(2));
//     print(price);
//     state = CountItemState(price: price.toInt(), weight: weight);
//   }

//   plusCountItem() async {
//     num weight = double.parse((state.weight! + kilos).toStringAsFixed(2));
//     num price = double.parse(
//         ((state.price! / state.weight!) * weight).toStringAsFixed(2));
//     state = CountItemState(price: price.toInt(), weight: weight);
//     print(weight.toString());
//     print('harga  = ${price.toString()}');
//     print('hitung plus count item ${state.price}');
//   }

//   minusCountItem() async {
//     num weight = double.parse((state.weight! - kilos).toStringAsFixed(2));
//     num price = double.parse(
//         ((state.price! / state.weight!) * weight).toStringAsFixed(2));
//     if (weight <= 0) {
//       weight = 0.0;
//     } else {
//       state = CountItemState(price: price.toInt(), weight: weight);
//     }

//     print(weight.toString());
//     print('harga  = ${price.toString()}');
//     print('hitung minus count item ${state.price}');
//   }

//   countByKiloPercen(index) async {
//     print(index);
//     if (index == 0) {
//       state = CountItemState(price: state.price, weight: 1, selectIndex: 0);
//       print(state.weight);
//     } else if (index == 1) {
//       state = CountItemState(
//           price: state.price, weight: state.weight! * 0.5, selectIndex: 1);
//       print(state.weight);
//     } else if (index == 2) {
//       state = CountItemState(
//           price: state.price, weight: state.weight, selectIndex: 2);
//     } else if (index == 3) {
//       state = CountItemState(
//           price: state.price, weight: state.weight, selectIndex: 3);
//     }
//   }
// }

// class CountItemState {
//   num? weight;
//   num? price;
//   int? selectIndex;

//   CountItemState({
//     this.weight,
//     this.price,
//     this.selectIndex,
//   });
// }
