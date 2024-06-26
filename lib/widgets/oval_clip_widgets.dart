import 'package:flutter/material.dart';
import 'package:green_cart_scanner/constant/appColor.dart';

class OvalClipWidgets extends StatelessWidget {
  final double? top;
  final double? left;
  final double? width;
  final double? height;
  const OvalClipWidgets({
    super.key,
    this.top = -100,
    this.left = -190,
    this.width = 700,
    this.height = 480,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      child: Container(
        width: width,
        height: height,
        decoration: const BoxDecoration(
            color: AppColor.primary,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(1000))),
      ),
    );
  }
}
