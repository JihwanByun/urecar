import 'package:flutter/material.dart';
import 'package:frontend/components/common/bottom_navigation.dart';
import 'package:frontend/components/common/top_bar.dart';
import 'package:frontend/controller.dart';
import 'package:get/get.dart';
import 'package:frontend/components/common/spinner.dart';
import 'package:frontend/components/common/toggle_button.dart'; // 토글 버튼 컴포넌트 import

class SafetyNewsScreen extends StatefulWidget {
  const SafetyNewsScreen({super.key});

  @override
  State<SafetyNewsScreen> createState() => _SafetyNewsScreenState();
}

class _SafetyNewsScreenState extends State<SafetyNewsScreen> {
  final MainController controller = Get.put(MainController());
  final ScrollController _scrollController = ScrollController();
  List<int> newsList = [];
  bool isLoading = false;
  int selectedTab = 0; // 현재 선택된 탭 상태 관리

  @override
  void initState() {
    super.initState();
    _loadMoreNews();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !isLoading) {
        _loadMoreNews();
      }
    });
  }

  void _loadMoreNews() async {
    setState(() {
      isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      newsList.addAll(List.generate(5, (index) => newsList.length + index));
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: TopBar(
          onNotificationPressed: () {
            controller.showNotification();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ToggleButton(
              labels: ['공지사항', '안전뉴스'],
              initialIndex: selectedTab,
              onToggle: (index) {
                setState(() {
                  selectedTab = index;
                });
              },
            ),
            const SizedBox(height: 20),

            // 검색창
            _buildSearchField(),
            const SizedBox(height: 20),

            // 선택된 탭에 따라 내용 표시
            selectedTab == 0 ? _buildAnnouncementContent() : _buildNewsList(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(
        onTap: (int index) async {
          controller.changePage(index);
        },
      ),
    );
  }

  // 검색창 구성
  Widget _buildSearchField() {
    return TextField(
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        hintText: '검색',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        fillColor: Colors.grey[100],
        filled: true,
      ),
    );
  }

  // 공지사항 내용 구성
  Widget _buildAnnouncementContent() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            '🚨 시스템 점검 안내',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.blue,
            ),
          ),
          SizedBox(height: 10),
          Text(
            '안녕하세요, UreCar 사용자 여러분!\n\n'
            '보다 나은 서비스 제공을 위해 아래와 같이 시스템 점검을 실시할 예정입니다.\n\n'
            '⏰ 점검 시간: 2024년 9월 30일 (월) 00:00 ~ 04:00\n\n'
            '점검 시간 동안 서비스 이용이 일시적으로 제한될 수 있으니 미리 양해 부탁드립니다. '
            '불편을 최소화하기 위해 최선을 다하겠습니다.\n\n'
            '감사합니다.',
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  // 뉴스 리스트 (무한 스크롤) 구성
  Widget _buildNewsList() {
    return Expanded(
      child: ListView.builder(
        controller: _scrollController,
        itemCount: newsList.length + (isLoading ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == newsList.length) {
            return const Spinner();
          }

          return _buildNewsItem();
        },
      ),
    );
  }

  // 뉴스 아이템 구성
  Widget _buildNewsItem() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 350,
              height: 150,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 10),
            const Text(
              '자전거, 전동킥보드 음주운전 안돼요...교통안전캠페인',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              '자세한 내용: 교통 안전 캠페인의 주요 내용을 포함하여...',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
