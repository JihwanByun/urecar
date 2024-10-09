import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:frontend/components/common/top_bar.dart';

class OfficerDetailScreen extends StatelessWidget {
  final Map<String, dynamic> reportData;

  const OfficerDetailScreen({super.key, required this.reportData});

  @override
  Widget build(BuildContext context) {
    final String dateTimeString = reportData['date'] as String;
    final DateTime reportDateTime =
        DateFormat('yyyy-MM-dd HH:mm:ss:SSS').parse(dateTimeString);

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: TopBar(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 상단 신고 정보 (날짜와 제목)
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
                    "정류장 불법 주정차 신고", // 하드코딩된 신고 제목
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 이미지가 없다는 메시지
              const Center(
                child: Text(
                  "이미지가 없습니다.",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ),
              const SizedBox(height: 20),

              // 분류와 정보
              const Text(
                "분류",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const Text(
                "불법 주정차", // 하드코딩된 분류
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 10),

              // 신고 일시
              const Text(
                "신고 일시",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                DateFormat('yy.MM.dd HH:mm').format(reportDateTime),
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 10),

              // 진행 상황
              const Text(
                "진행 상황",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                "처리중", // 하드코딩된 상태
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.lightGreen, // 처리중일 때의 색상
                ),
              ),
              const SizedBox(height: 20),

              // 지도 보기 버튼
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
                  final url =
                      'https://www.google.com/maps/search/?api=1&query=$lat,$long';
                  Get.snackbar("지도 열기", "위치 정보: ($lat, $long)");
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
