// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_cart_scanner/constant/appColor.dart';
import 'package:green_cart_scanner/constant/icon_items.dart';
import 'package:green_cart_scanner/model/history/historymodel.dart';
import 'package:green_cart_scanner/model/items/item.dart';
import 'package:green_cart_scanner/pages/history/provider/history_database.dart';
import 'package:green_cart_scanner/pages/history/screen/history_page.dart';
import 'package:green_cart_scanner/widgets/custom_snackbar.dart';
import 'package:green_cart_scanner/widgets/custom_text_style.dart';
import 'package:quickalert/quickalert.dart';

class HistoryDetailPage extends ConsumerStatefulWidget {
  final HistoryModel history;
  const HistoryDetailPage({
    super.key,
    required this.history,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _HistoryDetailPageState();
}

class _HistoryDetailPageState extends ConsumerState<HistoryDetailPage> {
  @override
  void initState() {
    super.initState();
  }

  totalHarga(List<Item> items) {
    num harga = 0;
    for (Item i in items) {
      harga += i.harga!;
    }
    return harga;
  }

  @override
  Widget build(BuildContext context) {
    HistoryModel history = widget.history;
    List<Item> items = history.items!;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text(
            "Detail Riwayat",
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  QuickAlert.show(
                      // headerBackgroundColor: AppColor.primary,
                      context: context,
                      type: QuickAlertType.confirm,
                      title: "Hapus Nota",
                      text:
                          'Apakah anda yakin ingin menghapus riwayat nota ini ?',
                      confirmBtnText: 'Iya',
                      cancelBtnText: 'Tidak',
                      confirmBtnColor: AppColor.primary,
                      onConfirmBtnTap: () async {
                        await ref
                            .watch(historyDatabaseProvider.notifier)
                            .deleteHistoryById(history.id);
                        CustomSnackbar.show(context,
                            message: "berhasil menghapus riwayat",
                            colors: AppColor.primary);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HistoryPage(),
                            ));
                      });
                },
                icon: const Icon(
                  Icons.delete,
                  color: Colors.black,
                )),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              children: [
                Consumer(builder: (context, wiRef, child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const SizedBox(
                        height: 10.0,
                      ),
                      CustomTextStyle(
                        text: history.date ?? '-',
                        color: Colors.black87,
                      ),
                      const SizedBox(
                        height: 18.0,
                      ),
                      const Divider(
                        thickness: 0.3,
                        height: 0,
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: items.length,
                        physics: const ScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          Item item = items[index];
                          return Column(
                            children: [
                              ListTile(
                                contentPadding: const EdgeInsets.all(0),
                                leading:
                                    IconItems.nameItem(item.nama_item ?? '-'),
                                title: Text(item.nama_item ?? '-',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 18.0,
                                    )),
                                subtitle: Text('${item.berat ?? '-'} kg',
                                    style: const TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.black87,
                                    )),
                                trailing: Text(
                                  'Rp. ${item.harga ?? ''}',
                                  style: const TextStyle(
                                      fontSize: 16.0, color: Colors.black),
                                ),
                              ),
                              const Divider(
                                thickness: 0.3,
                                height: 0,
                              )
                            ],
                          );
                        },
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total :',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 19.0,
                                color: Colors.black),
                          ),
                          Text(
                            'Rp. ${totalHarga(items)}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                                color: Colors.black),
                          ),
                        ],
                      ),
                    ],
                  );
                })
              ],
            ),
          ),
        ));
  }
}
