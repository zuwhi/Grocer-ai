import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:green_cart_scanner/constant/appColor.dart';

class LoadingWidgets extends StatelessWidget {
  const LoadingWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitWaveSpinner(
        color: AppColor.primary.withOpacity(0.8),
        size: 80.0,
        waveColor: AppColor.grey6,
        trackColor: AppColor.grey6,
        curve: Curves.linear,
      ),
    );
  }
}
