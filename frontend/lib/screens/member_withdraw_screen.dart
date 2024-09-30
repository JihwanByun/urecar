import 'package:flutter/material.dart';
import 'package:frontend/components/common/bottom_navigation.dart';
import 'package:frontend/components/common/top_bar.dart';
import 'package:get/get.dart';
import 'package:frontend/controller.dart';
import 'package:frontend/components/common/button.dart';

class MemberWithdrawScreen extends StatefulWidget {
  const MemberWithdrawScreen({super.key});

  @override
  State<MemberWithdrawScreen> createState() => _MemberWithdrawScreenState();
}

class _MemberWithdrawScreenState extends State<MemberWithdrawScreen> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    final MainController controller = Get.put(MainController());

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
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 상단 텍스트
            const Text(
              '회원 탈퇴',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            Icon(
              Icons.delete_forever,
              size: 100,
              color: Colors.red,
            ),
            const SizedBox(height: 20),
            const Text(
              '정말로 탈퇴하시겠습니까?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              '회원님과 관련된 모든 데이터는 삭제되며,\n이 작업은 취소할 수 없습니다.',
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  value: isChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      isChecked = value ?? false;
                    });
                  },
                ),
                const Flexible(
                  child: Text(
                    '위의 내용을 모두 확인하였으며, 탈퇴에 동의합니다.',
                    style: TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Button(
                  text: '취소',
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  horizontal: 20,
                  vertical: 10,
                  fontSize: 16,
                  radius: 10,
                  backgroundColor: Colors.grey,
                  contentColor: Colors.black,
                ),
                Button(
                  text: '확인',
                  onPressed: isChecked
                      ? () {
                          print("탈퇴 처리됨");
                          Navigator.of(context).pop();
                        }
                      : null,
                  horizontal: 20,
                  vertical: 10,
                  fontSize: 16,
                  radius: 10,
                  backgroundColor: Colors.red,
                  contentColor: Colors.white,
                ),
              ],
            ),
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
}
