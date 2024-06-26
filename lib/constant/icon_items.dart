import 'package:flutter/material.dart';

class IconItems {
  IconItems(String? item);

  static Widget nameItem(String item, {double? size = 50}) {
    switch (item.toLowerCase()) {
      case 'tomat':
        return SizedBox(
            height: size,
            width: size,
            child: Image.asset('assets/icons/tomat.png'));
      case 'kol':
        return SizedBox(
            height: size,
            width: size,
            child: Image.asset('assets/icons/kol.png'));
      case 'cabai merah':
        return SizedBox(
            height: size,
            width: size,
            child: Image.asset('assets/icons/cm.png'));
      case 'cabai hijau':
        return SizedBox(
            height: size,
            width: size,
            child: Image.asset('assets/icons/cabai_hijau.png'));
      case 'rawit' || 'cabai rawit':
        return SizedBox(
            height: size,
            width: size,
            child: Image.asset('assets/icons/cr.png'));
      case 'bawang merah':
        return SizedBox(
            height: size,
            width: size,
            child: Image.asset('assets/icons/bm.png'));
      case 'bawang putih':
        return SizedBox(
            height: size,
            width: size,
            child: Image.asset('assets/icons/bp.png'));
      case 'wortel':
        return SizedBox(
            height: size,
            width: size,
            child: Image.asset('assets/icons/wortel.png'));
      case 'sawi hijau' || 'sawi':
        return SizedBox(
            height: size,
            width: size,
            child: Image.asset('assets/icons/sawi.png'));
      case 'brokoli':
        return SizedBox(
            height: size,
            width: size,
            child: Image.asset('assets/icons/brocolli-icon.png'));
      case 'beras':
        return SizedBox(
            height: size,
            width: size,
            child: Image.asset('assets/icons/rice-icon.png'));
      case 'bayam':
        return SizedBox(
            height: size,
            width: size,
            child: Image.asset('assets/icons/spinach-icon.png'));
      case 'daun bawang':
        return SizedBox(
            height: size,
            width: size,
            child: Image.asset('assets/icons/spring-onion.png'));
      case 'kangkung':
        return SizedBox(
            height: size,
            width: size,
            child: Image.asset('assets/icons/kangkung.png'));
      case 'minyak goreng':
        return SizedBox(
            height: size,
            width: size,
            child: Image.asset('assets/icons/minyak.png'));
      case 'kentang':
        return SizedBox(
            height: size,
            width: size,
            child: Image.asset('assets/icons/kentang.png'));
      case 'kembang kol':
        return SizedBox(
            height: size,
            width: size,
            child: Image.asset('assets/icons/kembangkol.png'));
      case 'gula':
        return SizedBox(
            height: size,
            width: size,
            child: Image.asset('assets/icons/gula.png'));
      case 'gula merah':
        return SizedBox(
            height: size,
            width: size,
            child: Image.asset('assets/icons/gula_merah.png'));
      case 'kecap':
        return SizedBox(
            height: size,
            width: size,
            child: Image.asset('assets/icons/kecap.png'));
      case 'seledri':
        return SizedBox(
            height: size,
            width: size,
            child: Image.asset('assets/icons/seledri.png'));
      case 'telur':
        return SizedBox(
            height: size,
            width: size,
            child: Image.asset('assets/icons/telur.png'));
      case 'timun':
        return SizedBox(
            height: size,
            width: size,
            child: Image.asset('assets/icons/timun.png'));
      default:
        return SizedBox(
            height: size,
            width: size,
            child: Image.asset('assets/icons/harvest.png'));
    }
  }

  static Color backgroundItem(
      {required String item, required int randomNumber}) {
    final List<Color> basicColors = [
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.yellow,
      Colors.orange,
      Colors.purple,
      Colors.pink,
      Colors.teal,
      Colors.cyan,
      Colors.brown,
    ];

    switch (item.toLowerCase()) {
      case 'tomat':
        return Colors.red;
      case 'kol':
        return Colors.green;
      case 'cabai merah':
        return Colors.red;
      case 'rawit' || 'cabai rawit':
        return Colors.pink;
      case 'bawang merah':
        return Colors.purple;
      case 'bawang putih':
        return Colors.yellow;
      case 'wortel':
        return Colors.orange;
      case 'sawi hijau' || 'sawi':
        return Colors.cyan;
      case 'brokoli':
        return Colors.green;
      case 'beras':
        return Colors.grey;
      case 'bayam':
        return Colors.green;
      case 'daun bawang':
        return Colors.green;
      default:
        return basicColors[randomNumber];
    }
  }
}
