import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_cart_scanner/constant/appColor.dart';
import 'package:green_cart_scanner/constant/loading_app.dart';
import 'package:green_cart_scanner/model/history/historymodel.dart';
import 'package:green_cart_scanner/model/statusState/StatusCondition.dart';
import 'package:green_cart_scanner/pages/history/provider/history_database.dart';
import 'package:green_cart_scanner/pages/history/screen/history_detail.dart';
import 'package:green_cart_scanner/pages/navigator/screen/navigator_page.dart';
import 'package:green_cart_scanner/widgets/custom_text_style.dart';
import 'package:green_cart_scanner/widgets/not_found_widgets.dart';
import 'package:intl/intl.dart';

class HistoryPage extends ConsumerStatefulWidget {
  const HistoryPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HistoryPageState();
}

class _HistoryPageState extends ConsumerState<HistoryPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      String now = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
      ref.watch(historyDatabaseProvider.notifier).getHistoryByDate(date: now);
    });
    super.initState();
  }

  String dateToString(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  DateTime stringToDate(String date) {
    return DateTime.parse(date);
  }

  String today = DateFormat('yyyy-MM-dd').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NavigatorPage(
                        targetPage: 4,
                      ),
                    ),
                    (route) => false);
              },
              icon: const Icon(
                Icons.arrow_back,
              )),
          title: const Text(
            "Riwayat Nota",
            style: TextStyle(),
          ),
          centerTitle: true,
          // actions: [
          //   IconButton(
          //       onPressed: () {
          //         ref
          //             .watch(historyDatabaseProvider.notifier)
          //             .insertDummyHistory();
          //       },
          //       icon: Icon(Icons.add)),
          //   const SizedBox(
          //     width: 10.0,
          //   ),
          //   IconButton(
          //       onPressed: () {
          //         HistoryRepository().deleteAllItems();
          //       },
          //       icon: Icon(Icons.delete)),
          //   const SizedBox(
          //     width: 10.0,
          //   ),
          // ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
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
                  onDateChange: (selectedDate) {
                    today = dateToString(selectedDate);
                    ref
                        .watch(historyDatabaseProvider.notifier)
                        .getHistoryByDate(date: today);
                    setState(() {});
                  }),
              const SizedBox(
                height: 20.0,
              ),
              const Divider(
                thickness: 0.1,
              ),
              Consumer(
                builder: (context, wiRef, child) {
                  HistoryDatabaseState state =
                      wiRef.watch(historyDatabaseProvider);
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
                    List<HistoryModel> histories = state.data;
                    if (histories.isEmpty) {
                      return const Center(
                        child: NotFoundWidgets(),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: histories.length,
                      physics: const ScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        HistoryModel history = histories[index];
                        return Column(
                          children: [
                            ListTile(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => HistoryDetailPage(
                                          history: history,
                                        ),
                                      ));
                                },
                                title: Row(
                                  children: [
                                    Text(
                                      "${index + 1}.",
                                      style: const TextStyle(
                                        color: Colors.black54,
                                        fontSize: 21.0,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10.0,
                                    ),
                                    CustomTextStyle(
                                      text: history.date!.substring(11),
                                      fontsize: 20,
                                    ),
                                  ],
                                ),
                                trailing: const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Colors.white,
                                )),
                            const Divider(
                              thickness: 0.1,
                            )
                          ],
                        );
                      },
                    );
                  }
                  return Container();
                },
              )
            ],
          ),
        ));
  }
}
