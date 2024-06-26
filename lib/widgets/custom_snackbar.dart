import 'package:flutter/material.dart';

class CustomSnackbar {
  static void show(BuildContext context,
      {required String message, required Color colors}) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 3),
      backgroundColor: colors,
      behavior: SnackBarBehavior.floating,
      width: MediaQuery.of(context).size.width / 1.1,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
