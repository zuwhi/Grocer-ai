import 'package:flutter/material.dart';
import 'package:green_cart_scanner/constant/icon_items.dart';
import 'package:green_cart_scanner/model/items/item.dart';
import 'package:green_cart_scanner/widgets/custom_text_style.dart';

class CardDetection extends StatelessWidget {
  final Item item;
  final String akurasi;
  const CardDetection({super.key, required this.item, required this.akurasi});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      decoration: const BoxDecoration(
          color: Colors.black26,
          borderRadius: BorderRadius.all(Radius.circular(25))),
      child: Column(
        children: [
          IconItems.nameItem(item.nama_item ?? '', size: 90),
          const SizedBox(
            height: 15.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CustomTextStyle(
                text: "Nama Item : ",
                fontsize: 17,
                color: Colors.white,
              ),
              CustomTextStyle(
                text: item.nama_item ?? '-',
                fontsize: 19,
                color: Colors.white,
              )
            ],
          ),
          const SizedBox(
            height: 5.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CustomTextStyle(
                text: "Harga         : ",
                fontsize: 17,
                color: Colors.white,
              ),
              CustomTextStyle(
                text: "Rp. ${item.harga}",
                fontsize: 19,
                color: Colors.white,
              )
            ],
          ),
          const SizedBox(
            height: 25.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CustomTextStyle(
                text: "Akurasi Terdeksi : ",
                fontsize: 17,
                color: Colors.white,
              ),
              CustomTextStyle(
                text: "$akurasi %",
                fontsize: 19,
                color: Colors.white,
              )
            ],
          ),
          const SizedBox(
            height: 12.0,
          ),
        ],
      ),
    );
  }
}
