import 'package:flutter/material.dart';

class ButtonCountKilos extends StatelessWidget {
  final Color? backgroundColor;
  final void Function()? onPressed;
  final String label;
  const ButtonCountKilos(
      {super.key, this.onPressed, required this.label, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width / 3.5,
        height: 50,
        child: ElevatedButton(
          onPressed: onPressed,
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 19.0,
            ),
          ),
          style: ElevatedButton.styleFrom(
              backgroundColor: backgroundColor,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)))),
        ));
  }
}
