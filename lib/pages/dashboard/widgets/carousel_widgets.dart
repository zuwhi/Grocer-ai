// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:green_cart_scanner/constant/appColor.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CarouselWidgets extends StatefulWidget {
  const CarouselWidgets({super.key});

  @override
  State<CarouselWidgets> createState() => _CarouselWidgetsState();
}

class _CarouselWidgetsState extends State<CarouselWidgets> {
  int activeIndex = 0;
  final controller = CarouselController();

  void animateToSlide(int index) => controller.animateToPage(index);
  Widget buildImage(Widget widgets, int index) => listWidgets[index];

  List<Widget> listWidgets = [
    CardCarousel(
      color1: const Color(0xFF82C5F1),
      color2: const Color(0xFF7CA2F3),
      imageChild: Positioned(
        // top: 0,
        bottom: 10,
        right: 10,
        child: SizedBox(
          height: 100,
          child: Image.asset(
            'assets/icons/object.png',
            // fit: BoxFit.cover,
          ),
        ),
      ),
      textChild: Padding(
        padding: const EdgeInsets.only(top: 32.0, left: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pindai Produk',
              style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w600),
            ),
            Text(
              'Dapat info harga seketika',
              style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    ),
    CardCarousel(
        color1: const Color(0xFFCC78F2),
        color2: const Color(0xFF8680F5),
        imageChild: Positioned(
          // top: 0,
          bottom: -15,
          right: -24,
          child: SizedBox(
            height: 152,
            child: Image.asset(
              'assets/icons/icon_robot.png',
              // fit: BoxFit.cover,
            ),
          ),
        ),
        textChild: Padding(
            padding: const EdgeInsets.only(top: 32.0, left: 20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                'Tanya Apa Aja',
                style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontSize: 17.0,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                'Dibantu oleh Chatbot AI',
                style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600),
              ),
            ]))),
    CardCarousel(
      color1: const Color.fromARGB(255, 255, 230, 91),
      color2: const Color.fromARGB(255, 255, 203, 15),
      imageChild: Positioned(
        // top: 0,
        bottom: 0,
        right: 0,
        child: SizedBox(
          height: 100,
          child: Image.asset(
            'assets/icons/abacus.png',
            // fit: BoxFit.cover,
          ),
        ),
      ),
      textChild: Padding(
        padding: const EdgeInsets.only(top: 32.0, left: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hitung Cepat',
              style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 250,
              child: Text(
                'Scan, hitung dan lihat total belanjaan',
                style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    ),
    CardCarousel(
      color1: const Color.fromARGB(255, 20, 255, 177),
      color2: const Color.fromARGB(255, 7, 227, 147),
      imageChild: Positioned(
        // top: 0,
        bottom: 0,
        // right: -18,
        child: SizedBox(
          height: 105,
          child: Image.asset(
            'assets/icons/vegetable.png',
            // fit: BoxFit.cover,
          ),
        ),
      ),
      textChild: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 32.0, left: 80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Lihat Harga',
                style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontSize: 17.0,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                'Secara Real Time',
                style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      CarouselSlider.builder(
          carouselController: controller,
          itemCount: listWidgets.length,
          itemBuilder: (context, index, realIndex) {
            final widgets = listWidgets[index];

            return buildImage(widgets, index);
          },
          options: CarouselOptions(
              height: 145,
              viewportFraction: 0.92,
              autoPlay: true,
              autoPlayAnimationDuration:
                  const Duration(seconds: 4, milliseconds: 200),
              aspectRatio: 2.0,
              enlargeCenterPage: true,
              enableInfiniteScroll: true,
              initialPage: 2,
              onPageChanged: (index, reason) =>
                  setState(() => activeIndex = index))),
      const SizedBox(
        height: 15.0,
      ),
      Container(
        padding: const EdgeInsets.only(left: 280, bottom: 5),
        child: Column(
          children: [
            AnimatedSmoothIndicator(
              onDotClicked: animateToSlide,
              effect: ExpandingDotsEffect(
                  dotWidth: 5.5,
                  dotHeight: 5.5,
                  activeDotColor: AppColor.primary,
                  dotColor: AppColor.primary.withOpacity(0.3),
                  spacing: 10),
              activeIndex: activeIndex,
              count: listWidgets.length,
            )
          ],
        ),
      ),
    ]);
  }
}

class CardCarousel extends StatelessWidget {
  final Color color1;
  final Color color2;
  final Widget imageChild;
  final Widget textChild;
  const CardCarousel({
    super.key,
    required this.color1,
    required this.color2,
    required this.imageChild,
    required this.textChild,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color1, color2],
          stops: const [0, 1],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            offset: const Offset(1, 1),
            blurRadius: 3,
            spreadRadius: 0,
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Positioned(
              right: -90,
              bottom: -75,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color1.withOpacity(1), color2.withOpacity(1)],
                    stops: const [0, 1],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(0, 0, 0, 0).withOpacity(0.10),
                      offset: const Offset(1, 1),
                      blurRadius: 1.2,
                      spreadRadius: 0,
                    )
                  ],
                ),
              ),
            ),
            imageChild,
            textChild
          ],
        ),
      ),
    );
  }
}
