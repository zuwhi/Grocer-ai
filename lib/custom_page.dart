// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_cart_scanner/pages/dashboard/widgets/carousel_widgets.dart';

class CustomPage extends ConsumerStatefulWidget {
  const CustomPage({super.key});

  @override
  _CustomPageState createState() => _CustomPageState();
}

class _CustomPageState extends ConsumerState<CustomPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.amber,
      appBar: AppBar(
        title: const Text("Dashboard"),
        actions: const [],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: const Column(
            children: [
              CarouselWidgets(),
              // CardOfCartWidgets(),
              SizedBox(
                height: 50.0,
              ),
              // const CardDetection()
            ],
          ),
        ),
      ),
    );
  }
}
