import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:green_cart_scanner/constant/appColor.dart';
import 'package:green_cart_scanner/constant/icon_items.dart';
import 'package:green_cart_scanner/model/items/item.dart';
import 'package:green_cart_scanner/pages/item/provider/date_Items_Appwrite/date_items_appwrite.dart';
import 'package:green_cart_scanner/pages/item/provider/items_Title_Models/items_label_models_provider.dart';
import 'package:green_cart_scanner/pages/item/provider/items_online/items_appwrite.dart';
import 'package:green_cart_scanner/pages/item/provider/widget_card_provider/widget_card_items_provider.dart';
import 'package:green_cart_scanner/pages/item/widgets/card_item_grid_widgets.dart';
import 'package:green_cart_scanner/pages/item/widgets/card_item_listtile_widgets.dart';
import 'package:green_cart_scanner/pages/item/widgets/custom_text_form_search_items.dart';
import 'package:green_cart_scanner/widgets/buttonfull_widget.dart';
import 'package:green_cart_scanner/widgets/custom_snackbar.dart';
import 'package:green_cart_scanner/widgets/custom_text_style.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/quickalert.dart';

class AddDataItemsPage extends ConsumerStatefulWidget {
  const AddDataItemsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddDataItemsPageState();
}

class _AddDataItemsPageState extends ConsumerState<AddDataItemsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  bool isLoad = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      List<Item> items = ref.watch(itemsLabelModelsProvider);
      if (items.isEmpty) {
        ref.watch(itemsLabelModelsProvider.notifier).getLabels();
      }
    });
  }

  void showEditModal(context, index, wiref, item) {
    showBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      elevation: 0,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          side: BorderSide(
            width: 0.2,
            color: Colors.grey,
          )),
      builder: (context) {
        TextEditingController hargaItemController = TextEditingController();
        hargaItemController.text = '${item.harga ?? '0'}';
        return Container(
          height: 300,
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Ubah Harga ${item.nama_item}',
                      style: const TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    IconItems.nameItem(item.nama_item!)
                  ],
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Container(
                margin: const EdgeInsets.only(),
                child: TextFormField(
                  controller: hargaItemController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: "Harga Items",
                    hintText: "masukkan harga",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (value) {},
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(),
                    ButtonFullWidth(
                        warna: AppColor.primary,
                        onPressed: () async {
                          Item itemUpdate = Item(
                              berat: 1,
                              nama_item: item.nama_item,
                              harga: int.parse(hargaItemController.text));
                          await wiref
                              .watch(itemsLabelModelsProvider.notifier)
                              .updatePrice(index, item: itemUpdate);
                          setState(() {});
                          Navigator.pop(context);
                        },
                        title: "Edit Harga")
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String dateNow = DateFormat('yyyy-MM-dd').format(DateTime.now());

    List<Item> items = ref.watch(itemsLabelModelsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const CustomTextStyle(
          text: "Admin Tambah Harga",
          fontsize: 20,
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () async {
                QuickAlert.show(
                    context: context,
                    type: QuickAlertType.loading,
                    title: 'Loading...',
                    text: 'Sedang mengambil data terakhir',
                    disableBackBtn: true);

                List<Item> resultItems = await ref
                    .watch(itemsAppwriteProvider.notifier)
                    .getAllItemsByDateNow();

                await ref
                    .watch(itemsLabelModelsProvider.notifier)
                    .getFromDateCurrent(items: resultItems);

                Navigator.pop(context);
              },
              icon: const Icon(Icons.sync)),
          const SizedBox(
            width: 5.0,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SizedBox(
                      width: 195,
                      child: Text(
                        "Daftar Harga akan tercatat pada tanggal :",
                        style: TextStyle(),
                      )),
                  Text(
                    dateNow,
                    style: const TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10.0,
              ),
              CustomTextFormSearchItems(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                    });
                  }),
              const SizedBox(
                height: 10.0,
              ),
              Consumer(builder: (context, wiref, child) {
                List<Item> filteredItems = _searchQuery.isEmpty
                    ? items
                    : items
                        .where((item) => item.nama_item!
                            .toLowerCase()
                            .contains(_searchQuery))
                        .toList();

                return Consumer(
                  builder: (context, cardWidgetRef, child) {
                    final cardWidget = ref.watch(widgetCardItemsProvider);
                    return cardWidget.isGrid
                        ? ListView.builder(
                            shrinkWrap: true,
                            itemCount: filteredItems.length,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              Item item = filteredItems[index];

                              return CardItemListTile(
                                item: item,
                                subtitle: Text("Rp. ${item.harga}",
                                    style: const TextStyle(
                                      fontSize: 17.0,
                                    )),
                                trailing: InkWell(
                                  onTap: () {
                                    showEditModal(context, index, wiref, item);
                                  },
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: const BoxDecoration(
                                      color: AppColor.primary,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(50.0),
                                      ),
                                    ),
                                    child: const Center(
                                        child: Icon(
                                      Icons.edit,
                                      size: 20,
                                      color: Colors.white,
                                    )),
                                  ),
                                ),
                              );
                            },
                          )
                        : GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10.0,
                              mainAxisSpacing: 10.0,
                              childAspectRatio: 1.3,
                            ),
                            itemCount: filteredItems.length,
                            itemBuilder: (context, index) {
                              Item item = filteredItems[index];
                              return CardItemGrid(
                                item: item,
                                editButton: InkWell(
                                  onTap: () {
                                    showEditModal(context, index, wiref, item);
                                  },
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: const BoxDecoration(
                                      color: AppColor.primary,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(50.0),
                                      ),
                                    ),
                                    child: const Center(
                                        child: Icon(
                                      Icons.edit,
                                      size: 20,
                                      color: Colors.white,
                                    )),
                                  ),
                                ),
                              );
                            },
                          );
                  },
                );
              }),
              const SizedBox(
                height: 10.0,
              ),
              Consumer(builder: (context, buttonRef, child) {
                return ButtonFullWidth(
                    warna: AppColor.primary2,
                    isload: isLoad,
                    title: "Simpan data harga hari ini",
                    onPressed: () async {
                      setState(() {
                        isLoad = true;
                      });
                      QuickAlert.show(
                          context: context,
                          type: QuickAlertType.loading,
                          title: 'Loading...',
                          text: 'Sedang menambahkan data',
                          disableBackBtn: true);
                      Either<String, String> resultCreateDateItems =
                          await buttonRef
                              .read(dateItemsAppwriteProvider.notifier)
                              .createDateItems();

                      await resultCreateDateItems.fold((l) {
                        CustomSnackbar.show(context,
                            message: l, colors: Colors.red);
                      }, (dateItemsId) async {
                        Either<String, bool> resultCreateItems = await buttonRef
                            .read(itemsAppwriteProvider.notifier)
                            .addItemsLoop(
                                items: items, dateItemsId: dateItemsId);
                        CustomSnackbar.show(context,
                            message: resultCreateItems.fold(
                                (l) => l, (r) => "Berhasil menambah data"),
                            colors: resultCreateItems.isRight()
                                ? AppColor.primary
                                : Colors.red);
                      });
                      Navigator.pop(context);
                      if (mounted) {
                        setState(() {
                          isLoad = false;
                        });
                      }
                    });
              }),
              const SizedBox(
                height: 8.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
