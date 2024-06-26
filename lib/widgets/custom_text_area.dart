// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:green_cart_scanner/constant/appColor.dart';

class CustomTextFormArea extends StatelessWidget {
  final TextEditingController controller;
  final String name;
  final IconData prefixIcon;
  final bool obscureText;
  final TextCapitalization textCapitalization;
  final TextInputType inputType;
  final Widget? suffixIcon;
  final Function(String)? onChanged;
  final String? errorText;

  const CustomTextFormArea(
      {super.key,
      required this.controller,
      required this.name,
      required this.prefixIcon,
      this.obscureText = false,
      this.textCapitalization = TextCapitalization.none,
      this.inputType = TextInputType.text,
      this.suffixIcon,
      this.onChanged,
      this.errorText});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        maxLines: null, // Set this
        minLines: 1,
        onChanged: onChanged,
        enabled: true,
        controller: controller,
        textCapitalization: textCapitalization,
        obscureText: obscureText,
        keyboardType: TextInputType.multiline,
        textAlign: TextAlign.start,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          errorText: errorText,
          suffixIcon: Padding(
            padding: const EdgeInsets.all(5.0),
            child: suffixIcon,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Icon(
              prefixIcon,
              color: AppColor.primary,
            ),
          ),
          labelText: name,
          counterText: "",
          labelStyle: const TextStyle(
            color: AppColor.primary,
            fontSize: 15.0,
          ),
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: AppColor.primary, width: 1.5),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
      ),
    );
  }
}
