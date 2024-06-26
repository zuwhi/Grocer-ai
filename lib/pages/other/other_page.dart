import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:green_cart_scanner/constant/appColor.dart';
import 'package:green_cart_scanner/constant/loading_app.dart';
import 'package:green_cart_scanner/pages/history/screen/history_page.dart';
import 'package:green_cart_scanner/pages/item/screen/add_data_items.dart';
import 'package:green_cart_scanner/pages/item/screen/harga_offline.dart';
import 'package:green_cart_scanner/pages/item/screen/harga_online.dart';
import 'package:green_cart_scanner/pages/item/screen/show_history.dart';
import 'package:green_cart_scanner/pages/navigator/provider/session_provider.dart';
import 'package:green_cart_scanner/pages/posts/screen/own_post_user.dart';
import 'package:green_cart_scanner/pages/profil/screen/profil_page.dart';

class OtherPage extends ConsumerStatefulWidget {
  const OtherPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OtherPageState();
}

class _OtherPageState extends ConsumerState<OtherPage> {
  @override
  Widget build(BuildContext context) {
    SessionState sessionState = ref.watch(sessionNotifierProvider);
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Opacity(
                    //semi red clippath with more height and with 0.5 opacity
                    opacity: 0.5,
                    child: ClipPath(
                      clipper: WaveClipper(), //set our custom wave clipper
                      child: Container(
                        color: AppColor.primary.withOpacity(0.4),
                        height: 230,
                      ),
                    ),
                  ),
                  ClipPath(
                    //upper clippath with less height
                    clipper: WaveClipper(), //set our custom wave clipper.
                    child: Container(
                      padding: const EdgeInsets.only(bottom: 20),
                      color: AppColor.primary,
                      height: 210,
                      alignment: Alignment.center,
                      child: (sessionState.isLogin)
                          ? InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const ProfilPage(),
                                    ));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Container(
                                              height: 80,
                                              width: 80,
                                              decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  shape: BoxShape.circle),
                                            ),
                                            Container(
                                                clipBehavior: Clip.antiAlias,
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                ),
                                                child: SizedBox(
                                                    height: 72,
                                                    child: CachedNetworkImage(
                                                      imageUrl: sessionState
                                                              .account?.image ??
                                                          '',
                                                      fit: BoxFit.cover,
                                                      placeholder: (context,
                                                              url) =>
                                                          const LoadingWidgets(),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Image.asset(
                                                              'assets/images/profil.jpg'),
                                                    ))),
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 20.0,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              sessionState.account?.name ?? '',
                                              style: GoogleFonts.inter(
                                                  color: Colors.white,
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                              sessionState.account?.email ?? '',
                                              style: GoogleFonts.inter(
                                                  color: Colors.white54,
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    // const Icon(
                                    //   Icons.edit,
                                    //   color: AppColor.primary,
                                    //   size: 20,
                                    // )
                                  ],
                                ),
                              ),
                            )
                          : Container(),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Column(
                          children: [
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 15.0,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(
                                        left: 5, bottom: 10),
                                    child: const Text(
                                      'User :',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ),
                                  (sessionState.isLogin)
                                      ? const CardButtonData(
                                          icon: Icons.art_track_rounded,
                                          page: OwnPostUserPage(),
                                          title: "Artikel anda",
                                        )
                                      : Container(),
                                  const CardButtonData(
                                    icon: Icons.price_check_outlined,
                                    page: HargaOnlineItemsPage(),
                                    title: "Harga Pasar ter-update",
                                  ),
                                  const CardButtonData(
                                    icon: Icons.price_change,
                                    page: HargaOfflineItemsPage(),
                                    title: "Ubah Harga Pasar",
                                  ),
                                  const CardButtonData(
                                    icon: Icons.history,
                                    page: HistoryPage(),
                                    title: "Riwayat Nota ",
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      (sessionState.account?.role!.toLowerCase() == 'admin')
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: const Text(
                                    'Admin :',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 8.0,
                                ),
                                const CardButtonData(
                                  icon: Icons.add_business_outlined,
                                  page: AddDataItemsPage(),
                                  title: "Tambah Harga Sembako/Sayur",
                                ),
                                const CardButtonData(
                                  icon: Icons.list_alt,
                                  page: ShowHistoryPage(
                                    isAdmin: true,
                                  ),
                                  title: "Edit Riwayat harga",
                                ),
                              ],
                            )
                          : Container()
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(
        0, size.height); //start path with this if you are making at bottom

    var firstStart = Offset(size.width / 5, size.height);
    //fist point of quadratic bezier curve
    var firstEnd = Offset(size.width / 2.25, size.height - 50.0);
    //second point of quadratic bezier curve
    path.quadraticBezierTo(
        firstStart.dx, firstStart.dy, firstEnd.dx, firstEnd.dy);

    var secondStart =
        Offset(size.width - (size.width / 3.24), size.height - 105);
    //third point of quadratic bezier curve
    var secondEnd = Offset(size.width, size.height - 10);
    //fourth point of quadratic bezier curve
    path.quadraticBezierTo(
        secondStart.dx, secondStart.dy, secondEnd.dx, secondEnd.dy);

    path.lineTo(
        size.width, 0); //end with this path if you are making wave at bottom
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false; //if new instance have different instance than old instance
    //then you must return true;
  }
}

class CardButtonData extends StatelessWidget {
  final Widget page;
  final String title;
  final IconData? icon;
  const CardButtonData(
      {super.key,
      required this.page,
      required this.title,
      this.icon = Icons.featured_play_list});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => page,
            ));
      },
      child: Container(
        color: Colors.white,
        margin: const EdgeInsets.only(bottom: 7),
        height: 60,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border:
                            Border.all(color: AppColor.primary, width: 0.5)),
                    child: Icon(
                      icon,
                      color: AppColor.primary,
                      size: 26,
                    ),
                  ),
                  const SizedBox(
                    width: 18.0,
                  ),
                  Text(
                    title,
                    style: GoogleFonts.inter(
                        color: Colors.black87,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: AppColor.primary,
                size: 18,
              )
            ],
          ),
        ),
      ),
    );
  }
}
