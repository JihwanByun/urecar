import 'package:flutter/material.dart';
import 'package:frontend/screens/officer_detail_screen.dart';
import 'package:frontend/components/common/screen_card.dart';
import 'package:frontend/components/common/top_bar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:frontend/services/api_service.dart';

class OfficerScreen extends StatefulWidget {
  const OfficerScreen({super.key});

  @override
  State<OfficerScreen> createState() => _OfficerScreenState();
}

class _OfficerScreenState extends State<OfficerScreen> {
  final RxList<Map<String, dynamic>> reportList = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void initState() {
    super.initState();
    fetchReportData();
  }

  Future<void> fetchReportData() async {
    final apiService = ApiService();
    final responseData = await apiService.findOfficialReport();

    if (responseData is List) {
      reportList.value = List<Map<String, dynamic>>.from(responseData);
    }
    isLoading.value = false;
  }

  Future<void> goToReportDetail(String reportId) async {
    final apiService = ApiService();
    final specificReportData =
        await apiService.findSpecificOfficialReport(reportId);

    if (specificReportData != null) {
      Get.to(() => OfficerDetailScreen(reportData: specificReportData));
    } else {
      Get.snackbar('오류', '상세 정보를 불러오는 중 문제가 발생했습니다.',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: TopBar(),
      ),
      body: Obx(() => isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                const SizedBox(height: 20),
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
                      final String dateString = reportList[index]['date'];
                      final DateTime reportDate =
                          DateFormat('yyyy-MM-dd HH:mm:ss:SSS')
                              .parse(dateString);

                      return GestureDetector(
                        onTap: () => goToReportDetail(
                          reportList[index]['reportId'].toString(),
                        ),
                        child: ScreenCard(
                          title:
                              "${DateFormat('yy.MM.dd').format(reportDate)} ${reportList[index]['type']}",
                          contents: [
                            Text(
                              reportList[index]['memberName'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                )
              ],
            )),
    );
  }
}
