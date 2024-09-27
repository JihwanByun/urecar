import 'package:flutter/material.dart';

class ToggleButton extends StatefulWidget {
  final List<String> labels;
  final ValueChanged<int> onToggle;
  final int initialIndex;

  const ToggleButton({
    super.key,
    required this.labels,
    required this.onToggle,
    this.initialIndex = 0,
  });

  @override
  _ToggleButtonState createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<ToggleButton> {
  late List<bool> isSelected;

  @override
  void initState() {
    super.initState();
    isSelected = List.generate(
        widget.labels.length, (index) => index == widget.initialIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          for (int i = 0; i < widget.labels.length; i++) ...[
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    for (int j = 0; j < isSelected.length; j++) {
                      isSelected[j] = j == i;
                    }
                  });
                  widget.onToggle(i);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.only(
                      topLeft: i == 0 ? const Radius.circular(20) : Radius.zero,
                      bottomLeft:
                          i == 0 ? const Radius.circular(20) : Radius.zero,
                      topRight: i == widget.labels.length - 1
                          ? const Radius.circular(20)
                          : Radius.zero,
                      bottomRight: i == widget.labels.length - 1
                          ? const Radius.circular(20)
                          : Radius.zero,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      widget.labels[i],
                      style: TextStyle(
                        color: isSelected[i] ? Colors.black : Colors.grey,
                        fontWeight:
                            isSelected[i] ? FontWeight.bold : FontWeight.normal,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (i != widget.labels.length - 1)
              Container(
                width: 1,
                height: 30,
                color: Colors.grey,
              ),
          ]
        ],
      ),
    );
  }
}
