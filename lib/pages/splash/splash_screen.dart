// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:green_cart_scanner/constant/appColor.dart';
import 'package:lottie/lottie.dart';

class SplashScreenPage extends StatelessWidget {
  const SplashScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primary,
      // backgroundColor: Color(0xFF135D66),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Gro",
                  style: GoogleFonts.poppins(
                    fontSize: 35.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "cer",
                  style: GoogleFonts.poppins(
                    fontSize: 35.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.greenAccent,
                  ),
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Text(
                  "AI",
                  style: GoogleFonts.poppins(
                    fontSize: 35.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Container(
                child: Lottie.asset(
              'assets/icons/logo1.json',
              width: double.infinity,
              fit: BoxFit.fill,
            )),
          ],
        ),
      ),
    );
  }
}
