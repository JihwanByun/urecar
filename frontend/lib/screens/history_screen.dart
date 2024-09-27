import 'package:flutter/material.dart';
import 'package:frontend/components/common/bottom_navigation.dart';
import 'package:frontend/components/common/screen_card.dart';
import 'package:frontend/components/common/top_bar.dart';
import 'package:frontend/components/history_screen/date_button.dart';
import 'package:frontend/controller.dart';
import 'package:frontend/screens/report_screen.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  DateTime lastDate = DateTime.now();
  DateTime startDate = DateTime.now().subtract(const Duration(days: 92));
  int selectedIndex = 0;
  bool landed = true;
  @override
  Widget build(BuildContext context) {
    final MainController controller = Get.put(MainController());
    String lastDateFormat = DateFormat('yy.MM.dd').format(lastDate);
    String startDateFormat = DateFormat('yy.MM.dd').format(startDate);

    Future<DateTime> selectDate(
        BuildContext context, DateTime selectedDate, DateTime last) async {
      final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2020),
        lastDate: last,
      );

      return pickedDate ?? selectedDate;
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: TopBar(
          onNotificationPressed: () {
            controller.showNotification;
          },
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DateButton(
                date: startDateFormat,
                onPressed: () async {
                  final DateTime temp = await selectDate(
                    context,
                    startDate,
                    lastDate,
                  );
                  if (temp != startDate) {
                    setState(() {
                      startDate = temp;
                    });
                  }
                },
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Icon(
                  Icons.swap_horiz_sharp,
                  size: 35,
                ),
              ),
              DateButton(
                date: lastDateFormat,
                onPressed: () async {
                  final DateTime temp = await selectDate(
                    context,
                    lastDate,
                    DateTime.now(),
                  );
                  if (temp != lastDate) {
                    if (temp.isBefore(startDate)) {
                      setState(() {
                        lastDate = temp;
                        startDate = lastDate.subtract(const Duration(days: 92));
                      });
                    } else {
                      setState(() {
                        lastDate = temp;
                      });
                    }
                  }
                },
              )
            ],
          ),
          const SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              buildStatusChoice(0, "전체"),
              buildStatusChoice(1, "진행중"),
              buildStatusChoice(2, "수용"),
              buildStatusChoice(3, "불수용"),
              buildStatusChoice(4, "취소"),
              const SizedBox(
                width: 40,
              )
            ],
          ),
          const SizedBox(
            height: 6,
          ),
          SizedBox(
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.black26, width: 0.7),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              landed
                  ? const Padding(
                      padding: EdgeInsets.only(top: 8, right: 20),
                      child: Text(
                        "최근(10건)",
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    )
                  : const Text(""),
            ],
          ),
          Column(
            children: [
              GestureDetector(
                onTap: () => Get.to(() => const ReportScreen()),
                child: const ScreenCard(
                    title: "24.06.30 소방구역 불법 주정차 신고",
                    contents: [
                      Text(
                        "진행중",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.indigo),
                      )
                    ]),
              )
            ],
          )
        ],
      ),
      bottomNavigationBar: BottomNavigation(
        onTap: (int index) async {
          controller.changePage(index);
        },
      ),
    );
  }

  Widget buildStatusChoice(int index, String title) {
    bool isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          landed = false;
          selectedIndex = index;
        });
      },
      child: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.black : Colors.grey,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontSize: 20,
        ),
      ),
    );
  }
}
