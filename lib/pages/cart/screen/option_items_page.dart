import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fpdart/fpdart.dart';
import 'package:green_cart_scanner/constant/appColor.dart';
import 'package:green_cart_scanner/constant/loading_app.dart';
import 'package:green_cart_scanner/constant/route.dart';
import 'package:green_cart_scanner/model/items/item.dart';
import 'package:green_cart_scanner/pages/cart/provider/cart_items.dart';
import 'package:green_cart_scanner/pages/cart/widgets/custom_bottom_sheet_widgets.dart';
import 'package:green_cart_scanner/pages/item/provider/items_offline/items_database.dart';
import 'package:green_cart_scanner/widgets/buttonfull_widget.dart';
import 'package:green_cart_scanner/widgets/custom_text_style.dart';
import 'package:green_cart_scanner/widgets/oval_clip_widgets.dart';
import 'package:logger/logger.dart';
import 'package:quickalert/quickalert.dart';

class OptionItemsPage extends ConsumerStatefulWidget {
  const OptionItemsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OptionItemsPageState();
}

class _OptionItemsPageState extends ConsumerState<OptionItemsPage> {
  TextEditingController namaItemC = TextEditingController();
  TextEditingController hargaItemC = TextEditingController();
  TextEditingController beratItemC = TextEditingController();
  bool isLoad = false;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      synchronDataItems();
      // ref.watch(itemsDatabaseProvider.notifier).deleteAllItem();
    });
    super.initState();
  }

  synchronDataItems() async {
    Item? item = await ref.watch(itemsDatabaseProvider.notifier).getFirstItem();

    if (item == null) {
      Logger().d(" tidak ada data di dalam items local");

      QuickAlert.show(
        context: context,
        type: QuickAlertType.confirm,
        title: "Data Harga Masih Kosong",
        text:
            'Anda Harus Online Untuk mendapatkan data harga pasar, melakukan sinkronisasi data online?',
        confirmBtnText: 'Yes',
        cancelBtnText: 'No',
        onConfirmBtnTap: () async {
          Navigator.pop(context);
          setState(() {
            isLoad = true;
          });

          Either<String, bool> result = await ref
              .watch(itemsDatabaseProvider.notifier)
              .autoSynchronDataPrice();

          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            text: 'Berhasil Sinkron data online',
          );
          setState(() {
            isLoad = false;
          });
        },
        confirmBtnColor: AppColor.primary,
      );
    } else {
      Logger().d("ada data di dalam items local");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoad
          ? const LoadingWidgets()
          : SingleChildScrollView(
              child: SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height,
                child: Stack(
                  children: [
                    const OvalClipWidgets(),
                    Positioned(
                        right: 25,
                        top: 180,
                        child: SvgPicture.asset("assets/images/boy.svg")),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 40.0,
                        ),
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.arrow_back_rounded,
                              size: 28,
                              color: Colors.white,
                            )),
                        const SizedBox(
                          height: 50.0,
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 25),
                          width: 400,
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomTextStyle(
                                text: "Tambah",
                                color: Colors.white,
                                fontsize: 40,
                              ),
                              CustomTextStyle(
                                text: "Item",
                                color: Colors.white,
                                fontsize: 38,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  children: [
                                    ButtonFullWidth(
                                      title: "Scan Items mu",
                                      height: 50,
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, NameRoute.camera);
                                      },
                                    ),
                                    const SizedBox(
                                      height: 20.0,
                                    ),
                                    ButtonFullWidth(
                                      onPressed: () {
                                        showModalBottomSheet(
                                          isScrollControlled: true,
                                          backgroundColor: Colors.white,
                                          elevation: 0,
                                          context: context,
                                          builder: (context) =>
                                              CustomBottomSheetWidget(
                                            nameItemC: namaItemC,
                                            beratItemC: beratItemC,
                                            hargaItemC: hargaItemC,
                                            onPressed: () {
                                              Item itemAdd = Item(
                                                  nama_item: namaItemC.text,
                                                  harga: int.parse(
                                                      hargaItemC.text),
                                                  berat: int.parse(
                                                      beratItemC.text),
                                                  dateItems: '2024',
                                                  id: "aa",
                                                  nama_kota: 'jepara');
                                              Logger().d(itemAdd);
                                              if (namaItemC.text.isNotEmpty ||
                                                  namaItemC.text.isNotEmpty) {
                                                ref
                                                    .watch(cartItemsProvider
                                                        .notifier)
                                                    .addItem(itemAdd);
                                                Navigator.pushNamed(
                                                    context, NameRoute.cart);
                                              }
                                            },
                                          ),
                                        );
                                      },
                                      warna: Colors.white,
                                      title: "Tambah Manual",
                                      textColor: AppColor.primary,
                                    ),
                                    const SizedBox(
                                      height: 50.0,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
