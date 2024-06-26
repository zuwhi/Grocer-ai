import 'package:flutter/material.dart';
import 'package:green_cart_scanner/constant/appColor.dart';
import 'package:green_cart_scanner/constant/icon_items.dart';
import 'package:green_cart_scanner/model/items/item.dart';

class CardItemListTile extends StatelessWidget {
  final Item item;
  final void Function()? onTap;
  final Widget? trailing;
  final Widget? subtitle;

  const CardItemListTile(
      {super.key,
      required this.item,
      this.onTap,
      this.trailing,
      this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
            side: const BorderSide(
              width: 0.7,
              color: AppColor.primary,
            ),
            borderRadius: BorderRadius.circular(15.0)),
        child: ListTile(
            onTap: onTap,
            leading: IconItems.nameItem(item.nama_item ?? '-'),
            title: Text(item.nama_item ?? '-'),
            subtitle: subtitle,
            trailing: trailing));
  }
}
