import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_cart_scanner/constant/gemini_key.dart';
import 'package:green_cart_scanner/constant/route.dart';
import 'package:green_cart_scanner/custom_page.dart';
import 'package:green_cart_scanner/pages/camera/screen/camera_page.dart';
import 'package:green_cart_scanner/pages/cart/screen/cart_page.dart';
import 'package:green_cart_scanner/pages/dashboard/screen/dashboard_page.dart';
import 'package:green_cart_scanner/pages/login/screen/login_page.dart';
import 'package:green_cart_scanner/pages/navigator/screen/navigator_page.dart';
import 'package:green_cart_scanner/pages/other/other_page.dart';
import 'package:green_cart_scanner/pages/posts/screen/create_post_page.dart';
import 'package:green_cart_scanner/pages/register/screen/register_page.dart';
import 'package:green_cart_scanner/pages/splash/splash.dart';

void main() {
  Gemini.init(apiKey: GeminiKey.apiKey);
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          buttonTheme: const ButtonThemeData(
              colorScheme: ColorScheme.light(
            background: Colors.white,
          )),
          appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white, scrolledUnderElevation: 0),
          colorScheme: const ColorScheme.light(
            background: Colors.white,
          )),
      // home: const CustomPage(),
      debugShowCheckedModeBanner: false,
      initialRoute: NameRoute.splash,
      routes: {
        NameRoute.splash: (context) => const SplashPage(),
        NameRoute.login: (context) => const LoginPage(),
        NameRoute.register: (context) => const RegisterPage(),
        NameRoute.dashboard: (context) => const DashboardPage(),
        NameRoute.navigator: (context) => const NavigatorPage(),
        NameRoute.post: (context) => const PostPage(),
        NameRoute.other: (context) => const OtherPage(),
        NameRoute.camera: (context) => const CameraPage(),
        NameRoute.cart: (context) => const CartPage(),
      },
    );
  }
}
