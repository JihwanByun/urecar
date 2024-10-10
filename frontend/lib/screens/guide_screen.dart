import 'package:flutter/material.dart';
import 'package:frontend/components/common/bottom_navigation.dart';
import 'package:frontend/components/common/top_bar.dart';
import 'package:frontend/components/guide_screen/guide_image.dart';
import 'package:frontend/controller.dart';
import 'package:get/get.dart';
import 'package:frontend/components/common/toggle_button.dart';

class GuideScreen extends StatefulWidget {
  const GuideScreen({super.key});

  @override
  State<GuideScreen> createState() => _GuideScreenState();
}

class _GuideScreenState extends State<GuideScreen> {
  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final MainController controller = Get.put(MainController());

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: TopBar(),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ToggleButton(
                  labels: const ['6대 불법주정차', '기타 불법주정차'],
                  initialIndex: selectedTab,
                  onToggle: (index) {
                    setState(() {
                      selectedTab = index;
                    });
                  },
                ),
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: Text("* 지역마다 단속 기준에 다소 차이가 있을 수 있습니다."),
                  ),
                ],
              ),
              Column(
                children: selectedTab == 0
                    ? [
                        const GuideImage(
                          path: "assets/images/fireplug_guide_image.png",
                          title: "소화전 불법주정차",
                          content:
                              "신고 대상 차량의 번호판과 주정차 금지 표지판이나 적색 복선이 보이게 촬영해주세요.",
                        ),
                        const GuideImage(
                          path: "assets/images/intersection_guide_image.png",
                          title: "교차로 불법주정차",
                          content:
                              "신고 대상 차량의 번호판과 주정차금지 규제 표시 또는 노면의 황색 실선, 복선이 보이게 촬영해주세요.",
                        ),
                        const GuideImage(
                          path: "assets/images/sidewalk_guide_image.png",
                          title: "인도 불법주정차",
                          content:
                              "주간에 신고 대상 차량의 번호판과 함께 보도와 차도가 명확히 구분되어 있는 도로에서 보행자가 통행할 수 있도록 한 도로의 부분이 보이게 촬영해주세요.",
                        ),
                        const GuideImage(
                          path: "assets/images/crosswalk_guide_image.png",
                          title: "횡단보도 불법주정차",
                          content: "신고 대상 차량의 번호판과 횡단보도나 정지선이 침범된 모습을 촬영해주세요.",
                        ),
                        const GuideImage(
                          path: "assets/images/children_guide_image.png",
                          title: "어린이 보호구역 불법주정차",
                          content:
                              "주간에 신고 대상 차량의 번호판과 초등학교, 특수학교 정문 앞 도로임이 잘 보이게 촬영해주세요.",
                        ),
                        const GuideImage(
                          path: "assets/images/busstop_guide_image.png",
                          title: "정류소 불법주정차",
                          content:
                              "신고 대상 차량의 번호판과 정류소 표지판이나 정차박스가 잘 보이게 촬영해주세요.",
                        ),
                      ]
                    : [
                        const GuideImage(
                          path: "assets/images/etc_guide_image.png",
                          title: "기타 불법주정차",
                          content: "황색 선과 신고 대상 차량의 번호판이 잘 보이게 촬영해주세요.",
                        ),
                      ],
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigation(
        onTap: (int index) async {
          controller.changePage(index);
        },
      ),
    );
  }
}
