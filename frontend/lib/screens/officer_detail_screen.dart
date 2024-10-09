import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:frontend/components/common/top_bar.dart';
import 'package:frontend/services/api_service.dart';
import 'package:frontend/components/report_screen/report_screen_list_item.dart';
import 'package:frontend/components/common/button.dart';
import 'package:frontend/controller.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class OfficerDetailScreen extends StatelessWidget {
  final Map<String, dynamic> reportData;

  const OfficerDetailScreen({super.key, required this.reportData});

  Future<void> handleAcceptReport(bool decision) async {
    final apiService = ApiService();
    final formData = {
      "reportId": reportData['reportId'],
      "memberName": reportData['memberName'],
      "decision": decision,
    };

    final response = await apiService.acceptReport(formData);

    if (response != null) {
      Get.snackbar(
        "처리 완료",
        decision ? "신고가 수용되었습니다." : "신고가 불수용되었습니다.",
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      Get.snackbar(
        "오류",
        "신고 처리 중 문제가 발생했습니다.",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final MainController controller = Get.put(MainController());
    final String dateTimeString = reportData['datetime'] as String;
    final DateTime reportDateTime =
        DateFormat('yyyy-MM-dd HH:mm:ss:SSS').parse(dateTimeString);
    bool isCompleted = reportData['status'] == '수용';

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: TopBar(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    DateFormat('yy.MM.dd').format(reportDateTime),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Text(
                    reportData['title'] ?? "제목 없음",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: SizedBox(
                  width: 400,
                  child: Image.asset(
                    "assets/images/busstop_guide_image.png",
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
              const ReportScreenListItem(title: "분류", content: "불법 주정차"),
              ReportScreenListItem(
                  title: "신고 일시",
                  content: DateFormat('yy.MM.dd HH:mm').format(reportDateTime)),
              ReportScreenListItem(
                title: "진행 상황",
                content: reportData['status'] ?? "처리중",
                fontColor: isCompleted ? Colors.green : Colors.red,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Button(
                    text: "수용",
                    onPressed: () => handleAcceptReport(true),
                    horizontal: 20,
                    vertical: 10,
                    fontSize: 16,
                  ),
                  Button(
                    text: "불수용",
                    onPressed: () => handleAcceptReport(false),
                    horizontal: 20,
                    vertical: 10,
                    fontSize: 16,
                    backgroundColor: Colors.red,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  final lat = reportData['latitude'];
                  final long = reportData['longitude'];
                  Get.to(() => MapScreen(latitude: lat, longitude: long));
                },
                child: const Center(
                  child: Text(
                    "지도에서 위치 보기",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MapScreen extends StatelessWidget {
  final double latitude;
  final double longitude;

  const MapScreen({super.key, required this.latitude, required this.longitude});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('위치 보기'),
      ),
      body: FlutterMap(
        options: MapOptions(
            initialCenter: LatLng(latitude, longitude), initialZoom: 18),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: LatLng(latitude, longitude),
                width: 80.0,
                height: 80.0,
                child: const Icon(
                  Icons.location_pin,
                  color: Colors.red,
                  size: 40,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
