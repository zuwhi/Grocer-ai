import 'package:flutter/material.dart';
import 'package:green_cart_scanner/widgets/buttonfull_widget.dart';
import 'package:green_cart_scanner/widgets/custom_text_style.dart';
import 'package:green_cart_scanner/widgets/custom_textformfield_grey_widgets.dart';

class CustomBottomSheetWidget extends StatelessWidget {
  final dynamic Function()? onPressed;
  final TextEditingController nameItemC;
  final TextEditingController hargaItemC;
  final TextEditingController beratItemC;
  const CustomBottomSheetWidget({
    super.key,
    this.onPressed,
    required this.nameItemC,
    required this.hargaItemC,
    required this.beratItemC,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SizedBox(
        width: double.infinity,
        height: 520,
        child: Column(
          children: [
            const SizedBox(
              height: 8.0,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                width: 150,
                height: 7,
                decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(
              height: 29.0,
            ),
            const CustomTextStyle(
              text: "Tambahkan Items",
              fontsize: 20,
            ),
            const SizedBox(
              height: 30.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomTextFormFieldGrey(
                controller: nameItemC,
                name: "Nama items :",
                hintText: "Masukkan nama items",
                prefixIcon: Icons.data_thresholding,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomTextFormFieldGrey(
                inputType: TextInputType.number,
                controller: hargaItemC,
                name: "Harga items :",
                hintText: "Masukkan harga items",
                prefixIcon: Icons.price_change_rounded,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomTextFormFieldGrey(
                inputType: TextInputType.number,
                controller: beratItemC,
                name: "berat items :",
                hintText: "Masukkan berat items",
                prefixIcon: Icons.numbers,
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: ButtonFullWidth(
                          title: "Tambah", onPressed: onPressed)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
