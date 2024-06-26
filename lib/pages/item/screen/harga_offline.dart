import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_cart_scanner/constant/appColor.dart';
import 'package:green_cart_scanner/constant/icon_items.dart';
import 'package:green_cart_scanner/constant/loading_app.dart';
import 'package:green_cart_scanner/model/items/item.dart';
import 'package:green_cart_scanner/model/statusState/StatusCondition.dart';
import 'package:green_cart_scanner/pages/item/provider/items_offline/items_database.dart';
import 'package:green_cart_scanner/pages/item/provider/widget_card_provider/widget_card_items_provider.dart';
import 'package:green_cart_scanner/pages/item/widgets/card_item_grid_widgets.dart';
import 'package:green_cart_scanner/pages/item/widgets/card_item_listtile_widgets.dart';
import 'package:green_cart_scanner/pages/item/widgets/custom_text_form_search_items.dart';
import 'package:green_cart_scanner/widgets/buttonfull_widget.dart';
import 'package:logger/logger.dart';

class HargaOfflineItemsPage extends ConsumerStatefulWidget {
  const HargaOfflineItemsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _HargaOfflineItemsPageState();
}

class _HargaOfflineItemsPageState extends ConsumerState<HargaOfflineItemsPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.watch(itemsDatabaseProvider.notifier).getAllItems();
    });
    super.initState();
  }

  TextEditingController hargaItemController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  int getHarga(items) {
    for (var i in items) {
      if (i.nama_item == 'Tomat') {
        return i.harga;
      }
    }

    return 0;
  }

  void editOnBottomSheet(context, {required Item item}) {
    showBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (context) {
        hargaItemController.text = item.harga.toString();
        return Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              border: Border.symmetric(
                  vertical: BorderSide(color: AppColor.primary, width: 2)),
              borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
          padding: const EdgeInsets.all(20),
          height: 300,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Harga ${item.nama_item}',
                      style: const TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                    const SizedBox(
                      width: 5.0,
                    ),
                    IconItems.nameItem(item.nama_item ?? "")
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
                    labelText: "Harga items",
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
                        onPressed: () {
                          Item itemUpdate = Item(
                              nama_item: item.nama_item,
                              harga: int.parse(hargaItemController.text));
                          ref
                              .watch(itemsDatabaseProvider.notifier)
                              .updateItems(itemUpdate);
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          'Ubah Harga Pasar',
          style: TextStyle(
            fontSize: 21.0,
          ),
        ),
        actions: const [],
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                CustomTextFormSearchItems(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value.toLowerCase();
                        Logger().d(_searchQuery);
                      });
                    }),
                const SizedBox(
                  height: 10.0,
                ),
                Consumer(builder: (context, wiRef, child) {
                  ItemsDatabaseState state = wiRef.watch(itemsDatabaseProvider);
                  if (state.status == StatusCondition.init) {
                    return const SizedBox.shrink();
                  }
                  if (state.status == StatusCondition.loading) {
                    return Container(
                        margin: const EdgeInsets.only(top: 200),
                        child: const LoadingWidgets());
                  }
                  if (state.status == StatusCondition.failed) {
                    return Center(
                      child: Text(state.message),
                    );
                  }
                  if (state.status == StatusCondition.success) {
                    List<Item> items = state.data;

                    if (items.isEmpty) {
                      return Center(
                        child: Container(
                            margin: const EdgeInsets.only(top: 200),
                            child: const Text("Tidak ditemukan data")),
                      );
                    }

                    List<Item> filteredItems = _searchQuery.isEmpty
                        ? items
                        : items
                            .where((item) => item.nama_item!
                                .toLowerCase()
                                .contains(_searchQuery))
                            .toList();

                    getHarga(items);
                    return Column(
                      children: [
                        FutureBuilder<Item?>(
                          future: ref
                              .watch(itemsDatabaseProvider.notifier)
                              .getFirstItem(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else {
                              if (snapshot.hasData && snapshot.data != null) {
                                Logger().d(snapshot.data!);
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(' '),
                                    Text(' ${snapshot.data!.dateItems}'),
                                  ],
                                );
                              } else {
                                return const Text('No item found');
                              }
                            }
                          },
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Consumer(
                          builder: (context, cardWidgetRef, child) {
                            final cardWidget =
                                ref.watch(widgetCardItemsProvider);
                            return cardWidget.isGrid
                                ? ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: filteredItems.length,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      Item item = filteredItems[index];

                                      return CardItemListTile(
                                        item: item,
                                        subtitle: Text("Rp. ${item.harga}",
                                            style: const TextStyle(
                                              fontSize: 17.0,
                                            )),
                                        trailing: InkWell(
                                          onTap: () {
                                            editOnBottomSheet(context,
                                                item: item);
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
                                    physics:
                                        const NeverScrollableScrollPhysics(),
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
                                            editOnBottomSheet(context,
                                                item: item);
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
                        ),
                      ],
                    );
                  }
                  return Container();
                }),
              ],
            )),
      ),
    );
  }
}
