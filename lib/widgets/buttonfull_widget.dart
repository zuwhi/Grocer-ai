// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:green_cart_scanner/constant/appColor.dart';

class ButtonFullWidth extends StatelessWidget {
  final Function()? onPressed;
  final String? title;
  final EdgeInsetsGeometry? paddingCustom;
  final Color? warna;
  final double width;
  final double fs;
  final double height;
  final Color? textColor;
  final bool isload;
  final bool isDisable;
  final double? radius;
  const ButtonFullWidth(
      {super.key,
      this.onPressed,
      this.title,
      this.paddingCustom,
      this.warna = AppColor.primary,
      this.width = double.infinity,
      this.fs = 16,
      this.height = 40,
      this.textColor = Colors.white,
      this.isload = false,
      this.isDisable = false,
      this.radius = 6});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: paddingCustom,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            surfaceTintColor: Colors.transparent,
            backgroundColor:
                isDisable || isload ? warna?.withOpacity(0.4) : warna,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(radius!)))),
        onPressed: isDisable ? () {} : onPressed,
        child: isload
            ? const Padding(
                padding: EdgeInsets.all(5.0),
                child: SpinKitWaveSpinner(
                  color: Colors.white,
                  size: 50.0,
                ),
              )
            : Text(
                title ?? "Save",
                style: GoogleFonts.inter(
                    fontSize: fs,
                    color: isDisable ? textColor?.withOpacity(0.5) : textColor,
                    fontWeight: FontWeight.w500),
              ),
      ),
    );
  }
}
