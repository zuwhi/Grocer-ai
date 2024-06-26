import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:green_cart_scanner/constant/appColor.dart';
import 'package:green_cart_scanner/constant/icon_items.dart';
import 'package:green_cart_scanner/constant/route.dart';
import 'package:green_cart_scanner/model/items/item.dart';
import 'package:green_cart_scanner/pages/camera/screen/camera_page.dart';
import 'package:green_cart_scanner/pages/cart/provider/cart_items.dart';
import 'package:green_cart_scanner/pages/cart/provider/countprovider/count_provider.dart';
import 'package:green_cart_scanner/pages/cart/provider/total_items.dart';
import 'package:green_cart_scanner/pages/cart/widgets/button_count_kilos_widgets.dart';
import 'package:green_cart_scanner/pages/cart/widgets/card_of_cart_widgets.dart';
import 'package:green_cart_scanner/pages/cart/widgets/custom_bottom_sheet_widgets.dart';
import 'package:green_cart_scanner/pages/history/provider/history_database.dart';
import 'package:green_cart_scanner/pages/history/screen/history_page.dart';
import 'package:green_cart_scanner/pages/navigator/screen/navigator_page.dart';
import 'package:green_cart_scanner/widgets/buttonfull_widget.dart';
import 'package:logger/logger.dart';
import 'package:quickalert/quickalert.dart';

class CartPage extends ConsumerStatefulWidget {
  const CartPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CartPageState();
}

class _CartPageState extends ConsumerState<CartPage> {
  TextEditingController hargaController = TextEditingController();
  TextEditingController beratController = TextEditingController();

  TextEditingController namaItemC = TextEditingController();
  TextEditingController hargaItemC = TextEditingController();
  TextEditingController beratItemC = TextEditingController();
  List<Item> items = [];
  num totalHarga = 0;
  int? selectedButtonIndex;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.watch(totalItemsProvider.notifier).countTotal(items);
    });
    super.initState();
  }

  List categories = [
    {
      "label": "Tomat",
      "image":
          "https://png.pngtree.com/png-clipart/20230113/ourmid/pngtree-red-fresh-tomato-with-green-leaf-png-image_6561484.png"
    },
  ];

  void modalBottom(Item item, index) {
    beratController.text = item.berat.toString();
    hargaController.text = item.harga.toString();
    ref.watch(countItemsProvider.notifier).initCountItem(item);
    labelKilo(index) {
      if (index == 0) {
        return "1 kg";
      } else if (index == 1) {
        return "1/2 kg";
      } else if (index == 2) {
        return "1/4 kg";
      } else if (index == 3) {
        return "1/8 kg";
      } else if (index == 4) {
        return "2 kg";
      } else if (index == 5) {
        return "2.5 kg";
      } else if (index == 6) {
        return "3 kg";
      } else if (index == 7) {
        return "4 kg";
      } else if (index == 8) {
        return "5 kg";
      }
    }

    showModalBottomSheet(
        context: context,
        useRootNavigator: true,
        isScrollControlled: true,
        enableDrag: true,
        builder: (BuildContext context) => Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(25))),
              height: 500,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Consumer(builder: (context, modalref, child) {
                var countState = modalref.watch(countItemsProvider);
                Logger().d(countState.weight);
                return Column(
                  children: [
                    const SizedBox(
                      height: 8.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 130,
                        height: 7,
                        decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconItems.nameItem(item.nama_item ?? ""),
                            const SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              item.nama_item ?? '-',
                              style: GoogleFonts.inter(
                                fontSize: 28.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                            onPressed: () {
                              modalref
                                  .read(cartItemsProvider.notifier)
                                  .removeItem(index);

                              modalref
                                  .watch(totalItemsProvider.notifier)
                                  .countTotal(items);
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.delete))
                      ],
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'harga',
                          style: GoogleFonts.inter(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          width: 60,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            controller: hargaController,
                            onChanged: (value) {
                              modalref
                                  .watch(countItemsProvider.notifier)
                                  .changePrice(num.parse(value));
                              // modalref
                              //     .watch(countItemsProvider.notifier)
                              //     .changeKilos(num.parse(value));

                              beratController.text =
                                  countState.weight.toString();

                              setState(() {});
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'berat item',
                          style: GoogleFonts.inter(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                border: Border.all(width: 0.2),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Center(
                                child: IconButton(
                                    onPressed: () {
                                      modalref
                                          .watch(countItemsProvider.notifier)
                                          .minusCountItem();
                                      hargaController.text =
                                          countState.price.toString();
                                      beratController.text =
                                          countState.weight.toString();
                                    },
                                    icon: const Icon(
                                      Icons.minimize_rounded,
                                      size: 10,
                                    )),
                              ),
                            ),
                            const SizedBox(
                              width: 8.0,
                            ),
                            SizedBox(
                              width: 30,
                              child: TextFormField(
                                controller: beratController,
                                keyboardType: TextInputType.number,
                                onFieldSubmitted: (value) {
                                  modalref
                                      .watch(countItemsProvider.notifier)
                                      .changeKilos(num.parse(value));
                                  // CountItemState itemState =
                                  //     modalref.watch(countItemsProvider);
                                  hargaController.text =
                                      countState.price.toString();
                                  // setState(() {});
                                },
                                onChanged: (value) {
                                  // modalref.watch(countItemsProvider.select(
                                  //     (e) => e.weight = num.parse(value)));
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 8.0,
                            ),
                            Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                border: Border.all(width: 0.2),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Center(
                                child: IconButton(
                                    onPressed: () {
                                      modalref
                                          .watch(countItemsProvider.notifier)
                                          .plusCountItem();
                                      hargaController.text =
                                          countState.price.toString();
                                      beratController.text =
                                          countState.weight.toString();
                                    },
                                    icon: const Icon(
                                      Icons.add,
                                      size: 10,
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    Text(
                      'Hitung Perkiloan :',
                      style: GoogleFonts.inter(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 2,
                        ),
                        shrinkWrap: true,
                        itemCount: 9,
                        itemBuilder: (context, index) {
                          int selectIndex = countState.selectIndex ?? 0;

                          return Center(
                              child: ButtonCountKilos(
                                  backgroundColor: selectIndex == index
                                      ? AppColor.primary2
                                      : AppColor.grey4,
                                  onPressed: () {
                                    modalref
                                        .watch(countItemsProvider.notifier)
                                        .changeSelectIndex(index);
                                    modalref
                                        .watch(countItemsProvider.notifier)
                                        .countByKiloPercen(index);

                                    hargaController.text =
                                        countState.price.toString();
                                    beratController.text =
                                        countState.weight.toString();
                                  },
                                  label: labelKilo(index) ?? ""));
                        }),
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ButtonFullWidth(
                            onPressed: () {
                              ref
                                  .watch(cartItemsProvider.notifier)
                                  .editPriceItem(index, hargaController.text,
                                      beratController.text);
                              ref
                                  .watch(totalItemsProvider.notifier)
                                  .countTotal(items);
                              setState(() {});
                              Navigator.pop(context);
                            },
                            title: 'Edit Data')
                      ],
                    ))
                  ],
                );
              }),
            ));
  }

  @override
  Widget build(BuildContext context) {
    items = ref.watch(cartItemsProvider);
    totalHarga = ref.watch(totalItemsProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NavigatorPage(),
                  ),
                  (route) => false);
            },
            icon: const Icon(Icons.home_rounded)),
        centerTitle: true,
        title: const Text(
          "Hitung Keranjang",
        ),
        actions: const [],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height - 90,
            minWidth: double.infinity,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  ListView.builder(
                    itemCount: items.length,
                    shrinkWrap: true,
                    itemExtent: 80,
                    physics: const ScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      Item item = items[index];

                      return Container(
                        margin: const EdgeInsets.only(top: 6),
                        child: CardOfCartWidgets(
                          item: item,
                          onPressed: () {
                            modalBottom(item, index);
                          },
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    child: Divider(),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Harga :',
                          style: GoogleFonts.inter(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'Rp. $totalHarga',
                          style: GoogleFonts.inter(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w800,
                              color: AppColor.grey1),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10.0),
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        ButtonFullWidth(
                            height: 45,
                            width: 150,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const CameraPage(),
                                  ));
                            },
                            title: 'Scan Lagi'),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          child: ButtonFullWidth(
                              height: 45,
                              warna: AppColor.primary,
                              fs: 15,
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
                                                harga:
                                                    int.parse(hargaItemC.text),
                                                berat:
                                                    int.parse(beratItemC.text),
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
                                        ));
                              },
                              title: 'Tambah Manual'),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    ButtonFullWidth(
                        warna: AppColor.primary2,
                        onPressed: () {
                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.confirm,
                            title: "Simpan ke Riwayat",
                            text:
                                'Apakah kamu ingin menyimpan data ini ke riwayat ?',
                            confirmBtnText: 'Iya',
                            cancelBtnText: 'Tidak',
                            confirmBtnColor: AppColor.primary,
                            onConfirmBtnTap: () {
                              ref
                                  .watch(historyDatabaseProvider.notifier)
                                  .insertDataToHistory(items);

                              ref
                                  .watch(cartItemsProvider.notifier)
                                  .manualDispose();

                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const HistoryPage(),
                                  ),
                                  (route) => false);
                            },
                          );
                        },
                        title: 'Simpan Data'),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
