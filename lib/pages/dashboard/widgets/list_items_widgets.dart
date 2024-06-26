import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:green_cart_scanner/pages/camera/screen/camera_page.dart';
import 'package:green_cart_scanner/pages/chatbot/screen/chatbot_gemini_page.dart';
import 'package:green_cart_scanner/pages/chatbot/screen/chatbot_neko_page.dart';
import 'package:green_cart_scanner/pages/history/screen/history_page.dart';
import 'package:green_cart_scanner/pages/item/screen/harga_offline.dart';
import 'package:green_cart_scanner/pages/item/screen/harga_online.dart';
import 'package:green_cart_scanner/pages/posts/screen/create_post_page.dart';
import 'package:green_cart_scanner/pages/profil/screen/profil_page.dart';

class ListItems extends StatelessWidget {
  const ListItems({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Text(
              'List Features',
              style: GoogleFonts.roboto(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
                fontSize: 17.0,
              ),
            ),
          ),
          const SizedBox(
            height: 15.0,
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CardMenu(
                ikon: Icons.camera,
                title: 'Scan Items',
                page: CameraPage(),
                color: Colors.blueAccent,
              ),
              CardMenu(
                ikon: Icons.gesture_rounded,
                title: 'Chat AI',
                page: ChatBotGeminiPage(),
                color: Colors.greenAccent,
              ),
              CardMenu(
                ikon: Icons.catching_pokemon_outlined,
                title: 'Neko AI',
                page: ChatBotCSNekoPage(),
                color: Colors.redAccent,
              ),
              CardMenu(
                ikon: Icons.article_rounded,
                title: 'Article',
                page: PostPage(),
                color: Colors.orangeAccent,
              ),
            ],
          ),
          const SizedBox(
            height: 10.0,
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CardMenu(
                ikon: Icons.history,
                title: 'History',
                page: HistoryPage(),
                color: Colors.redAccent,
              ),
              CardMenu(
                ikon: Icons.price_check,
                title: 'Harga Current',
                page: HargaOnlineItemsPage(),
                color: Colors.orangeAccent,
              ),
              CardMenu(
                  ikon: Icons.price_change_outlined,
                  title: 'custom harga',
                  color: Colors.greenAccent,
                  page: HargaOfflineItemsPage()),
              CardMenu(
                ikon: Icons.person,
                title: 'profil',
                page: ProfilPage(),
                color: Colors.blueAccent,
              ),
            ],
          )
        ],
      ),
    );
  }
}

class CardMenu extends StatelessWidget {
  const CardMenu({
    super.key,
    required this.title,
    required this.ikon,
    required this.page,
    this.color = Colors.white,
  });

  final String title;
  final IconData ikon;
  final Widget page;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => page));
          },
          child: Container(
              margin: const EdgeInsets.only(bottom: 7),
              decoration: BoxDecoration(
                color: color,
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(0, 0, 0, 0).withOpacity(0.1),
                    offset: const Offset(1, 1),
                    blurRadius: 5,
                    spreadRadius: 0,
                  )
                ],
                borderRadius: BorderRadius.circular(15),
              ),
              width: 55,
              height: 55,
              padding: const EdgeInsets.all(5),
              clipBehavior: Clip.antiAlias,
              child: Icon(
                ikon,
                size: 35,
                color: Colors.white,
              )),
        ),
        SizedBox(
          width: 50,
          child: Text(
            textAlign: TextAlign.center,
            title,
            style: GoogleFonts.roboto(
              height: 1.2,
              color: Colors.black87,
              fontWeight: FontWeight.w400,
              fontSize: 12.0,
            ),
          ),
        ),
      ],
    );
  }
}
