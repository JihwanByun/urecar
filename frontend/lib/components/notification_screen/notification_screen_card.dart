import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationScreenCard extends StatelessWidget {
  final String content;
  final VoidCallback onRemoveButtonPressed;
  final String datetime;
  final VoidCallback onTextTap;
  const NotificationScreenCard(
      {super.key,
      required this.content,
      required this.onRemoveButtonPressed,
      required this.datetime,
      required this.onTextTap});

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(datetime);
    Duration difference = DateTime.now()
        .toUtc()
        .add(const Duration(hours: -9))
        .difference(dateTime);
    String timeAgo;
    if (difference.inDays >= 1) {
      timeAgo = '${difference.inDays} 일 전';
    } else if (difference.inHours >= 1) {
      timeAgo = '${difference.inHours} 시간 전';
    } else if (difference.inMinutes >= 1) {
      timeAgo = '${difference.inMinutes} 분 전';
    } else {
      timeAgo = '방금 전';
    }
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      color: Theme.of(context).cardColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  timeAgo,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: onTextTap,
                    child: Text(
                      content,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 25,
                  child: TextButton(
                      onPressed: onRemoveButtonPressed,
                      style: TextButton.styleFrom(
                        splashFactory: NoSplash.splashFactory,
                      ),
                      child: const Text(
                        "X",
                        textAlign: TextAlign.center,
                      )),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
