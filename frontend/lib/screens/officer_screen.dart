import 'package:flutter/material.dart';
import 'package:frontend/components/common/screen_card.dart';
import 'package:frontend/components/common/top_bar.dart';
import 'package:frontend/controller.dart';
import 'package:frontend/screens/history_detail_screen.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:frontend/services/api_service.dart';

class OfficerScreen extends StatefulWidget {
  const OfficerScreen({super.key});

  @override
  State<OfficerScreen> createState() => _OfficerScreenState();
}

class _OfficerScreenState extends State<OfficerScreen> {
  List<Map<String, dynamic>> reportList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchReportData();
  }

  Future<void> fetchReportData() async {
    final apiService = ApiService();
    final responseData = await apiService.findOfficialReport();

    setState(() {
      if (responseData is List) {
        reportList = List<Map<String, dynamic>>.from(responseData);
      }
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                const SizedBox(
                  height: 20,
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
                      final String dateString = reportList[index]['date'];
                      final DateTime reportDate =
                          DateFormat('yyyy-MM-dd HH:mm:ss:SSS')
                              .parse(dateString);

                      return GestureDetector(
                        onTap: () => Get.to(() => HistoryDetailScreen(
                              reportData: reportList[index],
                            )),
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
            ),
    );
  }
}
