import 'package:flutter/material.dart';
import 'package:green_cart_scanner/widgets/custom_text_style.dart';
import 'package:lottie/lottie.dart';

class NotFoundWidgets extends StatelessWidget {
  final double? height;
  const NotFoundWidgets({super.key, this.height = 100});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: height!),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              width: MediaQuery.of(context).size.width / 2 + 50,
              child: Lottie.asset(
                'assets/animation/empty.json',
                width: double.infinity,
                fit: BoxFit.fill,
              )),
          const SizedBox(
            height: 20.0,
          ),
          const CustomTextStyle(
            text: "Tidak Ditemukan Data :(",
            color: Colors.grey,
            fontsize: 18,
          )
        ],
      ),
    );
  }
}
