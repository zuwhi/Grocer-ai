import 'package:flutter/material.dart';

class NotConnectInternetPage extends StatelessWidget {
  const NotConnectInternetPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Internet anda mati'),
            SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
    );
  }
}
