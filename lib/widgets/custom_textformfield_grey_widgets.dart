// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:green_cart_scanner/constant/appColor.dart';
import 'package:green_cart_scanner/widgets/custom_text_style.dart';

class CustomTextFormFieldGrey extends StatelessWidget {
  final TextEditingController controller;
  final String name;
  final IconData? prefixIcon;
  final bool obscureText;
  final TextCapitalization textCapitalization;
  final TextInputType inputType;
  final Widget? suffixIcon;
  final Function(String)? onChanged;
  final String? errorText;
  final String? hintText;

  const CustomTextFormFieldGrey(
      {super.key,
      required this.controller,
      required this.name,
      this.prefixIcon,
      this.obscureText = false,
      this.textCapitalization = TextCapitalization.none,
      this.inputType = TextInputType.text,
      this.suffixIcon,
      this.onChanged,
      this.errorText,
      this.hintText});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: CustomTextStyle(
              text: name,
              fontsize: 14,
            ),
          ),
          const SizedBox(
            height: 8.0,
          ),
          TextFormField(
            cursorColor: AppColor.primary,
            onChanged: onChanged, // Set this
            minLines: 1,
            enabled: true,
            controller: controller,
            textCapitalization: textCapitalization,
            obscureText: obscureText,
            keyboardType: inputType,
            textAlign: TextAlign.start,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColor.grey6,
              errorText: errorText,
              prefixIcon: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Icon(
                  prefixIcon,
                  color: AppColor.grey4,
                ),
              ),
              suffixIcon: Padding(
                padding: const EdgeInsets.all(5.0),
                child: suffixIcon,
              ),
              hintText: hintText,
              hintStyle: const TextStyle(
                color: AppColor.grey4,
                fontSize: 15.0,
              ),
              labelStyle: const TextStyle(
                color: AppColor.grey4,
                fontSize: 15.0,
              ),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(13.0),
                ),
                borderSide: BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
