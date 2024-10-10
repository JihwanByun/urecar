import 'package:flutter/material.dart';
import 'package:frontend/components/common/bottom_navigation.dart';
import 'package:frontend/components/common/screen_card.dart';
import 'package:frontend/components/common/top_bar.dart';
import 'package:frontend/components/history_screen/date_button.dart';
import 'package:frontend/controller.dart';
import 'package:frontend/screens/report_screen.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:frontend/services/api_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  DateTime lastDate = DateTime.now();
  DateTime startDate = DateTime.now().subtract(const Duration(days: 92));
  int selectedIndex = 0;

  List<Map<String, dynamic>> reportList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchReportData();
  }

  Future<void> fetchReportData() async {
    final apiService = ApiService();
    final MainController controller = Get.put(MainController());
    final String memberId = controller.memberId.value.toString();
    final String startDateFormatted =
        DateFormat('yyyy-MM-dd').format(startDate);
    final String endDateFormatted = DateFormat('yyyy-MM-dd').format(lastDate);
    final String? processStatus = getProcessStatus(selectedIndex);

    final response = await apiService.findReports(
      memberId,
      startDateFormatted,
      endDateFormatted,
      processStatus,
    );

    setState(() {
      if (response is List && response.isNotEmpty) {
        reportList = List<Map<String, dynamic>>.from(response);
      } else {
        reportList = [];
      }
      isLoading = false;
    });
  }

  String? getProcessStatus(int index) {
    switch (index) {
      case 1:
        return "ONGOING";
      case 2:
        return "ACCEPTED";
      case 3:
        return "UNACCEPTED";
      default:
        return null;
    }
  }

  Map<String, dynamic> mapProcessStatusToDisplay(String status) {
    switch (status) {
      case "ACCEPTED":
        return {
          "text": "수용",
          "color": Theme.of(context).primaryColor,
        };
      case "UNACCEPTED":
        return {
          "text": "불수용",
          "color": const Color(0xffe32222),
        };
      default:
        return {
          "text": "진행중",
          "color": Colors.black,
        };
    }
  }

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

  Future<void> navigateToDetailScreen(String reportId) async {
    final apiService = ApiService();
    final response = await apiService.findSpecificReport(reportId);

    if (response != null && response is Map<String, dynamic>) {
      if (["ONGOING", "FIRST_ANALYSIS_SUCCESS"]
          .contains(response["processStatus"])) {
        Get.to(() => ReportScreen(
              res: response,
              isSecond: true,
            ));
      } else {
        Get.to(() => ReportScreen(res: response));
      }
    } else {
      Get.snackbar(
        "오류",
        "신고 세부 정보를 불러오는 중 문제가 발생했습니다.",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final MainController controller = Get.put(MainController());
    String lastDateFormat = DateFormat('yy.MM.dd').format(lastDate);
    String startDateFormat = DateFormat('yy.MM.dd').format(startDate);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: TopBar(),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DateButton(
                      date: startDateFormat,
                      onPressed: () async {
                        final DateTime temp =
                            await selectDate(context, startDate, lastDate);
                        if (temp != startDate) {
                          setState(() {
                            startDate = temp;
                          });
                          fetchReportData();
                        }
                      },
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Icon(Icons.swap_horiz_sharp, size: 35),
                    ),
                    DateButton(
                      date: lastDateFormat,
                      onPressed: () async {
                        final DateTime temp =
                            await selectDate(context, lastDate, DateTime.now());
                        if (temp != lastDate) {
                          setState(() {
                            lastDate = temp;
                          });
                          fetchReportData();
                        }
                      },
                    )
                  ],
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    buildStatusChoice(0, "전체"),
                    buildStatusChoice(1, "진행중"),
                    buildStatusChoice(2, "수용"),
                    buildStatusChoice(3, "불수용"),
                    const SizedBox(width: 40),
                  ],
                ),
                const SizedBox(height: 6),
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
                        "최근(${reportList.length}건)",
                        textAlign: TextAlign.end,
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: reportList.length,
                    itemBuilder: (context, index) {
                      final String dateTimeString =
                          reportList[index]['datetime'];
                      final DateTime reportDate =
                          DateFormat('yyyy-MM-dd HH:mm:ss:SSS')
                              .parse(dateTimeString);
                      final statusInfo = mapProcessStatusToDisplay(
                          reportList[index]['processStatus']);

                      return GestureDetector(
                        onTap: () => navigateToDetailScreen(
                            reportList[index]['reportId'].toString()),
                        child: ScreenCard(
                          title:
                              "${DateFormat('yy.MM.dd').format(reportDate)} ${reportList[index]['type'] ?? '타입 없음'}",
                          contents: [
                            Text(
                              statusInfo['text'],
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: statusInfo['color'],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
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
        fetchReportData();
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
