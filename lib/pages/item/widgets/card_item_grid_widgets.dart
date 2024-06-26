import 'package:flutter/material.dart';
import 'package:green_cart_scanner/constant/appColor.dart';
import 'package:green_cart_scanner/constant/icon_items.dart';
import 'package:green_cart_scanner/model/items/item.dart';
import 'package:green_cart_scanner/widgets/custom_text_style.dart';

class CardItemGrid extends StatelessWidget {
  final Item item;
  final void Function()? onTap;
  final Widget? editButton;
  const CardItemGrid(
      {super.key, required this.item, this.onTap, this.editButton});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                // color: IconItems.backgroundItem(
                //         item: item.nama_item!, randomNumber: randomNumber)
                //     .withOpacity(0.9),
                color: Colors.white,
                border: Border.all(color: AppColor.primary, width: 0.5),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0, 0.5),
                    blurRadius: 0.5,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    IconItems.nameItem(item.nama_item ?? '-'),
                    const SizedBox(
                      width: 8.0,
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextStyle(
                          text: item.nama_item ?? '-',
                          fontsize: 15.0,
                          fontWeight: FontWeight.w600,
                          textAlign: TextAlign.center,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CustomTextStyle(
                              text: 'Rp.${item.harga ?? '0'} ',
                              color: const Color.fromARGB(158, 0, 0, 0),
                              fontWeight: FontWeight.w600,
                              fontsize: 14,
                            ),
                            CustomTextStyle(
                              text: '/${item.berat ?? '0'} Kg',
                              color: Colors.black45,
                              fontsize: 13,
                            )
                          ],
                        )
                      ],
                    )
                  ],
                ),
              )),
          Positioned(right: 0, child: editButton ?? Container())
        ],
      ),
    );
  }
}
