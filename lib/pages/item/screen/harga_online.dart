import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:green_cart_scanner/constant/appColor.dart';
import 'package:green_cart_scanner/constant/loading_app.dart';
import 'package:green_cart_scanner/model/items/item.dart';
import 'package:green_cart_scanner/model/statusState/StatusCondition.dart';
import 'package:green_cart_scanner/pages/item/provider/items_offline/items_database.dart';
import 'package:green_cart_scanner/pages/item/provider/items_online/items_appwrite.dart';
import 'package:green_cart_scanner/pages/item/provider/widget_card_provider/widget_card_items_provider.dart';
import 'package:green_cart_scanner/pages/item/widgets/card_item_grid_widgets.dart';
import 'package:green_cart_scanner/pages/item/widgets/card_item_listtile_widgets.dart';
import 'package:green_cart_scanner/pages/item/widgets/custom_text_form_search_items.dart';
import 'package:green_cart_scanner/widgets/custom_snackbar.dart';
import 'package:green_cart_scanner/widgets/custom_text_style.dart';
import 'package:green_cart_scanner/widgets/not_found_widgets.dart';
import 'package:quickalert/quickalert.dart';

class HargaOnlineItemsPage extends ConsumerStatefulWidget {
  const HargaOnlineItemsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _HargaOnlineItemsPageState();
}

class _HargaOnlineItemsPageState extends ConsumerState<HargaOnlineItemsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  bool isDoneLoad = false;

  List<Item>? items;
  @override

  // setiap masuk kehalaman ini akan dilakukan get all data items untuk mendapatkan keseluruhan data dari api
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref
          .read(itemsAppwriteProvider.notifier)
          .getAllItemsByDateNow()
          .then((value) {
        isDoneLoad = true;
        setState(() {});
      });
    });

    super.initState();
  }

  Future<void> _handleRefresh() async {
    ref.read(itemsAppwriteProvider.notifier).getAllItemsByDateNow();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomTextStyle(
          text: "Harga pasar sekarang",
          fontsize: 17,
        ),
        centerTitle: true,
        actions: [
          isDoneLoad
              ? IconButton(
                  onPressed: () {
                    QuickAlert.show(
                        // headerBackgroundColor: AppColor.primary,
                        context: context,
                        type: QuickAlertType.confirm,
                        title: "Synchron Data",
                        text:
                            'Anda Akan Menyimpan Data online ini ke data local anda',
                        confirmBtnText: 'Iya',
                        cancelBtnText: 'Tidak',
                        confirmBtnColor: AppColor.primary,
                        onConfirmBtnTap: () async {
                          ref
                              .watch(itemsDatabaseProvider.notifier)
                              .deleteAllItem();
                          for (Item item in items!) {
                            // Logger().d(item);
                            Either<String, bool> resultSynchron = await ref
                                .watch(itemsDatabaseProvider.notifier)
                                .synchronToDBLocal(item);

                            resultSynchron.fold(
                                (l) => CustomSnackbar.show(context,
                                    message: l, colors: Colors.red),
                                (r) => null);
                          }

                          CustomSnackbar.show(context,
                              message: "Berhasil sinkron ke data local",
                              colors: AppColor.primary);
                          Navigator.pop(context);
                        });
                  },
                  icon: const Icon(Icons.sync))
              : Container(),
          const SizedBox(
            width: 2.0,
          ),
        ],
      ),
      body: Consumer(
        builder: (context, wiRef, child) {
          ItemsAppwriteState state = wiRef.watch(itemsAppwriteProvider);
          if (state.status == StatusCondition.loading) {
            return const Center(
              child: LoadingWidgets(),
            );
          }
          if (state.status == StatusCondition.failed) {
            return Center(
              child: Text(state.message),
            );
          }
          if (state.status == StatusCondition.success) {
            items = state.data;
            if (items!.isEmpty) {
              return const Center(
                child: NotFoundWidgets(),
              );
            }

            List<Item> filteredItems = _searchQuery.isEmpty
                ? items!
                : items!
                    .where((item) =>
                        item.nama_item!.toLowerCase().contains(_searchQuery))
                    .toList();

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(),
                        CustomTextStyle(
                            text: filteredItems[0].dateItems['date']),
                      ],
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    RefreshIndicator(
                      onRefresh: () => _handleRefresh(),
                      child: Consumer(
                        builder: (context, cardWidgetRef, child) {
                          final cardWidget = ref.watch(widgetCardItemsProvider);
                          return cardWidget.isGrid
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: filteredItems.length,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    Item item = filteredItems[index];

                                    return CardItemListTile(
                                      item: item,
                                      subtitle: Text("${item.berat} kg"),
                                      trailing: Text(
                                        'Rp.${item.harga ?? '0'} ',
                                        style: const TextStyle(
                                          fontSize: 17.0,
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
                                    );
                                  },
                                );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    // ButtonFullWidth(
                    //     warna: AppColor.primary2,
                    //     onPressed: () async {
                    //       ref
                    //           .watch(itemsDatabaseProvider.notifier)
                    //           .deleteAllItem();
                    //       for (Item item in items!) {
                    //         // Logger().d(item);
                    //         Either<String, bool> resultSynchron = await ref
                    //             .watch(itemsDatabaseProvider.notifier)
                    //             .synchronToDBLocal(item);

                    //         resultSynchron.fold(
                    //             (l) => CustomSnackbar.show(context,
                    //                 message: l, colors: Colors.red),
                    //             (r) => null);
                    //       }

                    //       CustomSnackbar.show(context,
                    //           message: "Berhasil sinkron ke database local",
                    //           colors: AppColor.primary);
                    //     },
                    //     title: 'sinkron ke data local'),

                    const SizedBox(
                      height: 20.0,
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
