// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_cart_scanner/constant/appColor.dart';
import 'package:green_cart_scanner/constant/loading_app.dart';
import 'package:green_cart_scanner/model/items/item.dart';
import 'package:green_cart_scanner/model/statusState/StatusCondition.dart';
import 'package:green_cart_scanner/pages/camera/provider/camera_init.dart';
import 'package:green_cart_scanner/pages/camera/provider/camera_notifier.dart';
import 'package:green_cart_scanner/pages/camera/provider/object_detect.dart';
import 'package:green_cart_scanner/pages/camera/widgets/card_detection_widgets.dart';
import 'package:green_cart_scanner/pages/cart/provider/cart_items.dart';
import 'package:green_cart_scanner/pages/cart/screen/cart_page.dart';
import 'package:green_cart_scanner/pages/item/provider/items_offline/items_database.dart';
import 'package:green_cart_scanner/widgets/custom_text_style.dart';

class CameraPage extends ConsumerStatefulWidget {
  const CameraPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CameraPageState();
}

class _CameraPageState extends ConsumerState<CameraPage> {
  int? harga;
  Item? item;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.watch(itemsDatabaseProvider.notifier).getAllItems();
      ref.watch(cameraInitProvider);
    });
    // TODO: implement initState
    super.initState();
  }

  void cameraDisponse(controller) {
    controller.dispose();
  }

  Item compared({String objectLabel = '', items}) {
    for (Item i in items) {
      if (objectLabel.toLowerCase() == i.nama_item?.toLowerCase()) {
        Item item =
            Item(nama_item: i.nama_item, harga: i.harga, berat: i.berat);

        return item;
      }
    }
    return Item();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        ref.watch(cameraNotifierProvider.notifier).disposeCam();
      },
      child: Scaffold(
        backgroundColor: AppColor.primary,
        body: Consumer(builder: (context, wiRef, child) {
          ItemsDatabaseState state = wiRef.watch(itemsDatabaseProvider);
          if (state.status == StatusCondition.init) {
            return const SizedBox.shrink();
          }
          if (state.status == StatusCondition.loading) {
            return const LoadingWidgets();
          }
          if (state.status == StatusCondition.failed) {
            return Center(
              child: Text(state.message),
            );
          }
          if (state.status == StatusCondition.success) {
            List<Item> items = state.data;

            // inisiasi camera
            var cameraInit = wiRef.watch(cameraNotifierProvider
                .select((value) => value.isCamerainitialized));
            var cameraController = wiRef.watch(cameraNotifierProvider
                .select((value) => value.cameraController));

            // mendapatkan data object yang dideteksi
            ObjectState object = wiRef.watch(objectDetectProvider);

            num percen = 0;
            if (object.percen != null) {
              percen = (object.percen! * 100);
            }

            Item itemCompare =
                compared(items: items, objectLabel: object.label!);
            // Logger().d("cek lebel : ${object.label!}");
            return cameraInit!
                ? Stack(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: cameraController != null
                            ? CameraPreview(cameraController)
                            : const Text('null camera controller'),
                      ),
                      Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: SizedBox(
                            width: double.infinity,
                            height: 150,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      ref
                                          .watch(
                                              cameraNotifierProvider.notifier)
                                          .disposeCam();
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(
                                      Icons.arrow_back,
                                      color: Colors.white,
                                    )),
                                const CustomTextStyle(
                                  text: "Scan",
                                  color: Colors.white,
                                  fontsize: 20,
                                ),
                                // const SizedBox(
                                //   width: 8.0,
                                // ),
                                IconButton(
                                    onPressed: () {
                                      ref
                                          .watch(
                                              cameraNotifierProvider.notifier)
                                          .disposeCam();
                                    },
                                    icon: const Icon(
                                      Icons.pause,
                                      color: Colors.white,
                                    )),
                              ],
                            ),
                          )),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Column(
                          children: [
                            percen < 80 || itemCompare.nama_item == null
                                ? const CustomTextStyle(
                                    text: 'Tidak ada Object yang terdeteksi',
                                    color: Colors.white,
                                  )
                                : Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: CardDetection(
                                        item: itemCompare,
                                        akurasi: percen.toStringAsFixed(2))),
                            const SizedBox(
                              height: 25.0,
                            ),
                            Container(
                              color: Colors.black38,
                              width: double.infinity,
                              height: 130,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const SizedBox(
                                    height: 20.0,
                                  ),
                                  ButtonAddItemsCart(
                                    isActive: (percen < 80 ||
                                            itemCompare.nama_item == null)
                                        ? false
                                        : true,
                                    onTap: () {
                                      wiRef
                                          .watch(
                                              cameraNotifierProvider.notifier)
                                          .disposeCam();

                                      ref
                                          .watch(cartItemsProvider.notifier)
                                          .addItem(itemCompare);
                                      ref
                                          .watch(
                                              cameraNotifierProvider.notifier)
                                          .disposeCam();
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const CartPage(),
                                        ),
                                        (route) => false,
                                      );
                                    },
                                  ),
                                  const SizedBox(
                                    height: 20.0,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : const Center(
                    child: CustomTextStyle(
                    text: "loading Preview Camera..",
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ));
          }

          return Container();
        }),
      ),
    );
  }
}

class ButtonAddItemsCart extends StatelessWidget {
  final void Function()? onTap;
  final bool isActive;
  const ButtonAddItemsCart({
    super.key,
    this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isActive ? onTap : () {},
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          Container(
            height: 69,
            width: 69,
            decoration: BoxDecoration(
              color: isActive ? AppColor.primary : Colors.grey,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Center(
              child: Icon(
                Icons.add,
                size: 30,
                color: isActive ? Colors.white : Colors.black26,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
