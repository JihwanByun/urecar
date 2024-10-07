import 'package:flutter/material.dart';
import 'package:frontend/components/common/bottom_navigation.dart';
import 'package:frontend/components/common/screen_card.dart';
import 'package:frontend/components/common/top_bar.dart';
import 'package:frontend/components/history_screen/date_button.dart';
import 'package:frontend/controller.dart';
import 'package:frontend/screens/history_detail_screen.dart';
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


  List<Map<String, dynamic>> reportList = [
    {
      "date": "24.06.30",
      "title": "소방구역 불법 주정차 신고",
      "status": "진행중",
      "color": Colors.indigo
    },
    {
      "date": "24.06.28",
      "title": "도로변 무단 주차 신고",
      "status": "수용",
      "color": Colors.green
    },
    {
      "date": "24.06.25",
      "title": "인도 위 불법 주정차 신고",
      "status": "불수용",
      "color": Colors.red
    },
    {
      "date": "24.06.22",
      "title": "공사장 불법 주차 신고",
      "status": "진행중",
      "color": Colors.indigo
    },
    {
      "date": "24.06.20",
      "title": "자전거 도로 주정차 신고",
      "status": "취소",
      "color": Colors.grey
    },
    {
      "date": "24.06.15",
      "title": "전기차 충전구역 불법 주차 신고",
      "status": "수용",
      "color": Colors.green
    },
    {
      "date": "24.06.10",
      "title": "장애인 주차구역 불법 주정차 신고",
      "status": "불수용",
      "color": Colors.red
    },
    {
      "date": "24.06.05",
      "title": "공원 출입구 불법 주정차 신고",
      "status": "진행중",
      "color": Colors.indigo
    },
    {
      "date": "24.06.02",
      "title": "아파트 단지 내 불법 주정차 신고",
      "status": "취소",
      "color": Colors.grey
    },
    {
      "date": "24.05.30",
      "title": "주차장 입구 불법 주정차 신고",
      "status": "수용",
      "color": Colors.green
    },
  ];

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

    List<Map<String, dynamic>> getFilteredReportList() {
      return reportList.where((report) {
        final String dateString = report["date"] as String;
        final DateTime reportDate = DateFormat('yy.MM.dd').parse(dateString);
        final isInDateRange =
            reportDate.isAfter(startDate) && reportDate.isBefore(lastDate);

        if (selectedIndex == 0) {
          return isInDateRange;
        } else if (selectedIndex == 1) {
          return isInDateRange && report["status"] == "진행중";
        } else if (selectedIndex == 2) {
          return isInDateRange && report["status"] == "수용";
        } else if (selectedIndex == 3) {
          return isInDateRange && report["status"] == "불수용";
        } else if (selectedIndex == 4) {
          return isInDateRange && report["status"] == "취소";
        }
        return isInDateRange;
      }).toList();
    }

    // 필터링된 리스트
    List<Map<String, dynamic>> filteredReportList = getFilteredReportList();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: TopBar(),
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
              Padding(
                padding: const EdgeInsets.only(top: 8, right: 20),
                child: Text(
                  "최근(${filteredReportList.length}건)",
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredReportList.length,
              itemBuilder: (context, index) {
                final String dateString = filteredReportList[index]['date'];
                final DateTime reportDate =
                    DateFormat('yy.MM.dd').parse(dateString);

                return GestureDetector(
                  onTap: () => Get.to(() => HistoryDetailScreen(
                        reportData: filteredReportList[index],
                      )),
                  child: ScreenCard(
                    title:
                        "${DateFormat('yy.MM.dd').format(reportDate)} ${filteredReportList[index]['title']}",
                    contents: [
                      Text(
                        filteredReportList[index]['status'],
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: filteredReportList[index]['color'],
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
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
