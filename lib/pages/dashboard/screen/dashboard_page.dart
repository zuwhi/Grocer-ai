import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:green_cart_scanner/constant/appColor.dart';
import 'package:green_cart_scanner/constant/loading_app.dart';
import 'package:green_cart_scanner/model/post/posts.dart';
import 'package:green_cart_scanner/model/statusState/StatusCondition.dart';
import 'package:green_cart_scanner/pages/dashboard/widgets/carousel_widgets.dart';
import 'package:green_cart_scanner/pages/dashboard/widgets/list_items_widgets.dart';
import 'package:green_cart_scanner/pages/item/provider/items_online/items_appwrite.dart';
import 'package:green_cart_scanner/pages/login/screen/login_page.dart';
import 'package:green_cart_scanner/pages/navigator/provider/session_provider.dart';
import 'package:green_cart_scanner/pages/posts/provider/recent_post/recent_post_provider.dart';
import 'package:green_cart_scanner/pages/posts/widgets/card_post_widgets.dart';
import 'package:green_cart_scanner/pages/profil/screen/profil_page.dart';
import 'package:green_cart_scanner/widgets/buttonfull_widget.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  @override
  void initState() {
    print("sudah di dashboard");
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ItemsAppwriteState itemsState = ref.watch(itemsAppwriteProvider);
      if (itemsState.status == StatusCondition.success) {
        null;
      } else {
        ref.read(itemsAppwriteProvider.notifier).getAllItems();
      }
      RecentPostsState recentPostsState =
          ref.watch(recentPostsNotifierProvider);
      if (recentPostsState.status == StatusCondition.success) {
        null;
      } else {
        ref.watch(recentPostsNotifierProvider.notifier).getRecentPosts();
      }
    });
    super.initState();
  }

  Future<void> _handleRefresh() async {
    await ref.watch(recentPostsNotifierProvider.notifier).getRecentPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(
        builder: (context, wiRef, child) {
          SessionState sessionState = wiRef.watch(sessionNotifierProvider);
          if (sessionState.status == StatusCondition.success) {
            return RefreshIndicator(
              onRefresh: () => _handleRefresh(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 277,
                      child: Stack(
                        children: [
                          // Stack(
                          //   children: [
                          //     Opacity(
                          //       //semi red clippath with more height and with 0.5 opacity
                          //       opacity: 0.5,
                          //       child: ClipPath(
                          //         clipper:
                          //             WaveClipper(), //set our custom wave clipper
                          //         child: Container(
                          //           color: AppColor.primary.withOpacity(0.4),
                          //           height: 180,
                          //         ),
                          //       ),
                          //     ),
                          //     ClipPath(
                          //       //upper clippath with less height
                          //       clipper:
                          //           WaveClipper(), //set our custom wave clipper.
                          //       child: Container(
                          //         padding: const EdgeInsets.only(bottom: 20),
                          //         color: AppColor.primary,
                          //         height: 160,
                          //         alignment: Alignment.center,
                          //         child: Container(),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          Column(
                            children: [
                              const SizedBox(
                                height: 45.0,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 16,
                                          child: Text(
                                            'Selamat Datang',
                                            style: GoogleFonts.roboto(
                                              color: AppColor.grey1,
                                              fontSize: 13.0,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          sessionState.account?.name ?? '',
                                          style: GoogleFonts.roboto(
                                            color: AppColor.grey1,
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        )
                                      ],
                                    ),
                                    InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const ProfilPage(),
                                              ));
                                        },
                                        child: Container(
                                            clipBehavior: Clip.antiAlias,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                            ),
                                            child: SizedBox(
                                                height: 45,
                                                child: CachedNetworkImage(
                                                  imageUrl: sessionState
                                                          .account?.image ??
                                                      '',
                                                  fit: BoxFit.cover,
                                                  placeholder: (context, url) =>
                                                      const LoadingWidgets(),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      Image.asset(
                                                          'assets/images/profil.jpg'),
                                                ))))
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 15.0,
                              ),
                              const CarouselWidgets(),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14.0),
                      child: ListItems(),
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Recent Post',
                            style: GoogleFonts.roboto(
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                              fontSize: 17.0,
                            ),
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          Consumer(
                            builder: (context, ref, child) {
                              RecentPostsState postState =
                                  ref.watch(recentPostsNotifierProvider);
                              if (postState.status == StatusCondition.loading) {
                                return const Padding(
                                  padding: EdgeInsets.only(top: 25.0),
                                  child: LoadingWidgets(),
                                );
                              }

                              if (postState.status == StatusCondition.success) {
                                List<Posts> posts = postState.data;
                                return ListView.builder(
                                  padding: const EdgeInsets.all(0),
                                  itemCount: posts.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    Posts post = posts[index];
                                    List<String> category =
                                        post.category!.split(',');
                                    return CardPost(
                                        post: post, category: category);
                                  },
                                );
                              }

                              if (postState.status == StatusCondition.failed) {
                                return Center(
                                  child: Text(
                                      "gagal mendapatkan data = ${postState.message}"),
                                );
                              }

                              return Container();
                            },
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 40.0,
                    ),
                  ],
                ),
              ),
            );
          }

          if (sessionState.status == StatusCondition.loading) {
            return const LoadingWidgets();
          }
          if (sessionState.isLogin == false) {
            return Container(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('anda belum login'),
                    const Text('silahkan login terlebih dahulu'),
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
                                builder: (context) => const LoginPage(),
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
          return Container();
        },
      ),
    );
  }
}
