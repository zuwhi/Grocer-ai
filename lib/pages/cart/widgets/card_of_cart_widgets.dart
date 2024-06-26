import 'package:flutter/material.dart';
import 'package:green_cart_scanner/constant/appColor.dart';
import 'package:green_cart_scanner/constant/icon_items.dart';
import 'package:green_cart_scanner/model/items/item.dart';
import 'package:green_cart_scanner/widgets/custom_text_style.dart';

class CardOfCartWidgets extends StatelessWidget {
  final void Function()? onPressed;
  final Item item;
  const CardOfCartWidgets(
      {super.key, required this.item, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(
            top: 8,
            left: 8,
            right: 8,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: AppColor.primary.withOpacity(0.2)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    margin: const EdgeInsets.only(right: 5),
                    child: IconItems.nameItem(item.nama_item.toString()),
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextStyle(
                          text: item.nama_item ?? '-',
                          fontsize: 19,
                          color: AppColor.grey1,
                        ),
                        CustomTextStyle(
                          text: "${item.berat} Kg",
                          fontsize: 13,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const SizedBox(
                    height: 18.0,
                  ),
                  CustomTextStyle(
                    text: "Rp. ${item.harga}",
                    fontsize: 18,
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
            right: 0,
            top: 0,
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      // border: Border.all(width: 0.2),
                      color: AppColor.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: IconButton(
                          onPressed: onPressed,
                          icon: const Icon(
                            Icons.edit,
                            size: 20,
                            color: Colors.white,
                          )),
                    ),
                  )
                ],
              ),
            ))
      ],
    );
  }
}
