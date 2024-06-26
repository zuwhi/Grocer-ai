import 'dart:async';

import 'package:flutter/material.dart';
import 'package:green_cart_scanner/constant/route.dart';
import 'package:green_cart_scanner/service/local/local_session.dart';
import 'package:green_cart_scanner/pages/splash/splash_screen.dart';
import 'package:logger/logger.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  String? finalSession;

  Future getSession() async {
    String? getSession = await SessionLocal.getSession();
    setState(() {
      finalSession = getSession;
    });
    Logger().d('cek sesi di main $finalSession');
  }

  @override
  void initState() {
    getSession().whenComplete(() async {
      Timer(const Duration(seconds: 4, milliseconds: 100), () {
        if (finalSession == null) {
          Navigator.pushNamedAndRemoveUntil(
              context, NameRoute.login, (route) => false);
        } else {
          Navigator.pushNamedAndRemoveUntil(
              context, NameRoute.navigator, (route) => false);
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: SplashScreenPage());
  }
}
