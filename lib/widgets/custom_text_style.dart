// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:green_cart_scanner/constant/appColor.dart';

class CustomTextStyle extends StatelessWidget {
  final String text;
  final double fontsize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  const CustomTextStyle({
    super.key,
    this.fontsize = 15,
    this.fontWeight = FontWeight.w500,
    required this.text,
    this.textAlign,
    this.color = AppColor.grey1,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      textAlign: textAlign,
      text,
      style: GoogleFonts.inter(
        fontSize: fontsize,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }
}
