import 'package:flutter/material.dart';
import 'package:green_cart_scanner/pages/login/screen/login_page.dart';
import 'package:green_cart_scanner/widgets/buttonfull_widget.dart';

class NotLoginWidgetPage extends StatelessWidget {
  const NotLoginWidgetPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('anda belum login'),
            Text('silahkan login terlebih dahulu'),
            const SizedBox(
              height: 20.0,
            ),
            SizedBox(
              width: 200,
              child: ButtonFullWidth(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ),
                      (route) => false);
                },
                title: 'Login',
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
          ],
        ),
      ),
    );
  }
}
