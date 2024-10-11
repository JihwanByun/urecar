import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:frontend/components/common/top_bar.dart';
import 'package:frontend/services/api_service.dart';
import 'package:frontend/components/report_screen/report_screen_list_item.dart';
import 'package:frontend/components/common/button.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class OfficerDetailScreen extends StatefulWidget {
  final Map<String, dynamic> reportData;

  const OfficerDetailScreen({super.key, required this.reportData});

  @override
  _OfficerDetailScreenState createState() => _OfficerDetailScreenState();
}

class _OfficerDetailScreenState extends State<OfficerDetailScreen> {
  bool? decision;

  Future<void> handleAcceptReport() async {
    final apiService = ApiService();
    final formData = {
      "reportId": widget.reportData['reportId'],
      "memberName": widget.reportData['memberName'],
      "decision": decision,
    };

    final response = await apiService.acceptReport(formData);

    if (response != null) {
      Get.snackbar(
        "처리 완료",
        decision == true ? "신고가 수용되었습니다." : "신고가 불수용되었습니다.",
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
    final Uint8List bitesImage = widget.reportData.containsKey("firstImage") &&
            widget.reportData["firstImage"] != null
        ? base64Decode(widget.reportData["firstImage"])
        : Uint8List(0);

    final String dateTimeString = widget.reportData['datetime'] as String;
    final DateTime reportDateTime =
        DateFormat('yyyy-MM-dd HH:mm:ss:SSS').parse(dateTimeString);
    bool isCompleted = widget.reportData['processStatus'] == '수용';

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
                    widget.reportData['type'] ?? "제목 없음",
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
                  width: 250,
                  child: bitesImage.isNotEmpty
                      ? Image.memory(
                          bitesImage,
                          fit: BoxFit.fitWidth,
                        )
                      : const Center(
                          child: Text(
                            "이미지가 없습니다.",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ),
                ),
              ),
              ReportScreenListItem(
                title: "신고자",
                content: widget.reportData['memberName'] ?? "이름 없음",
              ),
              ReportScreenListItem(
                title: "신고 내용",
                content: widget.reportData['content'] ?? "내용 없음",
              ),
              ReportScreenListItem(
                title: "신고 일시",
                content: DateFormat('yy.MM.dd HH:mm').format(reportDateTime),
              ),
              ReportScreenListItem(
                title: "진행 상황",
                content: widget.reportData['processStatus'] ?? "처리중",
                fontColor: isCompleted
                    ? Theme.of(context).primaryColor
                    : const Color(0xffe32222),
              ),
              ReportScreenListItem(
                title: '위치',
                content: Button(
                  text: "지도 보기",
                  onPressed: () {
                    final lat = widget.reportData['latitude'];
                    final long = widget.reportData['longitude'];
                    Get.to(() => MapScreen(latitude: lat, longitude: long));
                  },
                  horizontal: 5,
                  vertical: 10,
                  fontSize: 16,
                  backgroundColor: Colors.blueAccent,
                  radius: 10,
                  contentColor: Colors.white,
                ),
              ),
              ReportScreenListItem(
                title: '결과',
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Radio(
                      value: true,
                      groupValue: decision,
                      onChanged: (value) {
                        setState(() {
                          decision = value;
                        });
                      },
                    ),
                    const Text("수용"),
                    const SizedBox(width: 20),
                    Radio(
                      value: false,
                      groupValue: decision,
                      onChanged: (value) {
                        setState(() {
                          decision = value;
                        });
                      },
                    ),
                    const Text("불수용"),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Button(
                    text: "취소",
                    onPressed: () {
                      Get.back();
                    },
                    horizontal: 5,
                    vertical: 10,
                    fontSize: 14,
                    backgroundColor: Colors.grey,
                  ),
                  Button(
                    text: "확인",
                    onPressed: decision == null
                        ? null
                        : () async {
                            await handleAcceptReport();
                            await Future.delayed(const Duration(seconds: 3));
                            Get.offAllNamed('/officer');
                          },
                    horizontal: 5,
                    vertical: 10,
                    fontSize: 14,
                    backgroundColor: decision == null
                        ? Colors.grey
                        : Theme.of(context).primaryColor,
                  ),
                ],
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
          initialCenter: LatLng(latitude, longitude),
          initialZoom: 18,
        ),
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
                  color: Color(0xffe32222),
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
