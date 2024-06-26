import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_cart_scanner/constant/appColor.dart';
import 'package:green_cart_scanner/constant/loading_app.dart';
import 'package:green_cart_scanner/model/statusState/StatusCondition.dart';
import 'package:green_cart_scanner/pages/cart/screen/option_items_page.dart';
import 'package:green_cart_scanner/pages/chatbot/screen/chatbot_menu_page.dart';
import 'package:green_cart_scanner/pages/dashboard/screen/dashboard_page.dart';
import 'package:green_cart_scanner/pages/item/screen/show_history.dart';
import 'package:green_cart_scanner/pages/navigator/provider/session_provider.dart';
import 'package:green_cart_scanner/pages/navigator/widgets/not_login_widget.dart';
import 'package:green_cart_scanner/pages/other/other_page.dart';
import 'package:green_cart_scanner/pages/posts/screen/all_posts_page.dart';
import 'package:logger/logger.dart';

class NavigatorPage extends ConsumerStatefulWidget {
  final targetPage;
  const NavigatorPage({super.key, this.targetPage});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NavigatorPageState();
}

class _NavigatorPageState extends ConsumerState<NavigatorPage> {
  bool isLogin = false;

  int? target;
  PageController pageController = PageController(initialPage: 0);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    target = widget.targetPage;

    if (widget.targetPage != null) {
      pageController = PageController(initialPage: target ?? 0);
    }

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      SessionState sessionState = ref.watch(sessionNotifierProvider);
      if (sessionState.isLogin == false) {
        ref.watch(sessionNotifierProvider.notifier).createSessionState();
      }
    });
  }

  late int _selectedIndex = target ?? 0;

  @override
  Widget build(BuildContext context) {
    SessionState session = ref.watch(sessionNotifierProvider);
    Logger().d('cek is login di navigator page${session.isLogin}');
    if (session.isLogin == true) {
      setState(() {
        isLogin = true;
      });
    }

    if (session.status == StatusCondition.loading) {
      return const Scaffold(
        body: LoadingWidgets(),
      );
    } else {
      return Scaffold(
        extendBody: true,
        body: PageView(
          controller: pageController,
          children: <Widget>[
            Center(
              child:
                  isLogin ? const DashboardPage() : const NotLoginWidgetPage(),
            ),
            Center(
              child: isLogin
                  ? const ShowHistoryPage()
                  : const NotLoginWidgetPage(),
            ),
            Center(
              child: isLogin ? const ChatBotMenu() : const NotLoginWidgetPage(),
            ),
            Center(
              child:
                  isLogin ? const AllPostsPage() : const NotLoginWidgetPage(),
            ),
            const Center(
              child: OtherPage(),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColor.primary,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const OptionItemsPage(),
                ));
          },
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(50))),
          child: const Icon(
            Icons.camera_alt,
            color: Colors.white,
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          shadowColor: Colors.black,
          elevation: 100,
          height: 65,
          shape: const CircularNotchedRectangle(),
          notchMargin: 8.0,
          clipBehavior: Clip.antiAlias,
          padding: const EdgeInsets.all(0),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            currentIndex: _selectedIndex,
            selectedItemColor: AppColor.primary,
            unselectedItemColor: Colors.black38,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
                pageController.jumpToPage(index);
              });
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart_rounded),
                label: 'Harga',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.alternate_email),
                label: 'Artikel',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Other',
              ),
            ],
          ),
        ),
      );
    }
  }
}
