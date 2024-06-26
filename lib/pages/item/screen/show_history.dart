import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:green_cart_scanner/constant/appColor.dart';
import 'package:green_cart_scanner/constant/icon_items.dart';
import 'package:green_cart_scanner/constant/loading_app.dart';
import 'package:green_cart_scanner/model/items/item.dart';
import 'package:green_cart_scanner/model/statusState/StatusCondition.dart';
import 'package:green_cart_scanner/pages/item/provider/items_online/items_appwrite.dart';
import 'package:green_cart_scanner/pages/item/provider/widget_card_provider/widget_card_items_provider.dart';
import 'package:green_cart_scanner/pages/item/widgets/card_item_grid_widgets.dart';
import 'package:green_cart_scanner/pages/item/widgets/card_item_listtile_widgets.dart';
import 'package:green_cart_scanner/pages/item/widgets/custom_text_form_search_items.dart';
import 'package:green_cart_scanner/pages/navigator/provider/session_provider.dart';
import 'package:green_cart_scanner/widgets/buttonfull_widget.dart';
import 'package:green_cart_scanner/widgets/not_found_widgets.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

class ShowHistoryPage extends ConsumerStatefulWidget {
  final bool isAdmin;
  const ShowHistoryPage({super.key, this.isAdmin = false});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ShowHistoryPageState();
}

class _ShowHistoryPageState extends ConsumerState<ShowHistoryPage> {
  TextEditingController hargaItemController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.watch(itemsAppwriteProvider.notifier).getItemsByDate(
          date: DateFormat('yyyy-MM-dd').format(DateTime.now()));
    });
  }

  String dateToString(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  DateTime stringToDate(String date) {
    return DateTime.parse(date);
  }

  String today = DateFormat('yyyy-MM-dd').format(DateTime.now());

  Future<void> _handleRefresh() async {
    await ref.watch(itemsAppwriteProvider.notifier).getItemsByDate(date: today);
  }

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    bool isAdmin = widget.isAdmin;
    SessionState sessionState = ref.watch(sessionNotifierProvider);
    return Scaffold(
      // backgroundColor: AppColor.primary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          "Lihat Harga Pasar",
          style: TextStyle(),
        ),
        centerTitle: true,
        actions: const [],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            EasyDateTimeLine(
              initialDate: stringToDate(today),
              locale: "ID",
              dayProps: const EasyDayProps(
                height: 80,
                width: 65,
                dayStructure: DayStructure.monthDayNumDayStr,
                todayHighlightColor: AppColor.primary,
                activeDayStyle: DayStyle(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      color: AppColor.primary),
                ),
              ),
              onDateChange: (selectedDate) async {
                today = dateToString(selectedDate);
                await ref
                    .watch(itemsAppwriteProvider.notifier)
                    .getItemsByDate(date: today);
                setState(() {});
              },
            ),
            const SizedBox(
              height: 15.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: CustomTextFormSearchItems(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                      Logger().d(_searchQuery);
                    });
                  }),
            ),
            const SizedBox(
              height: 15.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Consumer(
                builder: (context, wiRef, child) {
                  ItemsAppwriteState state = wiRef.watch(itemsAppwriteProvider);
                  if (state.status == StatusCondition.loading) {
                    return Center(
                      child: Container(
                          margin: const EdgeInsets.only(top: 160),
                          child: const LoadingWidgets()),
                    );
                  }
                  if (state.status == StatusCondition.failed) {
                    return Center(
                      child: Container(
                          margin: const EdgeInsets.only(top: 170),
                          child: Text(state.message)),
                    );
                  }
                  if (state.status == StatusCondition.success) {
                    List<Item> items = state.data;

                    if (items.isEmpty) {
                      return const Center(
                        child: NotFoundWidgets(
                          height: 80,
                        ),
                      );
                    }

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

                                  return (isAdmin ||
                                          (sessionState.account?.role!
                                                  .toLowerCase() ==
                                              'admin'))
                                      ? CardItemListTile(
                                          item: item,
                                          subtitle: Text("Rp. ${item.harga}",
                                              style: const TextStyle(
                                                fontSize: 17.0,
                                              )),
                                          trailing: InkWell(
                                            onTap: () {
                                              editOnBottomSheet(context,
                                                  item: item, date: today);
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
                                          ))
                                      : CardItemListTile(
                                          item: item,
                                          subtitle: Text(item.nama_item ?? '-'),
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
                                  return (isAdmin ||
                                          (sessionState.account?.role!
                                                  .toLowerCase() ==
                                              'admin'))
                                      ? CardItemGrid(
                                          item: item,
                                          editButton: InkWell(
                                            onTap: () {
                                              editOnBottomSheet(context,
                                                  item: item, date: today);
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
                                        )
                                      : CardItemGrid(
                                          item: item,
                                        );
                                },
                              );
                      },
                    );
                  }

                  return Container();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void editOnBottomSheet(context,
      {required Item item,
      required String date,
      dynamic Function()? onPressed}) {
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
          height: 400,
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
                    labelText: "Harga Sayur",
                    hintText: "masukkan harga",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(),
                    ButtonFullWidth(
                        onPressed: () async {
                          Navigator.pop(context);
                          print("cek after navigator pop");
                          Item itemUpdate = Item(
                              id: item.id,
                              nama_item: item.nama_item,
                              harga: int.parse(hargaItemController.text));

                          Either<String, String> result = await ref
                              .watch(itemsAppwriteProvider.notifier)
                              .editItems(item: itemUpdate, date: date);

                          // result.fold(
                          //     (l) => l,
                          //     (r) => QuickAlert.show(
                          //           context: context,
                          //           type: QuickAlertType.success,
                          //           text: "berhasil mengubah $r",
                          //         ));
                        },
                        title: "Edit Harga")
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
